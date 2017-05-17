
import sys
import numpy as np
from powerTraceParser import PowerTrace
from sklearn.metrics import r2_score
from sklearn.metrics import mean_squared_error

def error_metric(target, predict):
    target = np.array(target)
    predict = np.array(predict)
    target = target[0:-1]  # last one has some measurement error
    predict = predict[0:-1]
    diff = target - predict
    min_value = min(diff)
    max_value = max(diff)
    abs_diff = abs(target - predict)
    m = np.mean(target)
    for idx, i in enumerate(predict):
        if i == float('nan'):
            print idx, len(predict), "Nan"
    ret = ''
    ret += "mean of target: {}\n".format(m)
    ret += "mean of predict: {}\n".format(np.mean(predict))
    ret += "avg error: {}\n".format((m - np.mean(predict)) / m)
    ret += "r2_score: {}\n".format(r2_score(target, predict))
    ret += "mse: {}\n".format(mean_squared_error(target, predict))
    nmae = sum(abs_diff) * 1.0 / (m * len(abs_diff))
    ret += "nmae: {}\n".format(nmae)
    ret += "normalized mae  min/max error: {} {}\n".format(min_value * 1.0 / m, max_value * 1.0 / m)
    normalized_abs_diff = np.divide(abs_diff, target)
    p_diff = np.divide(diff, target)
    nmape = sum(normalized_abs_diff) / len(abs_diff)
    ret += "nmape: {}\n".format(nmape)
    ret += "max normalized map error: {} {}\n".format(min(p_diff), max(p_diff))
    return ret, nmae, nmape

def read_valid_power(filename):
    pt_inst = PowerTrace()
    pt_inst.readFromTraceFile(filename, 1)
    index =np.squeeze( np.where(pt_inst.pwrData[:, 0] == 115)[0])
    valid_power = np.array(pt_inst.pwrData[:, 1][index:]) * 1000
    return valid_power

def read_file(filename):
    ret=[]
    with open(filename) as f:
        for i in f:
            ret.append(float(i.strip()))
    return ret

#if __name__=="__main__":
def test():
    v=read_valid_power(sys.argv[1])
    project_name = sys.argv[2]
    valid_prefix = sys.argv[3]
    full_log = sys.argv[4]
    log = sys.argv[5]
    model_names = [ "cc" , "cd" , "cs"]
    regressors_names = [ "ls", "bl", "dt", "gr"]
    with open(full_log, "a+") as f :
      f.write(sys.argv[1]+"\n")
      nmae_whole_list=[]
      nmape_whole_list=[]
      for j in regressors_names:
        nmae_list=[]
        nmape_list=[]
        for i in model_names:
          test_out_name = project_name+"_"+i+"_"+\
              j+"_"+valid_prefix+"_pwr.out"
          p=read_file(test_out_name)
          (msg, nmae, nmape)=error_metric(v[0:len(p)],p)
          f.write(msg)
          nmae_list.append(nmae)
          nmape_list.append(nmape)
        nmae_whole_list.append(nmae_list)
        nmape_whole_list.append(nmape_list)

        nmae_list=[]
        nmape_list=[]
        for i in model_names:
          test_opt_out_name = project_name+"_"+i+"_"+\
              j+"_"+valid_prefix+"_opt_pwr.out"
          p=read_file(test_opt_out_name)
          (msg, nmae, nmape)=error_metric(v[0:len(p)],p)
          f.write(msg)
          nmae_list.append(nmae)
          nmape_list.append(nmape)
        nmae_whole_list.append(nmae_list)
        nmape_whole_list.append(nmape_list)
      f.write("\n")




    with open(log, "a+") as f :
      f.write(sys.argv[1]+"\n")
      for i in nmae_whole_list:
        f.write(",".join([str(x) for x in i])+"\n")
      f.write("\n")
      for i in nmape_whole_list:
        f.write(",".join([str(x) for x in i])+"\n")
      f.write("\n")

def error_metric_v2(target, predict):
    target = np.array(target)
    predict = np.array(predict)
    target = target[0:-1]  # last one has some measurement error
    m_val = max(target)
    m_p_val = max(predict)
    predict = predict[0:-1]
    diff = target - predict
    min_value = min(diff)
    max_value = max(diff)
    abs_diff = abs(target - predict)
    m = np.mean(target)
    for idx, i in enumerate(predict):
        if i == float('nan'):
            print idx, len(predict), "Nan"
    ret = ''
    ret += "peak power: {}, {}\n".format(m_val, m_p_val)
    ret += "mean of target: {}\n".format(m)
    ret += "mean of predict: {}\n".format(np.mean(predict))
    ret += "avg error: {}\n".format((m - np.mean(predict)) / m)
    ret += "r2_score: {}\n".format(r2_score(target, predict))
    ret += "mse: {}\n".format(mean_squared_error(target, predict))
    nmae = sum(abs_diff) * 1.0 / (m * len(abs_diff))
    ret += "nmae: {}\n".format(nmae)
    ret += "normalized mae  min/max error: {} {}\n".format(min_value * 1.0 / m, max_value * 1.0 / m)
    normalized_abs_diff = np.divide(abs_diff, target)
    p_diff = np.divide(diff, target)
    nmape = sum(normalized_abs_diff) / len(abs_diff)
    ret += "nmape: {}\n".format(nmape)
    ret += "max normalized map error: {} {}\n".format(min(p_diff), max(p_diff))
    return (nmae, m, m_val, max_value/m_val, (m_p_val-m_val)/m_val,(m - np.mean(predict)) / m ,ret)

          
if __name__ == "__main__":      
    v=read_valid_power(sys.argv[1])
    project_name = sys.argv[2]
    valid_prefix = sys.argv[3]
    full_log = sys.argv[4]
    log = sys.argv[5]
    #names= [ ("cd",["ls","dt","bl","gr"]), ("cs",["ls","dt"])]
    names= [ ("cd",["dt"]), ("cs",["ls"])]
#   names= [ ("bc",["dt"])]
#   names= [ ("cd",["ls","dt"]),("cs",["ls","dt"])]
    with open(full_log, "a+") as f :
      f.write(sys.argv[1]+"\n")
      nmae_whole_list=[]
      max_whole_list=[]
      peak_whole_list=[]
      avg_whole_list=[]
      for i, regressors in names:
        nmae_list=[]
        max_list=[]
        peak_list=[]
        avg_list=[]
        for j in regressors:
          test_out_name = project_name+"_"+i+"_"+\
              j+"_"+valid_prefix+"_pwr.out"
          p=read_file(test_out_name)
          (nmae, mean, max_power, max_error, peak_error, avg_error, msg)=error_metric_v2(v[0:len(p)],p)
          f.write(msg)
          nmae_list.append(nmae)
          max_list.append(max_error)
          peak_list.append(peak_error)
          avg_list.append(avg_error)
        nmae_whole_list.append(nmae_list)
        max_whole_list.append(max_list)
        peak_whole_list.append(peak_list)
        avg_whole_list.append(avg_list)

    with open(log, "a+") as f :
      f.write(sys.argv[1]+"\n")
      for i in nmae_whole_list:
        f.write(",".join([str(x) for x in i])+"\n")
      f.write("\n")
      for i in max_whole_list:
        f.write(",".join([str(x) for x in i])+"\n")
      f.write("\n")
      for i in peak_whole_list:
        f.write(",".join([str(x) for x in i])+"\n")
      f.write("\n")
      for i in avg_whole_list:
        f.write(",".join([str(x) for x in i])+"\n")
      f.write("\n")
    
