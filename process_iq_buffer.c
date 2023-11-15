#include "gpssim.h"
#include "mex.h"  
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define FLOAT_CARR_PHASE

// void process_iq_buffer(channel_t chan[], int gain[], int cosTable512[], int sinTable512[], int iq_buff_size, double delt, short iq_buff[])
// {
// 	int isamp, i, iTable, ip, qp, i_acc, q_acc;
//           
// 	for (isamp = 0; isamp < iq_buff_size; isamp++)
// 	{
// 		i_acc = 0;
// 		q_acc = 0;
//        
// 		for (i = 0; i < MAX_CHAN; i++)
// 		{
// //            printf("debug 1\n");
// //            printf("Debug chan[i].prn: %d\n", chan[i].prn);
// 
// 			if (chan[i].prn > 0)
// 			{
// //            printf("debug 2.1\n");
//         
// #ifdef FLOAT_CARR_PHASE  
// 				iTable = (int)floor(chan[i].carr_phase * 512.0);
// //                 printf("debug 3\n");
// 
// #else  
// 				iTable = (chan[i].carr_phase >> 16) & 0x1ff; // 9-bit index  
// #endif  
//                 printf("debug 3 iTable is : %d\n", iTable);
// //                 printf("debug 3 dataBit is : %d\n", chan[i].dataBit);
// 
// 				ip = chan[i].dataBit * chan[i].codeCA * cosTable512[iTable] * gain[i];
// 				qp = chan[i].dataBit * chan[i].codeCA * sinTable512[iTable] * gain[i];
//                 
//                 printf("Debug chan[i].dataBit: %d\n", chan[i].dataBit);
//                 printf("Debug chan[i].codeCA: %d\n", chan[i].codeCA);
//                 printf("Debug gain[i]: %d\n", gain[i]);
//                 printf("Debug cosTable512[iTable]: %d\n", cosTable512[iTable]);
//                 printf("Debug sinTable512[iTable]: %d\n", sinTable512[iTable]);
// 
//                 
// 				// Accumulate for all visible satellites  
// 				i_acc += ip;
// 				q_acc += qp;
// 
// 				// Update code phase  
// 				chan[i].code_phase += chan[i].f_code * delt;
// //                 printf("debug 5\n");
//                 
// 				if (chan[i].code_phase >= CA_SEQ_LEN)
// 				{
// 					chan[i].code_phase -= CA_SEQ_LEN;
// 					chan[i].icode++;
// 					if (chan[i].icode >= 20) // 20 C/A codes = 1 navigation data bit  
// 					{
// 						chan[i].icode = 0;
// 						chan[i].ibit++;
// 						if (chan[i].ibit >= 30) // 30 navigation data bits = 1 word  
// 						{
// 							chan[i].ibit = 0;
// 							chan[i].iword++;
// 						}
// //                         printf("debug 6 iword is %d\n", chan[i].iword);
//                         
// 						// Set new navigation data bit  
// 						chan[i].dataBit = (int)((chan[i].dwrd[chan[i].iword] >> (29 - chan[i].ibit)) & 0x1UL) * 2 - 1;
// 					}
// 				}
// 
// 				// Set current code chip  
// 				chan[i].codeCA = chan[i].ca[(int)chan[i].code_phase] * 2 - 1;
// 
// 				// Update carrier phase  
// #ifdef FLOAT_CARR_PHASE  
// 				chan[i].carr_phase += chan[i].f_carr * delt;
// 				if (chan[i].carr_phase >= 1.0)
// 					chan[i].carr_phase -= 1.0;
// 				else if (chan[i].carr_phase < 0.0)
// 					chan[i].carr_phase += 1.0;
// #else  
// 				chan[i].carr_phase += chan[i].carr_phasestep;
// #endif  
// 			}
// //             printf("debug 2.2\n");
// 		}
// 
// 		i_acc = (i_acc + 64) >> 7;
// 		q_acc = (q_acc + 64) >> 7;
// 		iq_buff[isamp * 2] = (short)i_acc;
// 		iq_buff[isamp * 2 + 1] = (short)q_acc;
//       
// 
// 	}
// }

void process_iq_buffer(double *carr_phase, double *code_phase,int *dataBit, int *codeCA, int *icode, int *ibit, int *iword,
        int gain, double f_carr, double f_code, double delt, int cosTable512[], int sinTable512[], unsigned long dwrd[N_DWRD],
        int ca[CA_SEQ_LEN], int iq_buff_size, int iq_buff[])
{                               
//     printf("Debug iword01 is %d\n", *iword);

	int isamp,iTable, ip, qp;
	for (isamp = 0; isamp < iq_buff_size; isamp++)
	{                           
#ifdef FLOAT_CARR_PHASE  
				iTable = (int)floor((*carr_phase) * 512.0);
//                  printf("Debug iTable is %d\n", iTable);
#else  
				iTable = ((*carr_phase) >> 16) & 0x1ff; // 9-bit index  
#endif  
//                 printf("Debug cosTable512[%d] is %d\n", iTable, cosTable512[iTable]);
//                 printf("Debug gain is %d\n", gain);
//                 printf("Debug f_code is %f\n", f_code);
//                 printf("Debug delt is %f\n", delt);

//                 *codeCA = 1;//debug     
				ip = (*dataBit) * (*codeCA) * cosTable512[iTable] * gain;
				qp = (*dataBit) * (*codeCA) * sinTable512[iTable] * gain;
                
//                 printf("Debug ip  is %d\n", ip);

				// Update code phase
                //printf("%f\n", *code_phase);
				*code_phase += f_code * delt;
				if (*code_phase >= CA_SEQ_LEN)
				{                    
					*code_phase -= CA_SEQ_LEN;
					*icode = (*icode)++;
					if (*icode >= 20) // 20 C/A codes = 1 navigation data bit  
					{
						*icode = 0;
						*ibit = (*ibit)++;
						if (*ibit >= 30) // 30 navigation data bits = 1 word  
						{
							*ibit = 0;
							*iword = (*iword)++;
						}
						// Set new navigation data bit  
                        // printf("dataBit %d, iword %d, ibit %d \n", *dataBit, *iword, *ibit);
						*dataBit = (int)((dwrd[*iword] >> (29 - *ibit)) & 0x1UL) * 2 - 1;
					}
				}
				// Set current code chip  
				*codeCA = ca[(int)(*code_phase)] * 2 - 1;
				// Update carrier phase  
#ifdef FLOAT_CARR_PHASE 
				*carr_phase += f_carr * delt;
				if (*carr_phase >= 1.0)
					*carr_phase -= 1.0;
				else if (*carr_phase < 0.0)
					*carr_phase += 1.0;
#else  
				*carr_phase += carr_phasestep;
#endif  
//                 ip = (ip + 64) >> 7;
//                 qp = (qp + 64) >> 7;
            
//                 iq_buff[isamp * 2] = (short)ip;
//                 iq_buff[isamp * 2 + 1] = (short)qp;
                
                   iq_buff[isamp * 2] = ip;
                   iq_buff[isamp * 2 + 1] = qp;
                
//                 if(isamp==376452)
//                     printf("debug:iq_buff %d, dataBit %d, codeCA %d\n", iq_buff[isamp * 2], *dataBit, *codeCA);
	}
//         printf("Debug iword02 is %d\n", *iword);

}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])  
{  
    double *carr_phase, *code_phase;  
    int *dataBit, *codeCA, *icode, *ibit, *iword;  
    int gain;  
    double f_carr, f_code, delt;  
    int *cosTable512, *sinTable512;  
    unsigned long *dwrd;  
    int *ca;  
    int iq_buff_size;  
    short *iq_buff;   
    if (nrhs != 16) {  
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nrhs", "16 input arguments required.");  
    }  
    if (nlhs != 8) {  
        mexErrMsgIdAndTxt("MyToolbox:arrayProduct:nlhs", "8 output argument required.");  
    }  
    carr_phase = mxGetPr(prhs[0]);
    code_phase = mxGetPr(prhs[1]);  
    dataBit = (int*)mxGetData(prhs[2]);  
    codeCA = (int*)mxGetData(prhs[3]);  
    icode = (int*)mxGetData(prhs[4]);  
    ibit = (int*)mxGetData(prhs[5]);  
    iword = (int*)mxGetData(prhs[6]);  
    gain = (int)mxGetScalar(prhs[7]);  
    f_carr = mxGetScalar(prhs[8]);  
    f_code = mxGetScalar(prhs[9]);  
    delt = mxGetScalar(prhs[10]);
    cosTable512 = (int*)mxGetData(prhs[11]);  
    sinTable512 = (int*)mxGetData(prhs[12]);  
    dwrd = (unsigned int*)mxGetData(prhs[13]);  
    ca = (int*)mxGetData(prhs[14]);  
    iq_buff_size = (int)mxGetScalar(prhs[15]);
    
//     printf("Debug:mxGetScalar: carr_phase is %f\n", *carr_phase);
//     printf("Debug:mxGetScalar: code_phase is %f\n", *code_phase);
//     printf("Debug:mxGetScalar: dataBit is %d\n", *dataBit);
//     printf("Debug:mxGetScalar: codeCA is %d\n", *codeCA);
//     printf("Debug:mxGetScalar: icode is %d\n", *icode);
//     printf("Debug:mxGetScalar: ibit is %d\n", *ibit);
//     printf("Debug:mxGetScalar: iword is %d\n", *iword);
//     printf("Debug:mxGetScalar: gain is %d\n", gain);
//     printf("Debug:mxGetScalar: f_carr is %f\n", f_carr);
//     printf("Debug:mxGetScalar: f_code is %f\n", f_code);
//     printf("Debug:mxGetScalar: delt is %.10f\n", delt);
//     printf("Debug:mxGetScalar: cosTable512[1] is %d\n", cosTable512[1]);

    
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);  
    double *carr_phase_out = mxGetPr(plhs[0]);  
    *carr_phase_out = *carr_phase;    
    plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);  
    double *code_phase_out = mxGetPr(plhs[1]);  
    *code_phase_out = *code_phase;
    plhs[2] = mxCreateNumericMatrix(1, 1, mxINT32_CLASS, 0);  
    int *dataBit_out = (int*)mxGetData(plhs[2]);  
    *dataBit_out = *dataBit;
    plhs[3] = mxCreateNumericMatrix(1, 1, mxINT32_CLASS, 0);  
    int *codeCA_out = (int*)mxGetData(plhs[3]);  
    *codeCA_out = *codeCA;
    plhs[4] = mxCreateNumericMatrix(1, 1, mxINT32_CLASS, 0);  
    int *icode_out = (int*)mxGetData(plhs[4]);  
    *icode_out = *icode;
    plhs[5] = mxCreateNumericMatrix(1, 1, mxINT32_CLASS, 0);  
    int *ibit_out = (int*)mxGetData(plhs[5]);  
    *ibit_out = *ibit;
    plhs[6] = mxCreateNumericMatrix(1, 1, mxINT32_CLASS, 0);  
    int *iword_out = (int*)mxGetData(plhs[6]);
    *iword_out = *iword;
    plhs[7] = mxCreateNumericMatrix(1, (mwSize)iq_buff_size*2, mxINT32_CLASS, 0);  
    iq_buff = (int*)mxGetData(plhs[7]);  
    process_iq_buffer(carr_phase_out, code_phase_out, dataBit_out, codeCA_out, icode_out, ibit_out, 
            iword_out, gain, f_carr, f_code, delt, cosTable512, sinTable512, dwrd, ca, iq_buff_size, iq_buff);
//     printf("Debug iword_out is %d\n", *iword_out);
}
