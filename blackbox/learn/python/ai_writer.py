import numpy as np
from sklearn.linear_model.bayes import BayesianRidge
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.tree import DecisionTreeRegressor
import sys

import pickle as pk


def list_to_array(var_name, values):
    value_array = []
    if (type(values) is np.ndarray and len(values.shape) > 0) or (type(values) is list):
        for i in values:
            value_array.append(str(i))
    else:
        value_array.append(str(values))
    ret = var_name + "={" + ','.join(value_array) + "};\n"
    #  print ret
    return ret


def list_to_2d_vector(var_name, values):
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


def write_hpp(filename, regressors):
    dump_file = open(filename, "w")
    dump_file.write('#include "tree.h"\n')
    dump_file.write('#include "linear.h"\n')
    dump_file.write('#include "gradientboost.h"\n')
    dump_file.write('using namespace std;\n')
    if isinstance(regressors, list):
        num_models = len(regressors)
        # Write coefficient !
        features = []
        for node_id, (feature_indices, regressor) in enumerate(regressors):
            features.append(feature_indices)
            if isinstance(regressor, DecisionTreeRegressor):
                dump_file.write(list_to_array("int dt_children_left_{}[]".format(node_id), regressor.tree_.children_left))
                dump_file.write(
                    list_to_array("int dt_children_right_{}[]".format(node_id), regressor.tree_.children_right))
                dump_file.write(list_to_array("int dt_feature_{}[]".format(node_id), regressor.tree_.feature))
                dump_file.write(list_to_array("double dt_threshold_{}[]".format(node_id), regressor.tree_.threshold))
                dump_file.write(list_to_array("double dt_value_{}[]".format(node_id), np.squeeze(regressor.tree_.value)))
            elif isinstance(regressor, BayesianRidge) or isinstance(regressor, LinearRegression):
                # print _id,_key,item.coef_
                coeff = [np.squeeze(regressor.intercept_)] + np.squeeze(regressor.coef_).tolist()
                # print "print: ",coeff
                dump_file.write(list_to_array("double li_coeff_{}[]".format(node_id), coeff))
                dump_file.write("int li_coeff_len_{}={};\n".format(node_id, len(coeff)))
            elif isinstance(regressor, GradientBoostingRegressor):
                dump_file.write("double gb_mean_{}={};\n".format(node_id, regressor.init_.mean))
                dump_file.write("double gb_learning_rate_{}={};\n".format(node_id, regressor.learning_rate))
                tot_node = 0
                for row_idx, rows in enumerate(regressor.estimators_):
                    for col_idx, ele in enumerate(rows):
                        dump_file.write(list_to_array("int gb_children_left_{}_{}_{}[]".format(node_id, row_idx, col_idx),
                                                      ele.tree_.children_left))
                        dump_file.write(list_to_array("int gb_children_right_{}_{}_{}[]".format(node_id, row_idx, col_idx),
                                                      ele.tree_.children_right))
                        dump_file.write(list_to_array("int gb_feature_{}_{}_{}[]".format(node_id, row_idx, col_idx),
                                                      ele.tree_.feature))
                        dump_file.write(list_to_array("double gb_threshold_{}_{}_{}[]".format(node_id, row_idx, col_idx),
                                                      ele.tree_.threshold))
                        dump_file.write(list_to_array("double gb_value_{}_{}_{}[]".format(node_id, row_idx, col_idx),
                                                      np.squeeze(ele.tree_.value)))
                        tot_node += 1
                dump_file.write("int gb_total_node_{}={};\n".format(node_id, tot_node))
                big_forest = []
                for row_idx, rows in enumerate(regressor.estimators_):
                    forest = []
                    for col_idx, ele in enumerate(rows):
                        forest.append(" Tree(" + \
                                      " gb_children_left_{}_{}_{},".format(node_id, row_idx, col_idx) + \
                                      " gb_children_right_{}_{}_{},".format(node_id, row_idx, col_idx) + \
                                      " gb_feature_{}_{}_{},".format(node_id, row_idx, col_idx) + \
                                      " gb_threshold_{}_{}_{},".format(node_id, row_idx, col_idx) + \
                                      " gb_value_{}_{}_{}".format(node_id, row_idx, col_idx) + \
                                      ")")
                    my_forest = "vector<Tree>({" + ",".join(forest) + "})"
                    big_forest.append(my_forest)
                dump_file.write(
                    "vector<vector<Tree> > gb_forest_{}( ".format(node_id) + '{' + ",".join(big_forest) + "});")

            # elif constant!=None:
            else:
                assert False
                # coeff = [constant];
                # dump_file.write(list2array("double li_coeff_{}[]".format(_id), coeff))
                # dump_file.write("int li_coeff_len_{}={};\n".format(_id, len(coeff)))

        dump_file.write("void ai_model_read(vector<Regression*>& ai){\n")
        dump_file.write("\tint num_models={};\n".format(num_models))
        dump_file.write("\tai.resize(num_models);\n")
        #   dump_file.write("\tfor(int i=0; i<num_models; i++)    {\n");
        for node_id, (feature_indices, regressor) in enumerate(regressors):
            if isinstance(regressor, DecisionTreeRegressor):
                dump_file.write("\tai[{}]=new Tree({},{},{},{},{});\n".format(
                    node_id,
                    "dt_children_left_{}".format(node_id),
                    "dt_children_right_{}".format(node_id),
                    "dt_feature_{}".format(node_id),
                    "dt_threshold_{}".format(node_id),
                    "dt_value_{}".format(node_id)))
            elif isinstance(regressor, GradientBoostingRegressor):
                dump_file.write("\tai[{}]=new GradientBoost({},{},{},{});\n".format(
                    node_id
                    , "gb_forest_{}".format(node_id)
                    , "gb_total_node_{}".format(node_id)
                    , "gb_mean_{}".format(node_id)
                    , "gb_learning_rate_{}".format(node_id)
                ))
            # elif isinstance(item, BayesianRidge) or isinstance(item, LinearRegression):
            else:
                dump_file.write("\tai[{}]=new LinearRegression({},{});\n".format(
                    node_id,
                    "li_coeff_{}".format(node_id),
                    "li_coeff_len_{}".format(node_id)))
                #   dump_file.write("\t}\n");
        dump_file.write("}\n")

        dump_file.write(list_to_2d_vector("vector<vector<int> >  features", features))

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
    uint32_t buffer[2048];
    ret+=ai[i]->predict(get_data(i, data, buffer));
  }
  return ret/len;
}
''')


def read_ai_file(inputfile_name):
    with open(inputfile_name, "rb") as ai_file:
        (ai, td, tp) = pk.load(ai_file)
        if ai is not None:
            print "OK"  # DEBUG("Ok!")
        else:
            print "Illegal file!"  # ERROR( "Illegal file!")
            sys.exit(2)
        return ai, td, tp


from ai_text_writer import write_regressors

if __name__ == "__main__":
    print sys.argv
    (ai, td, tp) = read_ai_file(sys.argv[1])
    gr_count = 0
    for i in ai:
        for _id, (feature_list, item) in enumerate(ai):
            if isinstance(item, GradientBoostingRegressor):
                gr_count += 1
    if gr_count < 20:
        write_hpp(sys.argv[2], ai)
    else:
        # writeCPP(sys.argv[2], ai)
        write_regressors(sys.argv[2], ai, td, tp)
        print "Data"
