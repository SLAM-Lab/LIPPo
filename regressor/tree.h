#pragma once
#include <array>
#include <vector>
#include "regression.h"
#include "parse.h"
#include <iostream>

class Tree : public Regression
{
  public:
    int* children_left;
    int* children_right;
    int* feature;
    double* threshold;
    double* value;
    vector<int> _children_left ;
    vector<int> _children_right;
    vector<int> _feature       ;
    vector<double> _threshold  ; 
    vector<double> _value      ;
    Tree(
        int* children_left,
        int* children_right,
        int* feature,
        double* threshold,
        double* value)
      :children_right(children_right),
      children_left(children_left),
      feature(feature),
      threshold(threshold),
      value(value)
    {
    }
    Tree(istream& is)
    {
      string linebuffer;
      getline(is,linebuffer);
      // total node
      int _total_node=lexical_cast<int>(linebuffer);
      // child_left
      getline(is,linebuffer);
      parser(linebuffer, " ",_children_left);
      // child_right
      getline(is,linebuffer);
      parser(linebuffer, " ",_children_right);
      // feature
      getline(is,linebuffer);
      parser(linebuffer, " ",_feature);
      // threshold
      getline(is,linebuffer);
      parser(linebuffer, " ",_threshold);
      // value
      getline(is,linebuffer);
      parser(linebuffer, " ",_value); 
      children_left =_children_left.data();
      children_right=_children_right.data();
      feature       =_feature.data();
      threshold     =_threshold.data();
      value         =_value.data();
    }
    ~Tree()
    {
    }
    double predict(uint32_t* X)
    {
      int id=0;
      while(children_left[id]!=-1 && children_right[id]!=-1)
      {
        if(X[feature[id]]<=threshold[id])
        {
          id=children_left[id];
        }
        else
        {
          id=children_right[id];
        }
      }
      return value[id];
    }
};
