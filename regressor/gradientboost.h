#pragma once
#include "tree.h"
#ifdef _OPENMP
#include <omp.h>
#endif

class GradientBoost : public Regression
{
  public:
    int total_tree;
    double learning_rate;
    double mean;
    GradientBoost(int cap)
      :total_tree(0)
    {
      forest.reserve(cap);
    }
    GradientBoost(istream& is)
    {
      string linebuffer;
      getline(is,linebuffer);
      mean=lexical_cast<double>(linebuffer);
      getline(is,linebuffer);
      learning_rate=lexical_cast<double>(linebuffer);
      // mean,learning rate
      // total node
      getline(is, linebuffer);
      total_tree=lexical_cast<int>(linebuffer);
      forest.resize(total_tree);


      for(int i=0; i<total_tree; i++)
      {
        getline(is,linebuffer);
        // total node
        int sub_tree=lexical_cast<int>(linebuffer);
        for(int j=0; j<sub_tree; j++)
        {
          forest[i].emplace_back(is);
        }
      }
    }
    GradientBoost(vector<vector<Tree> >& _forest, 
        int total_tree, double mean, double learning_rate)
      :total_tree(total_tree), mean(mean), learning_rate(learning_rate)
    {
      forest.swap(_forest);
      
    }
    vector<vector<Tree> > forest;
    double predict(uint32_t* X)
    {
      double sum=0;
#pragma omp_parallel_for reduction(+:sum)
      for(auto& trees : forest)
      {
        assert(trees.size()==1);
        double tmp=trees[0].predict(X);
        sum+=learning_rate*tmp;
      }
      return mean+sum;
    }
// double predict(double* X)
// {
//   double sum=0;
//   for(auto& trees : forest)
//   {
//     for(auto& tree : trees)
//     {
//       double tmp=tree.predict(X);
//       sum+=tmp;
//     }
//   }
//   return mean+learning_rate*sum/total_tree;
// }
};
