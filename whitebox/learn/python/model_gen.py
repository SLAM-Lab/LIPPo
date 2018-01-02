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


def log_filename(ai_filename):
    return ai_filename.split(".")[0] + ".log"


def run_model(
        train_filename,
        train_power_filename,
        valid_filename,
        valid_power_filename,
        quality,
        ai_filename,
        regressor
):

    train_act = ActivityData(*read_activity(train_filename))
    pt_inst = PowerTrace()
    pt_inst.readFromTraceFile(train_power_filename, 1)
    index = np.squeeze(np.where(pt_inst.pwrData[:, 0] == 115)[0])
    train_power = np.array(pt_inst.pwrData[:, 1][index:]) * 1000
    #print train_power

    print "Start training"
    my_learn = CycleDecompModel()
    my_learn.regressor = regressor
    my_learn.logfile = log_filename(ai_filename)

    if quality > 0.0:
        my_learn.train(train_act, train_power, True, quality)
    else:
        my_learn.train(train_act, train_power, False, 0.0)

    my_learn.dump_ai(ai_filename)
    if (valid_filename is not None) and (valid_filename != "None"):
        print "Start model checking"
        valid_act = ActivityData(*read_activity(valid_filename))
        pt_inst = PowerTrace()
        pt_inst.readFromTraceFile(valid_power_filename, 1)
        index = np.squeeze(np.where(pt_inst.pwrData[:, 0] == 115)[0])
        #print index
        valid_power = np.array(pt_inst.pwrData[:, 1][index:]) * 1000
        my_learn.valid(valid_act, valid_power)


if __name__ == "__main__":
    opts, args = getopt(sys.argv[1:], "p:t:v:w:m:q:a:l:k:")
    options = [None] * 7
    for o, a in opts:
        if o == "-t":  # train
            options[0] = a
        elif o == "-p":  # train power
            options[1] = a
        elif o == "-v":  # valid
            options[2] = a
        elif o == "-w":  # valid power
            options[3] = a
        elif o == "-q":  # feature quality threshold
            options[4] = float(a)
        elif o == "-a":  # ai
            options[5] = a
        elif o == "-l":  # learning model
            ai_name = a

    if ai_name == "ls":
        options[6] = LinearRegression
    elif ai_name == "dt":
        options[6] = DecisionTreeRegressor
    elif ai_name == "gr":
        options[6] = GradientBoostingRegressor
    elif ai_name == "bl":
        options[6] = BayesianRidge
    else:
        options[6] = LinearRegression

    print options
    run_model(*options)
