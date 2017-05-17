#pragma once
typedef unsigned int uint32_t;

class Regression
{
  public:
    Regression() {}
    virtual ~Regression() {}
//    virtual 
//  double predict(double* X)=0;
    virtual 
  double predict(uint32_t* X)=0;
};
