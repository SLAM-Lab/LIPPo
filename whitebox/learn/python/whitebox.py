from DataParser import ActivityData
from Learn import FeatureAnalysis
import pickle as pk
import sys
from Learn import Learn
from sklearn.metrics import r2_score
from sklearn.metrics import mean_squared_error
import numpy as np
from copy import copy


def error_metric(target, predict):
    target = np.array(target)
    predict = np.array(predict)
    target = target[0:-1]  # last one has some measurement error
    predict = predict[0:-1]
    abs_diff = abs(target - predict)
    m = np.mean(target)
    ret = ''
    ret += "avg error: {}\n".format((m - np.mean(predict)) / m)
    ret += "r2_score: {}\n".format(r2_score(target, predict))
    nmae = sum(abs_diff) * 1.0 / (m * len(abs_diff))
    ret += "nmae: {}\n".format(nmae)
    return ret


class CycleDecompModel:
    def __init__(self):
        self.regressor = None
        self.featureWriter = None
        self.logfile = None
        self.ai = None
        self.cs_info = None

    def train(self, train_activity_data, train_power_data, enable_feature_selection, threshold):
        self.ai = []
        self.featureWriter = FeatureAnalysis()
        self.cs_info = train_activity_data.cs_info
        # print self.cs_info
        for i in train_activity_data.cs_info:
            # print "cs:",i
            row_idx = train_activity_data.get_index(-1, -1, -1, i, -1)
            self.ai.append(Learn(train_activity_data.act_info[row_idx], train_power_data[row_idx], None,
                                 enable_feature_selection, threshold, self.regressor))
        # print "Done: train"
        for idx, i in enumerate(train_activity_data.cs_info):
            # print i,self.ai[idx].feature_indices
            self.featureWriter.add_ai(i, 0, self.ai[idx].feature_indices)

    def dump_ai(self, filename):
        ret = []
        for idx, i in enumerate(self.cs_info):
            #print self.ai[idx].ai, self.ai[idx].predict(np.array([self.ai[idx].X_test])), self.ai[idx].Y_test
            ret.append([i, 0, self.ai[idx].ai, self.ai[idx].feature_indices,
                self.ai[idx].X_test, self.ai[idx].predict(np.array([self.ai[idx].X_test]))])
        output = open(filename, 'wb')
        pk.dump(ret, output)

    def score(self, train_activity_data, train_power_data, enable_feature_selection, threshold,
              valid_activity_data, valid_power_data, train_invocations):
        nmape = []
        nmae = []
        #print train_activity_data.act_info.shape, len(train_power_data)
        with open(self.logfile, "w") as f:
            row_indices = []
            for i in train_invocations:
                for k_idx, k in enumerate(train_activity_data.idx_info):
                    if k[0] == i:
                        row_indices.append(k_idx)
                        break

            if len(train_invocations) > 0 and (train_invocations[-1] == train_activity_data.idx_info[-1][0] + 1):
                row_indices.append(len(train_activity_data.idx_info))
            else:
                train_invocations.append(train_activity_data.idx_info[-1][0])
                row_indices.append(len(train_activity_data.idx_info))

            #print "cd train: ", train_invocations, row_indices

            for i_idx, i in enumerate(row_indices):
                if i<(len(train_activity_data.act_info)-1):
                  selected_train_activity_data = ActivityData(
                      np.vstack((train_activity_data.idx_info[0:i - 1], train_activity_data.idx_info[-1])),
                      np.vstack((train_activity_data.act_info[0:i - 1], train_activity_data.act_info[-1])),
                      train_activity_data.bb_cs_info,
                      train_activity_data.cs_info,
                      train_activity_data.bb_info)
                else:
                  selected_train_activity_data = ActivityData(
                      np.array(train_activity_data.idx_info),
                      np.array(train_activity_data.act_info),
                      train_activity_data.bb_cs_info,
                      train_activity_data.cs_info,
                      train_activity_data.bb_info)
                self.train(selected_train_activity_data, train_power_data, enable_feature_selection, threshold)

                est_power = self.cycle_level_valid(valid_activity_data, valid_power_data)
                f.write("CD: error {}\n".format(train_invocations[i_idx]))
                (log_str, nmae_temp, nmape_temp) = error_metric(valid_power_data, est_power)
                est_ivc_power, m_ivc_power = \
                    self.invocation_level_valid(est_power, valid_activity_data, valid_power_data)
                f.write("CD INV: error\n")
                f.write(error_metric(m_ivc_power, est_ivc_power)[0])

                f.write(log_str)
                nmae.append(nmae_temp)
                nmape.append(nmape_temp)
            f.write(str(nmae))
            f.write(str(nmape))
            
        return nmae, nmape

    def valid(self, valid_activity_data, valid_power_data):
        with open(self.logfile, "w") as f:
            if self.cs_info != valid_activity_data.cs_info:
                print "Error!!"
                sys.exit(2)
            est_power = self.prediction(valid_activity_data, valid_power_data)
            log_text=error_metric(valid_power_data, est_power)
            f.write(log_text)
        return

    def prediction(self, valid_activity_data, valid_power_data):
        est_power = np.zeros(valid_power_data.shape)
        # print est_power.shape
        for idx, i in enumerate(valid_activity_data.cs_info):
            row_idx = valid_activity_data.get_index(-1, -1, -1, i, -1)
            est_y = self.ai[idx].predict(valid_activity_data.act_info[row_idx])
            est_power[row_idx] = np.squeeze(est_y)
        return est_power
