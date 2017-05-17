#include "parse.h"
template<>
int lexical_cast<int>(string item)
{
  return stoi(item);
}
template<>
double lexical_cast<double>(string item) 
{
  return stold(item);
  
}
