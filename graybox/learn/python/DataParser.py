#!/usr/bin/python
from copy import copy
import numpy as np



class ActivityData:
    def __init__(self, idx_info, act_info, bb_info):
        self.act_info = np.array(act_info)
        self.idx_info = np.array(idx_info)
        self.bb_info = bb_info
        # print self.bb_cs_info
    def get_index(self, bb_id, bb_steps, bb_key):
        ret=[]
        for idx, row in enumerate(self.idx_info):
            if (( bb_id == -1 or    row[1] == bb_id) and
                ( bb_steps == -1 or row[2] == bb_steps) and
                ( bb_key == -1 or   row[3] == bb_key)):
                ret.append(idx)
        return ret

    def get_activity(self, bb_id, bb_steps, bb_key):
        indices = self.get_index(bb_id, bb_steps, bb_key)
        # return self.act_info[indices]
        if (indices is not None) and len(indices) != 0:
            first_features = self.act_info[indices[0]]
        else:
            return None
        ret = np.zeros((len(indices), len(first_features)))
        for idx, i in enumerate(indices):
            ret[idx] = self.act_info[i]
        return ret

    def get_index_bb_activity(self, bb_id, bb_steps, bb_key):
        # print "get_index_bb_activity: ", bb_id, bb_steps, bb_key, cs_list
        ret = self.get_index(bb_id, bb_steps, bb_key)
            # print cs_id,cs_idx, len(tmp)
        return ret

    def get_bb_activity(self, bb_id, bb_steps, bb_key):
        ret=self.get_activity(bb_id, bb_steps, bb_key)
        return ret


def read_bb_activity(filename):
    with open(filename) as f:
        #print "read_bb_activity ???"
        act_info = list()
        idx_info = list()
        invoke_count = -1
        bb_info = list()
        act_info_prev = [] 
        act_info_pprev = []
        pprev_bb_key = 0
        prev_bb_key = 0
        for line in f:
            bb_items = [int(x) for x in line.rstrip("\n").split(",")]
            bb_id = bb_items[0]
            curr_bb_key = bb_items[1]
            bb_steps = bb_items[2]
            #     bb_key=make_key([bb_history[0], bb_history[2], bb_history[3]])
            bb_key = curr_bb_key# + prev_bb_key + pprev_bb_key
            act_info_curr = bb_items[3:]
            if bb_id == 0:
                invoke_count += 1
            if not [bb_id, bb_steps, bb_key] in bb_info:
                bb_info.append([bb_id, bb_steps, bb_key])

            idx_info.append([invoke_count, bb_id, bb_steps, bb_key])
            act_info.append(act_info_pprev + act_info_prev + act_info_curr)
                   # act_info.append(act_info_curr)
            act_info_pprev = copy(act_info_prev)
            act_info_prev = copy(act_info_curr)
            pprev_bb_key = prev_bb_key
            prev_bb_key = curr_bb_key
#   # print bb_cs_info
    return idx_info, act_info, bb_info


