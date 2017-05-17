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
    ret += "mean of target: {}\n".format(m)
    ret += "mean of predict: {}\n".format(np.mean(predict))
    ret += "avg error: {}\n".format((m - np.mean(predict)) / m)
    ret += "r2_score: {}\n".format(r2_score(target, predict))
    ret += "mse: {}\n".format(mean_squared_error(target, predict))
    nmae = sum(abs_diff) * 1.0 / (m * len(abs_diff))
    ret += "nmae: {}\n".format(nmae)
    return ret

class BCDecompModel:
    def __init__(self):
        self.regressor = None
        self.featureWriter = None
        self.logfile = None
        self.ai = None
        self.bb_info = None
        self.cycle_ivc_power = None
        self.m_ivc_power = None
        self.m_bb_power = None

        return

    def train(self, train_activity_data, train_power_data, enable_feature_selection, threshold):
        self.ai = []
        self.featureWriter = FeatureAnalysis()
        self.bb_info = train_activity_data.bb_info
        for bb_id, bb_steps, bb_key in self.bb_info:
            row_indices = train_activity_data.get_index_bb_activity(bb_id, bb_steps, bb_key)
            pwr = train_power_data[row_indices]
            act = train_activity_data.get_bb_activity(bb_id, bb_steps, bb_key)
            self.ai.append(Learn(act, pwr, None, enable_feature_selection, threshold, self.regressor))
            self.featureWriter.add_ai(bb_id, bb_key, self.ai[-1].feature_indices)

    def dump_ai(self, filename):
        ret = []
        idx = 0
        for idx, (bb_id, bb_steps, bb_key) in enumerate(self.bb_info):
            ret.append([bb_id, bb_key, self.ai[idx].ai, self.ai[idx].feature_indices,
                       self.ai[idx].X_test, self.ai[idx].predict(np.array([self.ai[idx].X_test]))])
        output = open(filename, 'wb')
        pk.dump(ret, output)


    def valid(self, valid_activity_data, valid_power_data):
        # bb power
        with open(self.logfile, "w") as f:
            est_bb_power = \
                self.basicblock_level_fit(valid_activity_data, valid_power_data)
            msg=error_metric(valid_power_data, est_bb_power)
            f.write(msg)

    def basicblock_level_fit(self, valid_activity_data, valid_power_data):
        est_power = np.zeros(valid_power_data.shape)
        idx = 0
        for bb_id, bb_steps, bb_key in valid_activity_data.bb_info:
            act = valid_activity_data.get_bb_activity(bb_id, bb_steps, bb_key)
            est_y = self.ai[idx].predict(act)
            row_idx = valid_activity_data.get_index(bb_id, bb_steps, bb_key)
            est_power[row_idx] = est_y
            idx += 1
        return est_power
