import numpy as np
import sys
from getopt import getopt
from sklearn.metrics import r2_score
from sklearn.metrics import mean_squared_error
from multiprocessing import Pool
import multiprocessing as mp
from sklearn.feature_selection import SelectFromModel
from sklearn.tree import DecisionTreeRegressor
from sklearn.linear_model import LinearRegression
from sklearn.ensemble import GradientBoostingRegressor
from sklearn.linear_model.bayes import BayesianRidge

import pickle as pk


def read_activity_data(filename):
    num_lines = sum(1 for line in open(filename))
    activity = [None] * num_lines
    with open(filename) as f:
        for idx, line in enumerate(f):
            items = line.strip().split(',')
            activity[idx] = [int(x) for x in items[1:]]
    return np.array(activity)


def read_cycle_power_data(filename):
    resolution = 1  # default resolution 1ns
    pwr_data = []
    with open(filename) as f:
        try:
            line = f.readline()
            while line != '':
                if ".time_resolution" in line:
                    resolution = float(line.split()[1])
                    # print "Resolution: ",resolution,"ns"
                if line.strip().isdigit():
                    event_time = line
                    line = f.readline()
                    data = [0] * 10
                    while line.strip().isdigit() is False and not (";" in line):
                        line_parse = line.split()
                        idx = int(line_parse[0])
                        data[idx] = float(line_parse[1])
                        line = f.readline()
                        if idx == 1:
                            pwr_data.append([int(event_time) * resolution, data[1]])
                    continue
                line = f.readline()

        except ValueError:
            print "ValueError!!!"
            return
    return pwr_data


def get_invocation_power(filename, offset, total_cycles_per_invocation, total_invocations):
    cycle_power = np.array(read_cycle_power_data(filename))
    row_length = total_invocations
    col_length = total_cycles_per_invocation
    index = np.squeeze(np.where(cycle_power[:, 0] == offset)[0])
    cycle_power = np.array(cycle_power[:, 1][index:index + row_length * col_length]) * 1000
    print row_length, col_length
    return cycle_power.reshape((row_length, col_length))


def error_metric(target, predict):
    target = np.squeeze(np.array(target))
    predict = np.squeeze( np.array(predict))
    target = target[0:-1]  # last one has some measurement error
    predict = predict[0:-1]
    diff = target - predict
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


def learn((d, t, regressor)):
    try:
      gp1 = SelectFromModel(DecisionTreeRegressor(), "0.01*mean")
      gp1.fit(d, t)
      if len(gp1.get_support(True)) == 0:
          gp1 = None
      if regressor is DecisionTreeRegressor:
          gp2 = DecisionTreeRegressor(min_samples_split=30, min_samples_leaf=10)
      elif regressor is LinearRegression:
          gp2 = LinearRegression()
      elif regressor is GradientBoostingRegressor:
          if np.var(t) < 0.1e-6:
              gp2 = LinearRegression()
          else:
              gp2 = GradientBoostingRegressor(max_depth=3, n_estimators=30)
      elif regressor is BayesianRidge:
          if np.var(t) < 0.1e-6:
              gp2 = LinearRegression()
          else:
              gp2 = BayesianRidge()
      else:
          gp2 = regressor()
      if gp1 is not None:
        gp2.fit(gp1.transform(d), t)
      else:
        gp2.fit(d, t)
      return gp1, gp2
    except:
      gp1 = SelectFromModel(DecisionTreeRegressor(), "0.01*mean")
      gp1.fit(d, t)
      gp2 = LinearRegression()
      gp2.fit(gp1.transform(d), t)
      return gp1, gp2


def fit((gp, gp2, vd)):
    if(gp!=None):
      p = gp2.predict(gp.transform(vd))
    else:
      p = gp2.predict(vd)
    return p


def multi_model(train_set, valid_set, regressor):
    td = train_set[0]
    tp = train_set[1]

    vd = valid_set[0]
    vp = valid_set[1]
    arg_list = list()

    for idx in range(0, tp.shape[1]):
        t = np.squeeze(tp[:, idx])
        arg_list.append((td, t, regressor))
    pool = Pool(mp.cpu_count())
    ai = pool.map(learn, arg_list)

    predict_cycle_power = np.zeros(vp.shape)
    pool = Pool(mp.cpu_count())
    predict_arg_list = list()

    for idx in range(0, tp.shape[1]):
        if ai[idx] is not None:
            predict_arg_list.append((ai[idx][0], ai[idx][1], vd))
    p = pool.map(fit, predict_arg_list)
    for idx in range(0, tp.shape[1]):
        predict_cycle_power[:, idx] = p[idx]

    target = np.mean(vp, axis=1)
    predict = np.mean(predict_cycle_power, axis=1)
    return ai, error_metric(target, predict)


def model_gen(train_activity_file,
              train_power_file,
              valid_activity_file,
              valid_power_file,
              offset,
              total_cycles_per_invocation,
              regressor_type,
              logfile
              ):
    td = read_activity_data(train_activity_file)
    tp = get_invocation_power(train_power_file, offset,
                              total_cycles_per_invocation, len(td))
    vd = read_activity_data(valid_activity_file)
    vp = get_invocation_power(valid_power_file, offset,
                              total_cycles_per_invocation, len(vd))

    ai = None
    with open(logfile + ".log", "w") as f:
        ai, error_msg = \
            multi_model((td, tp), (vd, vp), regressor_type)
        f.write(error_msg)

    vp_predict = [fit((i[0], i[1], np.array([vd[0]]))) for i in ai]
    return ai, vd[0], np.squeeze(vp_predict)


def dump_ai(regressors, filename, train_data, power_data):
    ai_list = []
    for idx, item in enumerate(regressors):
      if(item[0]!=None):
        ai_list.append((item[0].get_support(indices=True), item[1]))
      else:
        ai_list.append((range(0,train_data.shape[0]), item[1]))
    output = open(filename + ".pkl", 'wb')
    pk.dump((ai_list, train_data.tolist(), power_data), output)


if __name__ == "__main__":
    opts, args = getopt(sys.argv[1:], "p:t:v:w:m:c:r:q:a:f:d:s:l:")
    options = [None] * 8
    ai_name = ''

    for o, a in opts:
        if o == "-t":  # train activity
            options[0] = a
        elif o == "-p":  # train power file
            options[1] = a
        elif o == "-v":  # valid activity
            options[2] = a
        elif o == "-w":  # valid power file
            options[3] = a
        elif o == "-c":  # cycle per invocation 
            options[5] = int(a)
        # option[6]
        elif o == "-a":  # ai file/log file name w/o extension
            options[7] = a
        elif o == "-l":  # learning model
            ai_name = a


    options[4] = 115

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

    ai, td, td_p = model_gen(*options)

    if options[7] is not None:
        dump_filename = options[7]
        dump_ai(ai, dump_filename, td, td_p)
