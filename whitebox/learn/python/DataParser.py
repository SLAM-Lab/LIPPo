#!/usr/bin/python
from copy import copy
import numpy as np

def read_activity(filename):
    with open(filename) as f:
        act_info = list()
        idx_info = list()
        line = f.readline()
        invoke_count = -1
        bb_cs_info = dict()
        cs_info = set()
        bb_info = list()
        while line != '':
            bb_items = [int(x) for x in line.rstrip("\n").split(",")]
            bb_steps = bb_items[-1]
            bb_id = bb_items[0]
            bb_key = bb_items[1]
            if bb_id == 0:
                invoke_count += 1
            if bb_id not in bb_cs_info:
                bb_cs_info[bb_id] = dict()
            for i in range(0, bb_steps):
                line = f.readline()
                cs_items = [int(x) for x in line.rstrip("\n").split(",")]
                cs_id = cs_items[0]
                # cs_key = cs_items[1]
                cs_info.add(cs_id)
                cs_act = cs_items[2:]
                act_info.append(cs_act)
                idx_info.append([invoke_count, bb_id, bb_steps, bb_key, cs_id, i])
                if bb_key not in bb_cs_info[bb_id]:
                    bb_cs_info[bb_id][bb_key] = list()
                if [cs_id, i] not in bb_cs_info[bb_id][bb_key]:
                    bb_cs_info[bb_id][bb_key].append([cs_id, i])
                if [bb_id, bb_steps, bb_key] not in bb_info:
                    bb_info.append([bb_id, bb_steps, bb_key])
            line = f.readline()

    return idx_info, act_info, bb_cs_info, cs_info, bb_info


class ActivityData:
    def __init__(self, idx_info, act_info, bb_cs_info, cs_info, bb_info):
        self.bb_cs_info = bb_cs_info
        self.cs_info = cs_info
        self.act_info = np.array(act_info)
        self.idx_info = np.array(idx_info)
        self.bb_info = bb_info
        # print self.bb_cs_info

    def get_index(self, bb_id, bb_steps, bb_key, cs_id, cs_idx):
        ret=[]
        for idx, row in enumerate(self.idx_info):
            if (( bb_id == -1 or    row[1] == bb_id) and
                ( bb_steps == -1 or row[2] == bb_steps) and
                ( bb_key == -1 or   row[3] == bb_key) and
                ( cs_id == -1 or    row[4] == cs_id) and
                ( cs_idx == -1 or   row[5] == cs_idx) ):
                ret.append(idx)
        return ret

    def get_activity(self, bb_id, bb_steps, bb_key, cs_id, cs_idx):
        indices = self.get_index(bb_id, bb_steps, bb_key, cs_id, cs_idx)
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
        # type: (int, int, int) -> object
        cs_list = self.bb_cs_info[bb_id][bb_key]
        # print "get_index_bb_activity: ", bb_id, bb_steps, bb_key, cs_list
        ret = []
        for (cs_id, cs_idx) in cs_list:
            tmp = self.get_index(bb_id, bb_steps, bb_key, cs_id, cs_idx)
            # print cs_id,cs_idx, len(tmp)
            ret.append(tmp)
        return ret

    def get_bb_activity(self, bb_id, bb_steps, bb_key):
        cs_list = self.bb_cs_info[bb_id][bb_key]
        ret = []
        for (cs_id, cs_idx) in cs_list:
            ret.append(self.get_activity(bb_id, bb_steps, bb_key, cs_id, cs_idx))
        return ret


if __name__ == "__main__":
    test()
