#!/usr/bin/python
## 	@package  plot
#	  @brief    power graph tool
#   @author   Dongwook Lee
#   @date     10/18/2013

import numpy as np;
import locale
## read pwr.out file and convert it to two column array.
#  After reading pwr1.out and convert it into npz format file.
#  @param filename  input filename
#  @param index     index for module
#  @param outnpzfilename output npz filename 
def readPwrTrace(filename, index, outnpzfilename=''):
  resolution=1; # default resolution 1ns
  pwrData=[]
  with open(filename) as f:
    try:
      line=f.readline();
      while(line!=''):
        if(".time_resolution" in line):
          resoulution=float(line.split()[1])
          #print "Resolution: ",resoulution,"ns"
        if(line.strip().isdigit()):          
          eventTime=line;
          line=f.readline()
          data=[0]*10;
          while(line.strip().isdigit()==False and not (";" in line) ):
            lineParse=line.split();
            idx=int(lineParse[0])
            data[idx]=float(lineParse[1]);            
            line=f.readline() 
            if(index==idx):
              pwrData.append([int(eventTime)*resoulution,data[index]])
          continue
        line=f.readline();

    except ValueError:
      print "ValueError!!!",line
      return  
    pwrData=np.array(pwrData)
    if(outnpzfilename!=''):
      np.save(outnpzfilename,pwrData)
  #print "Done"
  return pwrData

def writePwrTrace(pwrMatrix, outnpzfilename):
  pwrData=np.array(pwrMatrix);
  np.save(outnpzfilename,pwrData)

## Read power trace file and do postprocessing 
#
class PowerTrace:
  def __init__(self):
    pass;
  def readFromNPZ(self, npzfilename):
    self.pwrData=np.load(npzfilename)
  def readFromTraceFile(self, tracefilename,index,outnpzfilename=''):
    self.pwrData=readPwrTrace(tracefilename,index,outnpzfilename)
    #print self.pwrData
  def __iter__(self):
    #print self.pwrData.shape
    for l in self.pwrData:
      yield (int(l[0]), l[1])
  def __getitem__(self, i):
    return self.pwrData[i]





def test():
  # readPwrTrace("../../examples/dct/pwr1.out",1,"power_trace")

  ptInst=PowerTrace();
  #ptInst.readFromNPZ("power_trace.npy")
  ptInst.readFromTraceFile("../../matrix_mul/default/power/pwr1.out",1)
  for i in ptInst:
    pass

if __name__ =="__main__":
  test();
