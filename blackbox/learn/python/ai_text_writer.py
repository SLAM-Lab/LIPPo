#!/usr/bin/python
import numpy as np
from sklearn.linear_model.bayes import BayesianRidge
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.tree import DecisionTreeRegressor
from sklearn.linear_model import LinearRegression
import sys


def write_data_file(filename, ai):
    ai_file = open(filename, "w")
    if isinstance(ai, list):
        ai_file.write("{}\n".format(len(ai)))
        for item in ai:
            if isinstance(item, GradientBoostingRegressor):
                ai_file.write("GB\n")
                write_gradient_boost(ai_file, item)
            elif isinstance(item, DecisionTreeRegressor):
                ai_file.write("DT\n")
                write_decision_tree(ai_file, item)
            elif isinstance(item, BayesianRidge):
                ai_file.write("Linear\n")
                write_linear(ai_file, item)
            elif isinstance(item, LinearRegression):
                ai_file.write("Linear\n")
                write_linear(ai_file, item)
            else:
                sys.exit(2)
    else:
        print type(ai)
        sys.exit(2)
    ai_file.close()


def write_int(item, ai_file):
    if not isinstance(item, int):

        sys.exit(2)
    else:
        ai_file.write(str(item)+"\n")


def write_list(item, ai_file):
    if not isinstance(item, list) and not isinstance(item, np.ndarray):
        sys.exit(2)
    else:
        item = np.array(item)
        if (item.dtype == np.dtype('int64') or
                    item.dtype == np.dtype('float64')):
            # DEBUG("OK: {}".format(item.dtype))
            pass
        else:
            # ERROR("illegal: {}".format(item.dtype))
            sys.exit(1)

        for i in item:
            ai_file.write("{} ".format(i))
        ai_file.write("\n")


def write_decision_tree(ai_file, model):
    def convert(l):
        ret = np.zeros(len(l), np.float64)
        for idx, item in enumerate(l):
            ret[idx] = item
        return ret

    write_int(model.tree_.node_count, ai_file)
    write_list(model.tree_.children_left, ai_file)
    write_list(model.tree_.children_right, ai_file)
    write_list(model.tree_.feature, ai_file)
    write_list(model.tree_.threshold, ai_file)
    write_list(convert(model.tree_.value), ai_file)
    return


def write_gradient_boost(ai_file, model):
    write_constant(ai_file, model.init_.mean)
    write_constant(ai_file, model.learning_rate)
    write_int(len(model.estimators_), ai_file)
    tot = 0
    for rows in model.estimators_:
        write_int(len(rows), ai_file)
        tot += len(rows)
        for item in rows:
            write_decision_tree(ai_file, item)
    return


def write_linear(ai_file, model):
    tmp = np.zeros(len(model.coef_) + 1, np.float64)
    tmp[0] = model.intercept_
    for i, c in enumerate(model.coef_):
        tmp[i + 1] = c
    write_list(tmp, ai_file)
    return


def write_constant(ai_file, val):
    tmp = np.zeros(1, np.float64)
    tmp[0] = val
    write_list(tmp, ai_file)
    return


def list_2d_vector(var_name, values):
    value_array = []
    if type(values) is np.ndarray or type(values) is list:
        for val in values:
            val_array = []
            for i in val:
                val_array.append(str(i))
            value_array.append("{" + ','.join(val_array) + "}\n")
    else:
        print "ERROR!!"
        exit(1)
        value_array.append(str(values))
    ret = var_name + "={" + ','.join(value_array) + "};\n"
    #  print ret
    return ret

ai_model_read = '''
#include "tree.h"
#include "linear.h"
#include "gradientboost.h"
using namespace std;

void ai_model_read(vector<Regression*>& ai){
    ifstream iff(%s);
    string buf;
    if(iff.good()==true)
    {
        vector<int> setting;
        getline(iff, buf);
        parser(buf," ",setting);
        int len=setting[0];
        ai.resize(len);
        for(int i=0; i<len; i++)
        {
          getline(iff, buf);
          if(buf=="DT")
          {
            ai[i]=new Tree(iff);
            //cerr<<"DTREE";
          }
          else if(buf=="GB")
          {
            ai[i]=new GradientBoost(iff);
            //cerr<<"db";
          }
          else if(buf=="Linear")
          {
            ai[i]=new LinearRegression(iff);
            //cerr<<"linear";
          }
          else
          {
            exit(2);
          }
        }
    }
    else
    {
        exit(2);
    }
}
'''
def list2array(var_name, values):
    value_array = []
    if (type(values) is np.ndarray and len(values.shape) > 0) or (type(values) is list):
        for i in values:
            value_array.append(str(i))
    else:
        value_array.append(str(values))
    ret = var_name + "={" + ','.join(value_array) + "};\n"
    #  print ret
    return ret



def write_header(filename, features, test_data_x, test_data_y):
    dump_file = open(filename, "w")
    dump_file.write(ai_model_read % ('"'+filename+'.data"'))
    dump_file.write(list2array("uint8_t test_data[]",test_data_x))
    dump_file.write("float test_predict="+str(sum(test_data_y)/len(test_data_y))+";")

    dump_file.write(list_2d_vector("vector<vector<int> >  features", features))

    #   dump_file.write(list2array("uint8_t test_data[]",td))
    #   dump_file.write(list2array("float test_predict[]",tp))
    dump_file.write('''


uint32_t* get_data(int id, uint8_t* data, uint32_t* buffer)
{
//  static std::vector<uint32_t> _data;
//  _data.erase(_data.begin(), _data.end());
  int idx=0;
  for(auto i : features[id])
  {
    buffer[idx]=data[i];
    idx++;
  }
  return buffer;
}
std::vector<Regression*> ai;
std::vector<Regression*>& get_ai()
{
  ai_model_read(ai);
  return ai;
}
#ifdef _OPEPMP
#ifndef _AVG_MODEL_
#include <omp.h>
#endif
#endif
double predict(uint8_t* data)
{
  static std::vector<Regression*>& ai=get_ai();
  double ret=0.0;
  int len=features.size();
#pragma omp parallel for reduction(+:ret)
  for(int i=0; i<len; i++)
  {
    uint32_t buffer[512];
    ret+=ai[i]->predict(get_data(i, data, buffer));
  }
  return ret/len;
}
''')


def write_regressors(filename, regressors, test_data_x, test_data_y):
    if isinstance(regressors, list):
        features = []
        models = []
        for feature_indices, regressor in regressors:
            features.append(feature_indices)
            models.append(regressor)
        write_data_file(filename+".data", models)
        write_header(filename, features, test_data_x, test_data_y)

# def binarySave(inFileName, outFileName):
#   print "InputFileName: ", inFileName
#   print "OutputFileName: ", outFileName
# def textSave(inFileName, outFileName):
#   print
# def usage():
#   print "TODO:"
#
# def main():
#   try:
#     opts,args= getopt.getopt(sys.argv[1:], "hi:o:b",["header", "input=","output=","binary"])
#   except:
#     print str(err)
#     usage()
#   outFileName=None
#   inFileName=None
#   binary =0
#   for o, a in opts:
#     if o in ("i","--input"):
#       inFileName = args
#     elif o in ("o","--output"):
#       outFileName = args
#     elif o in ("b","--binary"):
#       binary =1
#     elif o in ("h","--header"):
#       header =1
#     else:
#       print usage()
#       sys.exit(2)
#
# def test():
#   #ai=readAIFile("linear_save.pkl")
#   SET_LOG_LEVEL(2)
#
# # ai=readAIFile("../../whiteBox/learn/test/mat_non_pipe.pkl")
#   ai=readAIFile("dp_act_cc_power.pkl");
# #  X=[15 15 13 14 15 15 0 0 9 14 0 14 0 6 0 0 0 5 0 0 1 12 10 12 12 5 16 1 0 6 1 3 ]
#   print ai[5][2]
#   print "rea: ",ai[5][2][1].predict(X)
#   my=ai[5][2][1]
#   s=0.0
#   s=[]
#   for e in my.estimators_:
#     for f in e:
#       s.append(f.predict(X)[0])
#   print my.init_.predict(np.array(X))
#   print my.init_.mean
#   print my.learning_rate
#   print 1.80019+sum(s)*0.1
#   print np.mean((s[0]-s[1:])**2.0)
# #  print "total: ",s
#   
# #  write_data_file("gr_save.txt",ai,False)
#
# if __name__=="__main__":
#   #test()
#   SET_LOG_LEVEL(2)
#   ai=readAIFile(sys.argv[1])
#   writeFile(sys.argv[2],ai,False)
#   #writeHeader(sys.argv[2],ai)
