#!/usr/bin/python
import sys
import numpy as np
from powerTraceParser import PowerTrace
from getopt import getopt
from DataParser import read_activity
from Learn import FeatureAnalysis
from whitebox import CycleDecompModel
from DataParser import ActivityData
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.linear_model.bayes import BayesianRidge
from sklearn.linear_model import LinearRegression
from sklearn.svm import SVR



def run_model(
        train_filename,
        train_power_filename,
        cop_filename,
        rop_filename,
        n_cop_filename,
        n_rop_filename,
        quality
):
    print "Read training data"
    train_act = ActivityData(*read_activity(train_filename))
    pt_inst = PowerTrace()
    pt_inst.readFromTraceFile(train_power_filename, 1)
    index = np.squeeze( np.where(pt_inst.pwrData[:, 0] == 115)[0])
    train_power = np.array(pt_inst.pwrData[:, 1][index:]) * 1000

    print "Start training"
    my_learn = CycleDecompModel()
    my_learn.regressor = DecisionTreeRegressor
    my_learn.train(train_act, train_power, True, quality)

    my_learn.featureWriter.analyze()
    my_learn.featureWriter.write_opt_rop_info(rop_filename, n_rop_filename)
    my_learn.featureWriter.write_opt_cop_info(cop_filename, n_cop_filename)


if __name__ == "__main__":
    opts, args = getopt(sys.argv[1:], "p:t:c:r:q:d:s:")
    options = [None] * 7
    for o, a in opts:
        if o == "-t":  # train
            options[0] = a
        elif o == "-p":  # train power
            options[1] = a
        elif o == "-c":  # cop
            options[2] = a
        elif o == "-r":  # rop
            options[3] = a
        elif o == "-d":  # new cop
            options[4] = a
        elif o == "-s":  # new rop
            options[5] = a
        elif o == "-q":  # feature
            options[6] = float(a)
    run_model(*options)
