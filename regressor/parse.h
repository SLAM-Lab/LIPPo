#pragma once
#include <list>
#include <map>
#include <vector>
#include <set>
#include <fstream>
#include <string>
#include <memory>
#include <iostream>
using namespace std;
//#define __STD_REGEX__
#ifdef __STD_REGEX__
#include <regex>
typedef std::regex rx_t;
typedef std::regex_token_iterator<std::string::iterator> rx_iter_t;
#else
#include <boost/tr1/regex.hpp>
#include <boost/algorithm/string/classification.hpp>
#include <boost/algorithm/string/split.hpp>
#include <boost/lexical_cast.hpp>
typedef boost::regex rx_t;
typedef boost::regex_token_iterator<std::string::iterator> rx_iter_t;
#endif
// HELP FUNCTION FOR PARSING
template<typename T>
T lexical_cast(string item)
{
  return T(item);
}
template<>
int lexical_cast<int>(string item);
template<>
double lexical_cast<double>(string item);
template<typename T>
int parser(string line, string bb_sep_s, vector<T>& tokens)
{
    rx_t bb_sep(bb_sep_s);
    tokens.clear();
    rx_iter_t 
              bb_tokens(line.begin(), line.end(), bb_sep,-1);
    rx_iter_t tend;

    while(bb_tokens!=tend)
    {
      tokens.push_back(lexical_cast<T>(*bb_tokens));
      bb_tokens++;
    }
    return tokens.size();
}
template<typename T>
int parser(string line, string bb_sep_s, list<T>& tokens)
{
    rx_t bb_sep(bb_sep_s);
    tokens.clear();
    rx_iter_t
              bb_tokens(line.begin(), line.end(), bb_sep,-1);
    rx_iter_t tend;

    while(bb_tokens!=tend)
    {
      tokens.push_back(lexical_cast<T>(*bb_tokens));
      bb_tokens++;
    }
    return tokens.size();
}
// HELP FUNCTION FOR ADD ITEMS in SET with ERROR HANDLING
/*
template<class T>
void lineParse(vector<T>& out, string& linebuffer)
{
  vector<string> buff;
  boost::split(buff,linebuffer,boost::is_any_of("  \n"));
  if(out.size()!=buff.size())
  {
    out.resize(buff.size());
  }
  for(int i=0; i<buff.size(); i++)
  {
    T k=lexical_cast<T>(buff[i]);
    out[i]=k;
  }
}*/
