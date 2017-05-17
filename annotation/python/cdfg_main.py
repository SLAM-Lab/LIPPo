#!/usr/bin/python
from cdfg_analysis import cdfg_explore
import sys
import argparse

class CdfgOptions(object):
    pass

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description='Extract operator information from HLS metadata.',
        epilog='Copyright: Dongwook.lee@utexas.edu')
    parser.add_argument('design', help="input: Name of HLS function")
    parser.add_argument('--cdfg', required=False, help="input: CDFG metadata",
                        action='store')
    parser.add_argument('--dfg', required=False, help="input: DFG metadata",
                        action='store')
    parser.add_argument('--resource', required=False,
                        help="input: resource information", action='store')
    parser.add_argument('--bb', required=False,
                        help="output: basicblock information", action='store',
                        default='bbInfo.txt')
    parser.add_argument('--pipeline', required=False,
                        help="output: pipeline information", action='store',
                        default='pipeline.txt')
    parser.add_argument('--copfile', required=False,
                        help="output: c-operator information", action='store',
                        default='bbOpCstep.txt')
    parser.add_argument('--ropfile', required=False,
                        help="output: rtl-resource information", action='store',
                        default='opBW.txt')
    
    parser.add_argument('--mode', required=True, type=int, choices={1, 0}, 
                        help="Cycle information mode", action='store',
                        default=True)
    parser.add_argument('--bbio', required=False, 
                        help="basicblock IO information mode", action='store',
                        default='bbio.txt')
    # args=i
    parser.parse_args(sys.argv[1:], namespace=CdfgOptions)
    print CdfgOptions.design
    if CdfgOptions.cdfg is None:
        CdfgOptions.cdfg = CdfgOptions.design + '.aemf'
    if CdfgOptions.dfg is None:
        CdfgOptions.dfg = CdfgOptions.design + '.adb.xml'
    if CdfgOptions.resource is None:
        CdfgOptions.resource = CdfgOptions.design + '.verbose.rtp.xml'


    #  cdfg_explore("../examples/dct/pipe_hls/","dct")
    cdfg_explore(CdfgOptions.design, CdfgOptions.cdfg, CdfgOptions.dfg,
                 CdfgOptions.resource, CdfgOptions.bb, CdfgOptions.pipeline,
                 CdfgOptions.copfile, CdfgOptions.ropfile, CdfgOptions.mode, CdfgOptions.bbio)
