#!/usr/bin/python
from xml.dom import minidom


class COperator:
    """
    container for c operator information
    """

    def __init__(self, cdfg_id, c_step, code, opcode, rop):
        self.cdfg_id = cdfg_id
        self.c_step = c_step
        self.code = code
        self.opcode = opcode
        self.rtl_operator = rop
        self.basicblock_id = -1


class RTLOperator:
    """
    container for RTL operator information
    """

    def __init__(self, rtl_name, rtl_id):
        self.rtl_name_ = rtl_name
        self.rtl_id_ = rtl_id
        self.c_operator_list = []
        self.operator_s_bit_width_ = 0
        self.operator_a_bit_width_ = 0
        self.operator_b_bit_width_ = 0

    def set_operator_s_bit_width(self, i):
        """
        set a bit width of the result operator
        """
        if i > self.operator_s_bit_width_:
            self.operator_s_bit_width_ = i
        return

    def set_operator_a_bit_width(self, i):
        """
        set a bit width of the op0 operator
        """
        if self.operator_a_bit_width_ < i:
            self.operator_a_bit_width_ = i
        return

    def set_operator_b_bit_width(self, i):
        """
        set a bit width of the op1 operator
        """
        if self.operator_b_bit_width_ < i:
            self.operator_b_bit_width_ = i

    def add_c_operator(self, cop):
        """
        add mapped c operator
        """
        self.c_operator_list.append(cop)


class Basicblock:
    """
    container for basicblock information
    """

    def __init__(self, bb_id, regions):
        self.basicblock_id = bb_id
        self.rename_basicblock_id = -1
        self.c_operator_list = []
        self.c_steps = set()
        self.regions = regions
        # region -> large group of basicblocks for scheduling
        # A group of blackblocks are scheduled in the same pipeline block
        self.branch_code = ''
        self.source_cdfg_id = -1
        self.begin_code = ''
        self.sink_cdfg_id = -1
        self.end_code = ''

    def add_c_operator(self, node_id):
        """
        add c_operators in the basicblock
        """
        self.c_operator_list.append(node_id)

    def add_c_step(self, c_step):
        """
        add assigned c_steps in the basicblock w/o considering
        pipeline
        """
        self.c_steps.add(c_step)

    # def add_region(self, region):
    #    self.regions = region

    def set_source_c_operator(self, cdfg_node_id):
        """
        set the source c operator node of the basicblock
        """
        self.source_cdfg_id = cdfg_node_id
        self.begin_code = ''

    def set_sink_c_operator(self, cdfg_node_id):
        """
        set the source c operator node of the basicblock
        """
        self.sink_cdfg_id = cdfg_node_id
        self.end_code = ''


class PipelineBlock:
    def __init__(self, region_id, ii, depth):
        self.region_id = region_id
        self.ii = ii
        self.depth = depth
        self.sub_regions = set()
        self.basicblocks = list()

    def add_sub_region(self, sub_region_id):
        self.sub_regions.add(sub_region_id)

    def add_basicblock(self, basicblock_id):
        self.basicblocks.append(basicblock_id)

class BasicBlockIOInfo:
  def __init__(self, filename):
    self.instruction_list=[] # code, masks
    try:
        print filename
        with open(filename,"r") as f:
            for line in f:
                tmp=line.strip().split("|")
                self.instruction_list.append((tmp[0],int(tmp[1]),int(tmp[2]),int(tmp[3])));
    except:
      print "Opps"
  def isIO(self,code):
    for i in self.instruction_list:
        if code == i[0]:
            return (True, i[1],i[2],i[3])
    return (False, 0,0,0)

   
  


def get_basicblock_list(cdfg):
    """
    extract basicblock list from cdfg
    """

    def _get_basicblocks_from_raw_basicblock_list(_basicblock_list,
                                                  _raw_basicblock_list,
                                                  _region_id):
        for basicblock in _raw_basicblock_list:
            # create basicblock object with id
            basicblock_object = Basicblock(
                int(basicblock.attributes['id'].value), _region_id)
            _basicblock_list.append(basicblock_object)
            # get node objects (c operators) located in given basicblock (bb)
            node_objects = basicblock.getElementsByTagName('node_objs')
            for idx, node in enumerate(node_objects):
                cdfg_id = int(node.attributes['id'].value)
                _basicblock_list[-1].add_c_operator(cdfg_id)
                # opcode = node.attributes['opcode'].value
                if idx == 0:  # first node => source
                    _basicblock_list[-1].set_source_c_operator(cdfg_id)
                if len(node_objects) - 1 == idx:  # last node => end
                    _basicblock_list[-1].set_sink_c_operator(cdfg_id)

    basicblock_list = []
    # get basicblock list for non-pipelined part
    raw_basicblock_list = cdfg.getElementsByTagName('blocks')
    if (raw_basicblock_list is not None) and (len(raw_basicblock_list) > 0):
        _get_basicblocks_from_raw_basicblock_list(basicblock_list,
                                                  raw_basicblock_list, -1)
    # get region information  for pipelined part
    raw_basicblock_list = cdfg.getElementsByTagName('regions')
    for region in raw_basicblock_list:
        region_id = int(region.attributes['id'].value)
        raw_basicblock_list = region.getElementsByTagName('basic_blocks')
        _get_basicblocks_from_raw_basicblock_list(basicblock_list,
                                                  raw_basicblock_list,
                                                  region_id)
    return basicblock_list


def annotate_schedule_info(dfg, basicblock_list):
    """
    annotate c_step (w/o considering pipeline) into basicblocks and c_operators
    :param dfg: data flow graph
    :param basicblock_list: basicblock list
    """
    dfg_cop_info = dfg.getElementsByTagName('operation')
    for basicblock in basicblock_list:
        for node in basicblock.c_operator_list:
            for dfg_node in dfg_cop_info:
                node_id = int(
                    dfg_node.getElementsByTagName('node')[0].attributes[
                        'id'].value)
                if (node_id == node and dfg_node.attributes[
                        'stage'].value == '1'):
                    c_step = int(dfg_node.attributes['st_id'].value, 10) - 1
                    basicblock.add_c_step(c_step)
                    if basicblock.sink_cdfg_id == node_id:
                        c_code = ((dfg_node.getElementsByTagName('node')[
                                       0].firstChild.wholeText).strip(

                        )).partition(' ')
                        c_code = c_code[2].strip()
                        basicblock.end_code = c_code
                    if basicblock.source_cdfg_id == node_id:
                        c_code = ((dfg_node.getElementsByTagName('node')[
                                       0].firstChild.wholeText).strip(

                        )).partition(' ')
                        c_code = c_code[2].strip()
                        basicblock.begin_code = c_code
                    break


def annotate_pipeline_schedule_info(cdfg, basicblock_list,
                                    basicblock_info_filename,
                                    pipeline_filename):
    """
    Annotate renamed c_steps and region info into c_operators and basicblocks
    :param cdfg: cdfg extracted from xml
    :param basicblock_list: basicblock list
    :param basicblock_info_filename: output basicblock filename
    :param pipeline_filename: output pipeline filename
    """
    # make a sorted map
    basicblock_dict = dict(
        [(basicblock.basicblock_id, basicblock) for basicblock in
         basicblock_list])
    # why?: rename_basicblock_id
    # annotate new id for basicblock in execution order
    for j, i in enumerate(sorted(basicblock_dict)):
        basicblock_dict[i].rename_basicblock_id = j
    # read region info from cdfg
    regions = dict()
    region_list = cdfg.getElementsByTagName('cfgRegions')

    # get id, ii, depth
    for region in region_list:
        source_id = int(region.attributes["mId"].value)
        ii = int(region.attributes["mII"].value)
        depth = int(region.attributes["mDepth"].value)
        regions[source_id] = [set(), list(), ii, depth]  # sub_region,
        sub_regions = region.getElementsByTagName('subRegions')
        for sub_region in sub_regions:
            sink_id = int(sub_region.firstChild.wholeText)
            regions[source_id][0].add(sink_id)
            # print mId

        # get scheduled basicblocks
        basicblocks = region.getElementsByTagName('basicBlocks')
        for basicblock in basicblocks:
            basicblock_id = int(basicblock.firstChild.wholeText)
            regions[source_id][1].append(basicblock_id)

    # print regions
    # print bb_dict
    # recursive merging sub_regions to two level tree style
    def recursive_merging_sub_regions(region_id):
        for sub_region_id in regions[region_id][0]:  # get  sub_region id
            regions[region_id][1] = regions[region_id][
                                        1] + recursive_merging_sub_regions(
                sub_region_id)
        return regions[region_id][1]

    recursive_merging_sub_regions(1)
    # print dfs(1)
    # print regions

    for i in regions:
        regions[i][1] = list(set(regions[i][1]))
        regions[i][1].sort()

    rename_c_step = 0
    need_rename = False

    # write pipeline file
    with open(pipeline_filename, "w") as f:
        for i in regions:
            if regions[i][2] > 0:
                need_rename = True
        if need_rename:
            for i in regions[1][0]:
                if regions[i][2] > 0:
                    my_bb_list = regions[i][1]
                    tt = "{},{},{},{}".format(
                        basicblock_dict[my_bb_list[0]].rename_basicblock_id,
                        basicblock_dict[my_bb_list[0]].rename_basicblock_id,
                        regions[i][2], rename_c_step) + ',' + (
                             ','.join(["{}"] * (len(my_bb_list) - 1))).format(
                        *[basicblock_dict[x].rename_basicblock_id for x in
                          my_bb_list[1:]])
                    f.write(tt + "\n")
                    rename_c_step = rename_c_step + regions[i][2]
                else:
                    c_steps = set()
                    for basicblock in regions[i][1]:
                        c_steps = c_steps | set(
                            basicblock_dict[basicblock].c_steps)
                    c_steps = list(c_steps)
                    c_steps.sort()
                    for c_step in range(0, len(c_steps)):
                        tt = "{},{}".format(c_steps[0] + c_step, rename_c_step)
                        f.write(tt + "\n")
                        rename_c_step += 1
            print "done"
        else:
            c_steps = set()
            for i in regions[1][0]:
                for basicblock in regions[i][1]:
                    c_steps = c_steps | set(basicblock_dict[basicblock].c_steps)
            c_steps = list(c_steps)
            c_steps.sort()
            for i in range(0, len(c_steps)):
                tt = "{},{}".format(i, i)
                f.write(tt + "\n")

    # write basicblock info file
    with open(basicblock_info_filename, "w") as f:
        for key in sorted(basicblock_dict):
            basicblock = basicblock_dict[key]
            tt = str(basicblock.rename_basicblock_id) + "|" + ','.join(
                ["{}"] * len(basicblock.c_steps)).format(
                *basicblock.c_steps) + "|" + basicblock.begin_code + "|" + \
                    basicblock.end_code
            f.write(tt + "\n")

    return basicblock_dict

def get_dfg_ops(cdfg, dfg, report, bb_dict, copfile, ropfile, design, mode, bb_io_info=None):
    # get basicblock_id from cdfg_id
    def convert_cdfg_id_to_basicblock_id(cdfg_id):
        for i, bb in bb_dict.iteritems():
            if cdfg_id in bb.c_operator_list:
                return bb.rename_basicblock_id
        return -1

    # get info
    rtl_bit_widths = report.getElementsByTagName('column')
    cdfg_nodes = cdfg.getElementsByTagName('node_objs')
    dfg_c_operators = dfg.getElementsByTagName('operation')
    # rtlinfo = report.getElementsByTagName('column')
    # get/add rtl op info
    rtl_operators = dict()

    def get_rtl_operator(rtl_name):
        if not rtl_name in rtl_operators:
            rtl_id = len(rtl_operators)
            rtl_operators[rtl_name] = RTLOperator(rtl_name, rtl_id)
        return rtl_operators[rtl_name]

    c_operators_dict = dict()

    # create cop info
    def get_cop_info(cdfg_node):  # return cop object
        if not cdfg_node in c_operators_dict:
            cdfg_id = cdfg_node.attributes['id'].value
            opcode = cdfg_node.attributes['opcode'].value
            for dfg_node in dfg_c_operators:
                if (dfg_node.getElementsByTagName("node")[0].attributes[
                        'id'].value == cdfg_id and dfg_node.attributes[
                        "stage"].value == "1"):
                    c_step = int(dfg_node.attributes["st_id"].value, 10) - 1
                    nds = dfg_node.getElementsByTagName("node")
                    return_bit_width = int(nds[0].attributes["bw"].value, 10)
                    if "op_0_bw" in nds[0].attributes.keys():
                        op_a = int(nds[0].attributes["op_0_bw"].value, 10)
                    else:
                        op_a = 0
                    if "op_1_bw" in nds[0].attributes.keys():
                        op_b = int(nds[0].attributes["op_1_bw"].value, 10)
                    else:
                        op_b = 0
                    c_code = (nds[0].firstChild.wholeText.strip()).partition(
                        ' ')
                    code = c_code[2].strip()
                    return COperator(int(cdfg_id), c_step, code, None,
                                     opcode), (return_bit_width, op_a, op_b)
        # else:
        #  print "exist: ", cop_dict[cdfg_node].code
        return None, (None, None, None)

    # find arithmetic cop_dict:
    def get_arith_dfg_ops():
        for node in cdfg_nodes:
            if (node.attributes['opcode'].value == "mul" or node.attributes[
                'opcode'].value == "add" or node.attributes[
                    'opcode'].value == "sub"):
                c_operator, (return_bit_width, op_a, op_b) = get_cop_info(node)
                c_operators_dict[node] = c_operator
                if 'rtlName' in node.attributes.keys():
                    rtl_name = node.attributes['rtlName'].value
                else:
                    rtl_name = None
                    # print "opcode:", opcode, cdfg_id
                    print "Something wrong..."
                    # assign rop
                rop = get_rtl_operator(rtl_name)
                c_operators_dict[node].rop = rop
                # print cop_dict[node].cdfg_id
                c_operators_dict[node].bbid = convert_cdfg_id_to_basicblock_id(
                    c_operators_dict[node].cdfg_id)
                rop.add_c_operator(c_operators_dict[node])
                rop.set_operator_s_bit_width(return_bit_width)
                rop.set_operator_a_bit_width(op_a)
                rop.set_operator_b_bit_width(op_b)
                # bit width update
                for rtl_bit_width in rtl_bit_widths:
                    if rtl_bit_width.attributes["name"].value == rtl_name:
                        parsed = rtl_bit_width.firstChild.wholeText.split(",")
                        rop.set_operator_a_bit_width(int(parsed[4], 10))
                        rop.set_operator_b_bit_width(int(parsed[5], 10))
        for i, (rtlName, rop) in enumerate(rtl_operators.iteritems()):
            if rop.operator_b_bit_width_ == 0:
                rop.operator_b_bit_width_ = rop.operator_s_bit_width_
            if rop.operator_a_bit_width_ == 0:
                rop.operator_a_bit_width_ = rop.operator_s_bit_width_

    def print_c_operators():
        # print "bbOpCstep.txt"
        with open(copfile, "w") as f:
            f.write(design + "\n")
            for i, (rtlName, rop) in enumerate(rtl_operators.iteritems()):
                for op in rop.c_operator_list:
                    tt = "{}|{}|{}|{}".format(op.code, i, op.c_step, op.bbid)
                    f.write(tt + "\n")

    # print opBW.txt
    def print_rtl_operators():
        with open(ropfile, "w") as f:
            for i, (rtlName, rop) in enumerate(rtl_operators.iteritems()):
                tt = "{} {} {} {}".format(rtlName, rop.operator_a_bit_width_, rop.operator_b_bit_width_,
                                          rop.operator_s_bit_width_)
                f.write(tt + "\n")
                # find mem/register node

    cdfg_reg_info = cdfg.getElementsByTagName('regnodes')
    cdfg_mem_info = cdfg.getElementsByTagName('memoryPorts')

    def find_register_nodes():  # return node id lists
        for reg in cdfg_reg_info:
            name = reg.attributes["realName"].value
            discard = False
            _cops = []
            bits = 0
            for rg in reg.getElementsByTagName("nodeIds"):
                node_id = int(rg.firstChild.wholeText.strip())
                for node in cdfg_nodes:
                    if int(node.attributes['id'].value) == node_id:
                        _cop, (return_bit_width, op_a, op_b) \
                            = get_cop_info(node)
                        _cops.append((node, _cop))
                        # print name,return_bit_width
                        if return_bit_width > bits:
                            bits = return_bit_width
                        if ((_cop is None) or node.attributes[
                                'opcode'].value == 'load' or node.attributes[
                                'opcode'].value == 'store' or node.attributes[
                                'opcode'].value == 'phi'):
                            discard = True
                            break
            if not discard:
                for node, _cop in _cops:
                    rop = get_rtl_operator(name)
                    rop.set_operator_s_bit_width(bits)
                    c_operators_dict[node] = _cop
                    c_operators_dict[node].rop = rop
                    c_operators_dict[
                        node].bbid = convert_cdfg_id_to_basicblock_id(
                        c_operators_dict[node].cdfg_id)
                    rop.add_c_operator(c_operators_dict[node])

    def find_basicblock_io_nodes(basicblock_io_info):
        for node in cdfg_nodes:
            bits = 0
            _cop, (return_bit_width, op_a, op_b) \
                = get_cop_info(node)
            if _cop!=None:
                (is_io, mask_s, mask_a, mask_b)=basicblock_io_info.isIO(_cop.code)
                if is_io:
                    if 'rtlName' in node.attributes.keys():
                        rtl_name = node.attributes['rtlName'].value
                    else:
                        rtl_name = node.attributes["name"].value
                    rop = get_rtl_operator(rtl_name)
                    if return_bit_width > bits:
                        bits = return_bit_width
                    if(mask_s !=0):
                        rop.set_operator_s_bit_width(bits)
                    else:
                        rop.set_operator_s_bit_width(0)
                    if(mask_a !=0):
                        if(op_a==0):
                          rop.set_operator_a_bit_width(bits)
                        else:
                          rop.set_operator_a_bit_width(op_a)
                    else:
                        rop.set_operator_a_bit_width(0)
                    if(mask_b !=0):
                        if(op_b==0):
                          rop.set_operator_b_bit_width(bits)
                        else:
                          rop.set_operator_b_bit_width(op_a)
                    else:
                        rop.set_operator_b_bit_width(0)

                    c_operators_dict[node] = _cop
                    c_operators_dict[node].rop = rop
                    c_operators_dict[
                        node].bbid = convert_cdfg_id_to_basicblock_id(
                        c_operators_dict[node].cdfg_id)
                    rop.add_c_operator(c_operators_dict[node])

                
    def find_mem_nodes():  # return node id lists
        for mem in cdfg_mem_info:
            if "portID" in mem.attributes.keys():
                port_id = int(mem.attributes["portID"].value)
            else:
                port_id = 0
            name = mem.attributes["dataString"].value + "_{}".format(port_id)
            for node_id_tag in mem.getElementsByTagName("nodeIds"):
                node_id = int(node_id_tag.firstChild.wholeText.strip())
                for node in cdfg_nodes:
                    if int(node.attributes['id'].value) == node_id:
                        if node.attributes["opcode"].value == "load":
                            _cop, (return_bit_width, op_a, op_b) = get_cop_info(
                                node)
                            c_operators_dict[node] = _cop
                            rop = get_rtl_operator(name + "_load")
                            rop.set_operator_s_bit_width(return_bit_width)
                            c_operators_dict[node].rop = rop
                            c_operators_dict[
                                node].bbid = convert_cdfg_id_to_basicblock_id(
                                c_operators_dict[node].cdfg_id)
                            rop.add_c_operator(c_operators_dict[node])
                        if node.attributes["opcode"].value == "store":
                            _cop, (return_bit_width, op_a, op_b) = get_cop_info(
                                node)
                            c_operators_dict[node] = _cop
                            rop = get_rtl_operator(name + "_store")
                            rop.set_operator_a_bit_width(op_a)
                            c_operators_dict[node].rop = rop
                            c_operators_dict[
                                node].bbid = convert_cdfg_id_to_basicblock_id(
                                c_operators_dict[node].cdfg_id)
                            rop.add_c_operator(c_operators_dict[node])

                            # clear cop_dict
                            # list of register nodes

    if mode == 1:
        get_arith_dfg_ops()
        find_register_nodes()
    else:
        find_mem_nodes()
        find_basicblock_io_nodes(bb_io_info)
        # find load/store [mem/register]
    # for node in cdfg_node_lists:
    #   if(node.attributes['opcode'].value=="load"):
    #     get_cop_info(node)
    #   elif(node.attributes['opcode'].value=="store"):
    #     get_cop_info(node)
    #   if(int(node.attributes['id'].value) in regnodes):
    #     get_arith_cop_info(node)
    print "Start:"
    print_c_operators()
    print_rtl_operators()


# for i,(rtlName,rop) in enumerate(rtlops.iteritems()):
#   #   if(rop.opBBW==0):
#   #     rop.opBBW=rop.opSBW
#   #   if(rop.opABW==0):
#   #     rop.opABW=rop.opSBW
#   print "{} {} {} {}".format(rtlName, rop.opABW, rop.opBBW, rop.opSBW)

def cdfg_explore(design, cdfg_file, dfg_file, rsc_file,\
    bbfile, pipefile, copfile, ropfile, mode, bbio_file_name=''):
# read DBs
  cdfg = minidom.parse(cdfg_file)
  dfg  = minidom.parse(dfg_file)
  report  = minidom.parse(rsc_file)
  bb_list=get_basicblock_list(cdfg);
  annotate_schedule_info(dfg, bb_list)
  bb_dict=annotate_pipeline_schedule_info(cdfg, bb_list, bbfile, pipefile)
  bb_io_info=BasicBlockIOInfo(bbio_file_name);
  get_dfg_ops(cdfg, dfg, report, bb_dict, copfile, ropfile,\
      design, mode, bb_io_info)
