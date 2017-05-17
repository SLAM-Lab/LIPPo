#!/home/dlee/anaconda/bin/python
import numpy as np
import os.path
import time
from math import sqrt
from sklearn.metrics import r2_score
from sklearn.metrics import mean_absolute_error
from sklearn.metrics import mean_squared_error
from sklearn.metrics import explained_variance_score
from sklearn.ensemble import RandomForestRegressor
from sklearn.naive_bayes import GaussianNB
from sklearn.gaussian_process import GaussianProcess
from sklearn.naive_bayes import BernoulliNB
from sklearn.linear_model.bayes import BayesianRidge
import sklearn.linear_model
from sklearn import linear_model
from sklearn import tree
from StringIO import StringIO
from sklearn import svm
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.tree import DecisionTreeRegressor
import sys
import getopt
import pickle as pk


def list_to_array(valname, values):
    value_array = []
    if (type(values) is np.ndarray and len(values.shape) > 0) or (type(values) is list):
        for i in values:
            value_array.append(str(i))
    else:
        value_array.append(str(values))
    ret = valname + "={" + ','.join(value_array) + "};\n"
    return ret


def list_to_2d_map(valname, values):
    value_array = []
    for val in values:
        ft_map = []
        for _key, fts in val.iteritems():
            ft_array = []
            if fts is None:
                fts = []
            for ft in fts:
                ft_array.append(str(ft))
            ft_map.append("{" + str(_key) + "," + "{" + ','.join(ft_array) + "}}\n")
        value_array.append("{" + ",".join(ft_map) + "}")
    ret = valname + "={" + ','.join(value_array) + "};\n"
    return ret

def write_hpp(outfile_name, ai):
    ai_file = open(outfile_name, "w")
    ai_file.write('#include "tree.h"\n')
    ai_file.write('#include "linear.h"\n')
    ai_file.write('#include "gradientboost.h"\n')
    ai_file.write('using namespace std;\n')
    if isinstance(ai, list):
        max_id = -1
        num_models = len(ai)
        for (_id, _key, (constant, item), feature, td, tp) in ai:
            if _id > max_id:
                max_id = _id
            # Write coefficient !
        features = []
        for i in range(0, max_id + 1):
            features.append(dict())
        for (_id, _key, (constant, item), feature, td, tp) in ai:
            features[_id][_key] = feature
            td = [int(x) for x in td]
            ai_file.write(list_to_array("uint8_t test_data_{}_{}[]\n".format(_id, _key), td))
            ai_file.write("double test_power_{}_{} = {};\n".format(_id, _key, np.squeeze(tp)))
            if isinstance(item, DecisionTreeRegressor):
                ai_file.write(list_to_array("int dt_children_left_{}_{}[]".format(_id, _key), item.tree_.children_left))
                ai_file.write(list_to_array("int dt_children_right_{}_{}[]".format(_id, _key), item.tree_.children_right))
                ai_file.write(list_to_array("int dt_feature_{}_{}[]".format(_id, _key), item.tree_.feature))
                ai_file.write(list_to_array("double dt_threshold_{}_{}[]".format(_id, _key), item.tree_.threshold))
                ai_file.write(list_to_array("double dt_value_{}_{}[]".format(_id, _key), np.squeeze(item.tree_.value)))
            elif isinstance(item, BayesianRidge) or isinstance(item, LinearRegression):
                coeff = [item.intercept_] + item.coef_.tolist()
                ai_file.write(list_to_array("double li_coeff_{}_{}[]".format(_id, _key), coeff))
                ai_file.write("int li_coeff_len_{}_{}={};\n".format(_id, _key, len(coeff)))
            elif isinstance(item, GradientBoostingRegressor):
                ai_file.write("double gb_mean_{}_{}={};\n".format(_id, _key, item.init_.mean))
                ai_file.write("double gb_learning_rate_{}_{}={};\n".format(_id, _key, item.learning_rate))
                tot_node = 0
                for row_idx, rows in enumerate(item.estimators_):
                    for col_idx, ele in enumerate(rows):
                        ai_file.write(
                            list_to_array("int gb_children_left_{}_{}_{}_{}[]".format(_id, _key, row_idx, col_idx),
                                          ele.tree_.children_left))
                        ai_file.write(
                            list_to_array("int gb_children_right_{}_{}_{}_{}[]".format(_id, _key, row_idx, col_idx),
                                          ele.tree_.children_right))
                        ai_file.write(list_to_array("int gb_feature_{}_{}_{}_{}[]".format(_id, _key, row_idx, col_idx),
                                                    ele.tree_.feature))
                        ai_file.write(
                            list_to_array("double gb_threshold_{}_{}_{}_{}[]".format(_id, _key, row_idx, col_idx),
                                          ele.tree_.threshold))
                        ai_file.write(list_to_array("double gb_value_{}_{}_{}_{}[]".format(_id, _key, row_idx, col_idx),
                                                    np.squeeze(ele.tree_.value)))
                        tot_node += 1
                ai_file.write("int gb_total_node_{}_{}={};\n".format(_id, _key, tot_node))
                bigForest = []
                for row_idx, rows in enumerate(item.estimators_):
                    forest = []
                    for col_idx, ele in enumerate(rows):
                        forest.append(" Tree(" + \
                                      " gb_children_left_{}_{}_{}_{},".format(_id, _key, row_idx, col_idx) + \
                                      " gb_children_right_{}_{}_{}_{},".format(_id, _key, row_idx, col_idx) + \
                                      " gb_feature_{}_{}_{}_{},".format(_id, _key, row_idx, col_idx) + \
                                      " gb_threshold_{}_{}_{}_{},".format(_id, _key, row_idx, col_idx) + \
                                      " gb_value_{}_{}_{}_{}".format(_id, _key, row_idx, col_idx) + \
                                      ")")
                    myForest = "vector<Tree>({" + ",".join(forest) + "})"
                    bigForest.append(myForest)
                ai_file.write(
                    "vector<vector<Tree> > gb_forest_{}_{}( ".format(_id, _key) + '{' + ",".join(bigForest) + "});")

            elif constant is not None:
                coeff = [constant]
                ai_file.write(list_to_array("double li_coeff_{}_{}[]".format(_id, _key), coeff))
                ai_file.write("int li_coeff_len_{}_{}={};\n".format(_id, _key, len(coeff)))

        ai_file.write("void ai_model_read(vector<map<int, Regression*> >& ai){\n")
        ai_file.write("\tint max_id={};\n".format(max_id))
        ai_file.write("\tint num_model={};\n".format(num_models))
        ai_file.write("\tai.resize(max_id+1);\n")
        #    ai_file.write("\tfor(int i=0; i<num_model; i++)    {\n");
        for (_id, _key, (constant, item), feature, td, tp) in ai:
            if isinstance(item, DecisionTreeRegressor):
                ai_file.write("\tai[{}][{}]=new Tree({},{},{},{},{});\n".format(
                    _id, _key,
                    "dt_children_left_{}_{}".format(_id, _key),
                    "dt_children_right_{}_{}".format(_id, _key),
                    "dt_feature_{}_{}".format(_id, _key),
                    "dt_threshold_{}_{}".format(_id, _key),
                    "dt_value_{}_{}".format(_id, _key)))
            elif isinstance(item, BayesianRidge) or constant is not None or isinstance(item, LinearRegression):
                ai_file.write("\tai[{}][{}]=new LinearRegression({},{});\n".format(
                    _id, _key,
                    "li_coeff_{}_{}".format(_id, _key),
                    "li_coeff_len_{}_{}".format(_id, _key)))
            elif isinstance(item, GradientBoostingRegressor):
                ai_file.write("\tai[{}][{}]=new GradientBoost({},{},{},{});\n".format(
                    _id, _key
                    , "gb_forest_{}_{}".format(_id, _key)
                    , "gb_total_node_{}_{}".format(_id, _key)
                    , "gb_mean_{}_{}".format(_id, _key)
                    , "gb_learning_rate_{}_{}".format(_id, _key)
                ))
            #   ai_file.write("\t}\n");
        ai_file.write("}\n")

        ai_file.write(list_to_2d_map("vector<map<int, vector<int> > >  features", features))
        ai_file.write('''
inline
uint32_t* get_data(int id, int key, uint8_t* data, uint32_t* buffer)
{
//  static std::vector<uint32_t> _data;
//  _data.erase(_data.begin(), _data.end());
  int idx=0;
  for(auto i : features[id][key])
  {
    buffer[idx]=data[i];
    idx++;
  }
  return buffer;
}
std::vector<std::map<int, Regression*> > ai;
std::vector<std::map<int, Regression*> >& get_ai()
{
  ai_model_read(ai);
  return ai;
}
''')

        ai_file.write('''
//#include <omp.h>
void power_log(
    ofstream* fout,
    int size,
    int bbid,
    int path_id,
    vector<int>& rename_c_step_buffer,
    vector<vector<uint8_t> >& hamming_distance
    )
{
  static std::vector<map<int, Regression*> >& ai=get_ai();
  std::vector<double> ret(size);
//#pragma omp parallel for 
  for(int i=0; i<size; i++)
  {
    int idx=rename_c_step_buffer[i];
    int key=0;
    uint32_t buffer[512];
    ret[i]=ai[idx][key]->predict(get_data(idx, key, hamming_distance[i].data(), buffer));
  }
  if(fout!=nullptr)
  {
  for(auto& i : ret)
  {
    *fout<<i<<"\\n";
  }
  }
  return;
}
''')



def read_ai_file(inputfile_name):
    with open(inputfile_name, "rb") as ai_file:
        ret = pk.load(ai_file)
        if ret is not None:
            print "OK"  # DEBUG("Ok!")
        else:
            print "Illegal file!"  # ERROR( "Illegal file!")
            sys.exit(2)
        return ret


if __name__ == "__main__":
    print sys.argv
    ai_list = read_ai_file(sys.argv[1])
    write_hpp(sys.argv[2], ai_list)
