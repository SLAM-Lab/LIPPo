
/*******************************************************************************
Vendor: Xilinx 
Associated Filename: matrixmul_test.cpp
Purpose: Matrix multiplication example for AutoESL
Revision History: February 13, 2012 - initial release
                                                
*******************************************************************************
Copyright (C) 2013 XILINX, Inc. 

This file contains confidential and proprietary information of Xilinx, Inc. and 
is protected under U.S. and international copyright and other intellectual 
property laws.

DISCLAIMER
This disclaimer is not a license and does not grant any rights to the materials 
distributed herewith. Except as otherwise provided in a valid license issued to 
you by Xilinx, and to the maximum extent permitted by applicable law: 
(1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX 
HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, 
INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR 
FITNESS FOR ANY PARTICULAR PURPOSE; and (2) Xilinx shall not be liable (whether 
in contract or tort, including negligence, or under any other theory of 
liability) for any loss or damage of any kind or nature related to, arising under 
or in connection with these materials, including for any direct, or any indirect, 
special, incidental, or consequential loss or damage (including loss of data, 
profits, goodwill, or any type of loss or damage suffered as a result of any 
action brought by a third party) even if such damage or loss was reasonably 
foreseeable or Xilinx had been advised of the possibility of the same.

CRITICAL APPLICATIONS
Xilinx products are not designed or intended to be fail-safe, or for use in any 
application requiring fail-safe performance, such as life-support or safety 
devices or systems, Class III medical devices, nuclear facilities, applications 
related to the deployment of airbags, or any other applications that could lead 
to death, personal injury, or severe property or environmental damage 
(individually and collectively, "Critical Applications"). Customer assumes the 
sole risk and liability of any use of Xilinx products in Critical Applications, 
subject only to applicable laws and regulations governing limitations on product 
liability. 

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT 
ALL TIMES.

*******************************************************************************/

#include <iostream>
#include "matrixmul.h"
#include <stdlib.h>
#include <sys/time.h>
using namespace std;
int randint(int s, int e)
{
	return rand()%(e-s+1)+s;
}

void rand_mat_a(int s, int e, mat_a_t ret[MAT_A_ROWS][MAT_A_COLS])
{
	for(int i=0; i<MAT_A_ROWS ; i++)
	{
		for(int j=0; j<MAT_A_COLS; j++)
		{
			ret[i][j]=randint(s,e);
		}
	}
}
void rand_mat_b(int s, int e, mat_b_t ret[MAT_B_ROWS][MAT_B_COLS])
{
	for(int i=0; i<MAT_B_ROWS ; i++)
	{
		for(int j=0; j<MAT_B_COLS; j++)
		{
			ret[i][j]=randint(s,e);
		}
	}
}
#include "funcinfo.h"
#include "trace.h"
int main(int argc, char **argv)
{
  unique_ptr<FuncInfo> finfo=buildFuncInfo("bbInfo.txt",argv[1],"pipeline.txt");
  TraceSim::simulator=std::move(buildTraceSim(finfo,argv[2]));

   result_t hw_result[MAT_A_ROWS][MAT_B_COLS], sw_result[MAT_A_ROWS][MAT_B_COLS];
   int err_cnt = 0;
   mat_a_t in_mat_a[MAT_A_ROWS][MAT_A_COLS];
   mat_b_t in_mat_b[MAT_B_ROWS][MAT_B_COLS];
  struct timeval t1, t2;
  double elapsedTime;
  gettimeofday(&t1, NULL);
#ifdef VALID
#define TEST_VECTOR 5000
   srand(100);
#else
#define TEST_VECTOR 3000
#endif
	 for(int ll=0; ll<TEST_VECTOR; ll++)
	 {
		 int bias_a=rand()%10000;
		 int bias_b=rand()%10000;
		 int bias_c=rand()%1000;
		 int bias_d=rand()%1000;
		 rand_mat_a(bias_a,bias_a+bias_c, in_mat_a);
		 rand_mat_b(bias_b,bias_b+bias_d, in_mat_b);
		 // Generate the expected result
		 // Iterate over the rows of the A matrix
		 for(int i = 0; i < MAT_A_ROWS; i++) {
				for(int j = 0; j < MAT_B_COLS; j++) {
					 // Iterate over the columns of the B matrix
					 sw_result[i][j] = 0;
					 // Do the inner product of a row of A and col of B
					 for(int k = 0; k < MAT_B_ROWS; k++) {
							sw_result[i][j] += in_mat_a[i][k] * in_mat_b[k][j];
					 }
				}
		 }

		 matrixmul(in_mat_a, in_mat_b, hw_result);

		 /*cout << ll<<"{" << endl;
		 for (int i = 0; i < MAT_A_ROWS; i++) {
				//cout << "{";
				for (int j = 0; j < MAT_B_COLS; j++) {
					 cout << hw_result[i][j];
					 if (hw_result[i][j] != sw_result[i][j]) {
							err_cnt++;
							cout << "*";
					 }
					 if (j == MAT_B_COLS - 1)
							cout << "}" << endl;
					 else
							cout << ",";
				}
		 }
		 cout << "}" << endl;*/
	 }
  gettimeofday(&t2, NULL);
  elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000.0;      // sec to ms
  elapsedTime += (t2.tv_usec - t1.tv_usec) / 1000.0;   // us to ms
  std::cout << elapsedTime << " ms.\n";

   if (err_cnt)
      cout << "ERROR: " << err_cnt << " mismatches detected!" << endl;
   else
      cout << "Test passes." << endl;
   return err_cnt;
//  delete TraceSim::simulator;
}

