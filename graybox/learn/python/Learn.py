# from sklearn import cross_validation
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.linear_model.bayes import BayesianRidge
from sklearn.linear_model import LinearRegression
from sklearn.svm import SVR
from multiprocessing import Pool
import numpy as np
from sklearn.feature_selection import SelectFromModel
from sklearn.feature_selection import VarianceThreshold
#from sklearn.model_selection import cross_val_score


class Learn:
    def __init__(self, x, y, cop_info, w_feature_sel, threshold, regressor=None):
        self.X_test = np.array(x[0])
        self.X = x
        self.Y = y
        self.w_feature_sel = w_feature_sel
        # self.feature_model=None
        self.feature_indices = None
        self.threshold = threshold
        self.cop_info = cop_info
        self.ai = None
        if regressor is None:
            self.regressor = None
        else:
            self.regressor = regressor
        self.model_gen()

    def fit(self):
        if self.regressor == GradientBoostingRegressor:
            ai = self.regressor(max_depth=5, n_estimators=30)
        elif self.regressor == DecisionTreeRegressor:
            ai = self.regressor(criterion="mse", max_depth=10, min_samples_leaf=3)
        else:
            ai = self.regressor()
        ai.fit(self.X, np.squeeze(self.Y))
        return None, ai

    def trim_zeros(self):
        try:
            if np.all(self.X == 0):
                self.feature_indices = []
                self.X = None
                return
            # print "FTB:",self.X[0]
            # print "FTB:",self.X[1]
            clf = VarianceThreshold(threshold=0.0000001)
            self.X = clf.fit_transform(self.X)
            self.feature_indices = np.array(clf.get_support(indices=True))
            # print "FTA:",self.X[0]
            # print "FTA:",self.X[1]
            # print self.feature_indices
        except ValueError:
            self.feature_indices = []
            return

    def feature_sel(self):
        feature_model = SelectFromModel(DecisionTreeRegressor(), self.threshold * 1.0 / self.X.shape[1])
        self.X = feature_model.fit_transform(self.X, self.Y)
        supports = feature_model.get_support(True)
        if (supports is not None) and len(supports) != 0:
            self.feature_indices = self.feature_indices[supports]
        else:
            self.feature_indices = []

    def model_gen(self):
        if (self.X is None
            or (self.X.shape[0] < 12 or self.X.shape[1] == 0
            or (self.X[0] is None or (len(self.X.shape)==2 and  self.X[0][0] is None))) 
            or np.var(self.Y) * len(self.Y) <= 0.01):
            # print "Constant Model: ",np.mean(np.squeeze(self.Y))
            self.ai = (np.mean(np.squeeze(self.Y)), None)

            return
        else:
            # print "Not Constant Model: "
            self.trim_zeros()
            if self.X is None:
                self.ai = (np.mean(np.squeeze(self.Y)), None)
                return
            if self.w_feature_sel:
                self.feature_sel()
            if len(self.feature_indices) != 0:
                self.ai = self.fit()
            else:
                self.ai = (np.mean(np.squeeze(self.Y)), None)

    def predict(self, X):
        if self.ai[0] is None:
            # X=self.feature_model.transform(X[self.feature_indices])
            return self.ai[1].predict(X[:, self.feature_indices])
        else:
            return np.ones((X.shape[0], 1)) * self.ai[0]


class FeatureAnalysis:
    def __init__(self):
        self.ai_list = []
        self.used_rop_features = None
        self.used_rop = set()

    def add_ai(self, _id, _key, features):
        self.ai_list.append([_id, _key, features])

    def analyze(self):
        indices = set()
        for _id, _key, features in self.ai_list:
            if not (features is None):
                indices = indices | set(features)
        self.used_rop_features = list(indices)
        self.used_rop_features.sort()

        for i in self.used_rop_features:
            self.used_rop.add(i / 3)

    def write_feature_list(self, new_file):
        with open(new_file, "w") as f:
            f.write("{} {}\n".format(len(self.ai_list), len(self.ai_list)))
            for _id, _key, features in self.ai_list:
                f.write("{} {}".format(_id, _key))
                if (features is not None) and len(features) != 0:
                    st = ' ' + ' '.join(["{}"] * len(features))
                    f.write(st.format(*features))
                f.write("\n")

    def write_opt_rop_info(self, org_file, new_file):
        # 0 0 0 => placeholder (don't delete rops)
        rtl_info = read_rtlop_info(org_file)
        for i in self.used_rop_features:
            rtl_info[i / 3].selectedOperand[i % 3] = 1
        with open(new_file, "w") as f:
            for i in rtl_info:
                f.write(i.to_string())

    def write_opt_cop_info(self, org_file, new_file):
        (traces, target_name) = read_cop_info(org_file)
        new_traces = []
        for i in traces:
            if i.rtl_id in self.used_rop:
                new_traces.append(i)
        with open(new_file, "w") as f:
            f.write(target_name)
            for i in new_traces:
                f.write(i.to_string())

    def write_rop_info(self, org_file, new_file):
        rtl_info = read_rtlop_info(org_file)
        for i in range(0, len(rtl_info)):
            for k in range(0, 3):
                rtl_info[i].selectedOperand[k] = 1
        with open(new_file, "w") as f:
            for i in rtl_info:
                f.write(i.to_string())

    def write_cop_info(self, org_file, new_file):
        (traces, target_name) = read_cop_info(org_file)
        with open(new_file, "w") as f:
            f.write(target_name)
            for i in traces:
                f.write(i.to_string())


class COP:
    def __init__(self, args_list):
        self.code = args_list[0]
        (self.rtl_id, self.c_step, self.bb_id) = (int(x) for x in args_list[1:])
        # self.pwr=0

    def to_string(self):
        return "{}|{}|{}|{}\n".format(self.code, self.rtl_id, self.c_step, self.bb_id)  # ,self.pwr)


def read_cop_info(filename):
    target_name = ''
    traces = list()
    with open(filename, "r") as f:
        for idx, line in enumerate(f):
            if idx != 0:
                args_list = line.rstrip("\n").split("|")
                traces.append(COP(args_list))
            else:
                target_name = line
    # print traces,len(traces)
    return traces, target_name


class RTLOP:
    def __init__(self, string_args_list):
        self.name = string_args_list[0]
        self.bitWidth = [int(x) for x in string_args_list[1:]]
        self.selectedOperand = [0, 0, 0]

    def to_string(self):
        # print self.bitWidth,self.selectedOperand
        return '{} {} {} {}\n'.format(self.name, self.bitWidth[0] * self.selectedOperand[0],
                                      self.bitWidth[1] * self.selectedOperand[1],
                                      self.bitWidth[2] * self.selectedOperand[2])


def read_rtlop_info(filename):
    rtlInfo = list()
    with open(filename, "r") as f:
        for line in f:
            arg_list = line.rstrip("\n").split(",")
            if len(arg_list) == 1:
                arg_list = line.rstrip("\n").split(" ")
            # print arg_list
            rtlInfo.append(RTLOP(arg_list))
    return rtlInfo
