import numpy as np
from powerTraceParser import PowerTrace

def read_valid_power(filename):
    pt_inst = PowerTrace()
    pt_inst.readFromTraceFile(filename, 1)
    index =np.squeeze( np.where(pt_inst.pwrData[:, 0] == 115)[0])
    valid_power = np.array(pt_inst.pwrData[:, 1][index:]) * 1000
    return valid_power
def read_activity(filename):
  with open(filename) as f:
      idx_info = list()
      invoke_count = -1
      for line in f:
          bb_items = [int(x) for x in line.rstrip("\n").split(",")]
          bb_id = bb_items[0]
          curr_bb_key = bb_items[1]
          bb_steps = bb_items[2]
          if bb_id == 0:
              invoke_count += 1
          idx_info.append([invoke_count, bb_id, bb_steps])
      return idx_info

def get_bb_power(act_file, powerfile):
  idx_info=read_activity(act_file)
  power=read_valid_power(powerfile)
  idx=0
  bb_power = np.zeros(len(idx_info))
  bb_invoc = 0
  cc_invoc = 0
  bb_count = 0
  for k, (invoke_count, bb_id, bb_steps) in enumerate(idx_info):
    bb_e=0.0
    if(bb_invoc==0):
      bb_count+=1
      cc_invoc+=bb_steps
    if(invoke_count==1 and bb_invoc==0):
      bb_invoc=bb_count-1
      cc_invoc=cc_invoc-bb_steps
    for i in range(0, bb_steps):
      bb_e+=power[idx]
      idx+=1
    bb_e=bb_e/bb_steps
    bb_power[k]=bb_e
  return bb_power
  



import sys

if __name__ == "__main__":
  idx_info=read_activity(sys.argv[1]) 
  power=read_valid_power(sys.argv[2])
  idx=0
  bb_power = np.zeros((len(idx_info),2))
  bb_invoc = 0
  cc_invoc = 0
  bb_count = 0
  for k, (invoke_count, bb_id, bb_steps) in enumerate(idx_info):
    bb_e=0.0
    if(bb_invoc==0):
      bb_count+=1
      cc_invoc+=bb_steps
    if(invoke_count==1 and bb_invoc==0):
      bb_invoc=bb_count-1
      cc_invoc=cc_invoc-bb_steps
    for i in range(0, bb_steps):
      bb_e+=power[idx]
      idx+=1
    bb_e=bb_e/bb_steps
    bb_power[k][0]=bb_steps
    bb_power[k][1]=bb_e
  print "# bb in one invoc: ", bb_invoc, cc_invoc
  
  with open(sys.argv[2]+".bb.pwr", "w") as f:
    for i in bb_power:
      f.write(str(int(i[0]))+","+str(i[1])+"\n")
  tot_cycles=idx_info[-1][0] * cc_invoc;
  inv=power[0:tot_cycles].reshape((tot_cycles/cc_invoc,cc_invoc))
  inv=np.mean(inv,axis=1)
  with open(sys.argv[2]+".invoc.pwr", "w") as f:
    for i in inv:
      f.write(str(i)+"\n")

    


  


