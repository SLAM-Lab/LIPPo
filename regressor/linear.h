#pragma once
#include "regression.h"
class LinearRegression :public Regression
{
  public:
    LinearRegression(istream& is)
    {
      string linebuffer;
      getline(is,linebuffer);
      parser(linebuffer, " ",_coeff);
      coeff=_coeff.data();
      coeff_len=_coeff.size();
     // cout<<"read from file\n";
     /// for(int i=0,e=coeff_len;i!=e;i++)
     // {
      //  cout<<coeff[i]<<" ";
     // }
     // cout<<" "<<coeff_len<<"\n";
    }
    LinearRegression(double* coeff,int coeff_len)
      :coeff(coeff), coeff_len(coeff_len)
    {
    //  cout<<"embedded\n";
    //  for(int i=0,e=coeff_len;i!=e;i++)
    //  {
    //    cout<<coeff[i]<<" ";
   //   }
   //   cout<<" "<<coeff_len<<"\n";
    }
    double predict(uint32_t* X)
    {
      double sum=coeff[0];
      for(int i=0,e=coeff_len-1;i<e; i++)
      {
     //   cout<<X[i]<<" ";
        sum+=coeff[i+1]*X[i];
      }
     // cout<<"\n";
      return sum;
    }
    double* coeff;
    vector<double> _coeff;
    int coeff_len;
};
