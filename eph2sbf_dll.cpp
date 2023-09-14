#include "mex.h"  
#include "gspsim.h"
#include <math.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
	// 检查输入参数数量  
	if (nrhs != 2) {
		mexErrMsgIdAndTxt("MyToolbox:add:nrhs", "Two input required.");
	}
	if (nlhs != 1) {
		mexErrMsgIdAndTxt("MyToolbox:add:nlhs", "One output required.");
	}

	//从matlab格式中获取C格式的输入变量
	ephem_t eph ;
	eph.vflg = (int)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 0));
	/*eph.t = (datetime_t)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 1));
	eph.toc = (gpstime_t)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 2));
	eph.toe = (gpstime_t)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 3));*/
	eph.iodc = (int)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 4));
	eph.iode = (int)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 5));
	eph.deltan = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 6));
	eph.cuc = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 7));
	eph.cus = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 8));
	eph.cic = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 9));
	eph.cis = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 10));
	eph.crc = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 11));
	eph.crs = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 12));
	eph.ecc = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 13));
	eph.sqrta = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 14));
	eph.m0 = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 15));
	eph.omg0 = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 16));
	eph.inc0 = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 17));
	eph.aop = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 18));
	eph.omgdot = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 19));
	eph.idot = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 20));
	eph.af0 = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 21));
	eph.af1 = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 22));
	eph.af2 = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 23));
	eph.tgd = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 24));
	eph.svhlth = (int)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 25));
	eph.codeL2 = (int)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 26));
	// Working variables follow  
	eph.n = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 27));
	eph.sq1e2 = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 28));
	eph.A = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 29));
	eph.omgkdot = (double)mxGetScalar(mxGetFieldByNumber(prhs[0], 0, 30));

	ionoutc_t ionoutc;// = *(ionoutc_t*)mxGetPr(prhs[1]);
	ionoutc.enable = (int)mxGetScalar(mxGetField(prhs[1], 0, "enable"));
	ionoutc.vflg = (int)mxGetScalar(mxGetField(prhs[1], 0, "vflg"));
	ionoutc.alpha0 = (double)mxGetScalar(mxGetField(prhs[1], 0, "alpha0"));
	ionoutc.alpha1 = (double)mxGetScalar(mxGetField(prhs[1], 0, "alpha1"));
	ionoutc.alpha2 = (double)mxGetScalar(mxGetField(prhs[1], 0, "alpha2"));
	ionoutc.alpha3 = (double)mxGetScalar(mxGetField(prhs[1], 0, "alpha3"));

	ionoutc.beta0 = (double)mxGetScalar(mxGetField(prhs[1], 0, "beta0"));
	ionoutc.beta1 = (double)mxGetScalar(mxGetField(prhs[1], 0, "beta1"));
	ionoutc.beta2 = (double)mxGetScalar(mxGetField(prhs[1], 0, "beta2"));
	ionoutc.beta3 = (double)mxGetScalar(mxGetField(prhs[1], 0, "beta3"));

	ionoutc.A0 = (double)mxGetScalar(mxGetField(prhs[1], 0, "A0"));
	ionoutc.A1 = (double)mxGetScalar(mxGetField(prhs[1], 0, "A1"));
	ionoutc.dtls = (int)mxGetScalar(mxGetField(prhs[1], 0, "dtls"));
	ionoutc.tot = (int)mxGetScalar(mxGetField(prhs[1], 0, "tot"));

	ionoutc.wnt = (int)mxGetScalar(mxGetField(prhs[1], 0, "wnt"));

	/*ionoutc.dtlsf = (int)mxGetScalar(mxGetFieldByNumber(prhs[1], 0, 15));
	ionoutc.dn = (int)mxGetScalar(mxGetFieldByNumber(prhs[1], 0, 16));
	ionoutc.wnlsf = (int)mxGetScalar(mxGetFieldByNumber(prhs[1], 0, 17));*/

	plhs[0] = mxCreateDoubleMatrix(5, N_DWRD_SBF, mxREAL);

	unsigned long *tmpMx = (unsigned long *)mxGetPr(plhs[0]);
	unsigned long sbf[5][N_DWRD_SBF];	
	unsigned long wn;
	unsigned long toe;
	unsigned long toc;
	unsigned long iode;
	unsigned long iodc;
	long deltan;
	long cuc;
	long cus;
	long cic;
	long cis;
	long crc;
	long crs;
	unsigned long ecc;
	unsigned long sqrta;
	long m0;
	long omg0;
	long inc0;
	long aop;
	long omgdot;
	long idot;
	long af0;
	long af1;
	long af2;
	long tgd;
	int svhlth;
	int codeL2;

	unsigned long ura = 0UL;
	unsigned long dataId = 1UL;
	unsigned long sbf4_page25_svId = 63UL;
	unsigned long sbf5_page25_svId = 51UL;

	unsigned long wna;
	unsigned long toa;

	signed long alpha0, alpha1, alpha2, alpha3;
	signed long beta0, beta1, beta2, beta3;
	signed long A0, A1;
	signed long dtls, dtlsf;
	unsigned long tot, wnt, wnlsf, dn;
	unsigned long sbf4_page18_svId = 56UL;

	// FIXED: This has to be the "transmission" week number, not for the ephemeris reference time
	//wn = (unsigned long)(eph.toe.week%1024);
	wn = 0UL;
	toe = (unsigned long)(eph.toe.sec / 16.0);
	toc = (unsigned long)(eph.toc.sec / 16.0);
	iode = (unsigned long)(eph.iode);
	iodc = (unsigned long)(eph.iodc);
	deltan = (long)(eph.deltan / POW2_M43 / PI);
	cuc = (long)(eph.cuc / POW2_M29);
	cus = (long)(eph.cus / POW2_M29);
	cic = (long)(eph.cic / POW2_M29);
	cis = (long)(eph.cis / POW2_M29);
	crc = (long)(eph.crc / POW2_M5);
	crs = (long)(eph.crs / POW2_M5);
	ecc = (unsigned long)(eph.ecc / POW2_M33);
	sqrta = (unsigned long)(eph.sqrta / POW2_M19);
	m0 = (long)(eph.m0 / POW2_M31 / PI);
	omg0 = (long)(eph.omg0 / POW2_M31 / PI);
	inc0 = (long)(eph.inc0 / POW2_M31 / PI);
	aop = (long)(eph.aop / POW2_M31 / PI);
	omgdot = (long)(eph.omgdot / POW2_M43 / PI);
	idot = (long)(eph.idot / POW2_M43 / PI);
	af0 = (long)(eph.af0 / POW2_M31);
	af1 = (long)(eph.af1 / POW2_M43);
	af2 = (long)(eph.af2 / POW2_M55);
	tgd = (long)(eph.tgd / POW2_M31);
	svhlth = (unsigned long)(eph.svhlth);
	codeL2 = (unsigned long)(eph.codeL2);

	wna = (unsigned long)(eph.toe.week % 256);
	toa = (unsigned long)(eph.toe.sec / 4096.0);

	alpha0 = (signed long)round(ionoutc.alpha0 / POW2_M30);
	alpha1 = (signed long)round(ionoutc.alpha1 / POW2_M27);
	alpha2 = (signed long)round(ionoutc.alpha2 / POW2_M24);
	alpha3 = (signed long)round(ionoutc.alpha3 / POW2_M24);
	beta0 = (signed long)round(ionoutc.beta0 / 2048.0);
	beta1 = (signed long)round(ionoutc.beta1 / 16384.0);
	beta2 = (signed long)round(ionoutc.beta2 / 65536.0);
	beta3 = (signed long)round(ionoutc.beta3 / 65536.0);
	A0 = (signed long)round(ionoutc.A0 / POW2_M30);
	A1 = (signed long)round(ionoutc.A1 / POW2_M50);
	dtls = (signed long)(ionoutc.dtls);
	tot = (unsigned long)(ionoutc.tot / 4096);
	wnt = (unsigned long)(ionoutc.wnt % 256);
	// TO DO: Specify scheduled leap seconds in command options
	// 2016/12/31 (Sat) -> WNlsf = 1929, DN = 7 (http://navigationservices.agi.com/GNSSWeb/)
	// Days are counted from 1 to 7 (Sunday is 1).
	wnlsf = 1929 % 256;
	dn = 7;
	dtlsf = 18;

	// Subframe 1
	sbf[0][0] = 0x8B0000UL << 6;
	sbf[0][1] = 0x1UL << 8;
	sbf[0][2] = ((wn & 0x3FFUL) << 20) | ((codeL2 & 0x3UL) << 18) | ((ura & 0xFUL) << 14) | ((svhlth & 0x3FUL) << 8) | (((iodc >> 8) & 0x3UL) << 6);
	sbf[0][3] = 0UL;
	sbf[0][4] = 0UL;
	sbf[0][5] = 0UL;
	sbf[0][6] = (tgd & 0xFFUL) << 6;
	sbf[0][7] = ((iodc & 0xFFUL) << 22) | ((toc & 0xFFFFUL) << 6);
	sbf[0][8] = ((af2 & 0xFFUL) << 22) | ((af1 & 0xFFFFUL) << 6);
	sbf[0][9] = (af0 & 0x3FFFFFUL) << 8;

	//Subframe 2
	sbf[1][0] = 0x8B0000UL << 6;
	sbf[1][1] = 0x2UL << 8;
	sbf[1][2] = ((iode & 0xFFUL) << 22) | ((crs & 0xFFFFUL) << 6);
	sbf[1][3] = ((deltan & 0xFFFFUL) << 14) | (((m0 >> 24) & 0xFFUL) << 6);
	sbf[1][4] = (m0 & 0xFFFFFFUL) << 6;
	sbf[1][5] = ((cuc & 0xFFFFUL) << 14) | (((ecc >> 24) & 0xFFUL) << 6);
	sbf[1][6] = (ecc & 0xFFFFFFUL) << 6;
	sbf[1][7] = ((cus & 0xFFFFUL) << 14) | (((sqrta >> 24) & 0xFFUL) << 6);
	sbf[1][8] = (sqrta & 0xFFFFFFUL) << 6;
	sbf[1][9] = (toe & 0xFFFFUL) << 14;

	//Subframe 3
	sbf[2][0] = 0x8B0000UL << 6;
	sbf[2][1] = 0x3UL << 8;
	sbf[2][2] = ((cic & 0xFFFFUL) << 14) | (((omg0 >> 24) & 0xFFUL) << 6);
	sbf[2][3] = (omg0 & 0xFFFFFFUL) << 6;
	sbf[2][4] = ((cis & 0xFFFFUL) << 14) | (((inc0 >> 24) & 0xFFUL) << 6);
	sbf[2][5] = (inc0 & 0xFFFFFFUL) << 6;
	sbf[2][6] = ((crc & 0xFFFFUL) << 14) | (((aop >> 24) & 0xFFUL) << 6);
	sbf[2][7] = (aop & 0xFFFFFFUL) << 6;
	sbf[2][8] = (omgdot & 0xFFFFFFUL) << 6;
	sbf[2][9] = ((iode & 0xFFUL) << 22) | ((idot & 0x3FFFUL) << 8);

	if (ionoutc.vflg == TRUE)
	{
		//Subframe 4, page 18
		sbf[3][0] = 0x8B0000UL << 6;
		sbf[3][1] = 0x4UL << 8;
		sbf[3][2] = (dataId << 28) | (sbf4_page18_svId << 22) | ((alpha0 & 0xFFUL) << 14) | ((alpha1 & 0xFFUL) << 6);
		sbf[3][3] = ((alpha2 & 0xFFUL) << 22) | ((alpha3 & 0xFFUL) << 14) | ((beta0 & 0xFFUL) << 6);
		sbf[3][4] = ((beta1 & 0xFFUL) << 22) | ((beta2 & 0xFFUL) << 14) | ((beta3 & 0xFFUL) << 6);
		sbf[3][5] = (A1 & 0xFFFFFFUL) << 6;
		sbf[3][6] = ((A0 >> 8) & 0xFFFFFFUL) << 6;
		sbf[3][7] = ((A0 & 0xFFUL) << 22) | ((tot & 0xFFUL) << 14) | ((wnt & 0xFFUL) << 6);
		sbf[3][8] = ((dtls & 0xFFUL) << 22) | ((wnlsf & 0xFFUL) << 14) | ((dn & 0xFFUL) << 6);
		sbf[3][9] = (dtlsf & 0xFFUL) << 22;

	}
	else
	{
		//Subframe 4, page 25
		sbf[3][0] = 0x8B0000UL << 6;
		sbf[3][1] = 0x4UL << 8;
		sbf[3][2] = (dataId << 28) | (sbf4_page25_svId << 22);
		sbf[3][3] = 0UL;
		sbf[3][4] = 0UL;
		sbf[3][5] = 0UL;
		sbf[3][6] = 0UL;
		sbf[3][7] = 0UL;
		sbf[3][8] = 0UL;
		sbf[3][9] = 0UL;

	}

	//Subframe 5, page 25
	sbf[4][0] = 0x8B0000UL << 6;
	sbf[4][1] = 0x5UL << 8;
	sbf[4][2] = (dataId << 28) | (sbf5_page25_svId << 22) | ((toa & 0xFFUL) << 14) | ((wna & 0xFFUL) << 6);
	sbf[4][3] = 0UL;
	sbf[4][4] = 0UL;
	sbf[4][5] = 0UL;
	sbf[4][6] = 0UL;
	sbf[4][7] = 0UL;
	sbf[4][8] = 0UL;
	sbf[4][9] = 0UL;

	for (mwIndex i = 0; i < 5; i++) {
		for (mwIndex j = 0; j < N_DWRD_SBF; j++) {
			tmpMx[i + j * 5] = sbf[i][j];
		}
	}

	// 释放内存  
	//mxDestroyArray(plhs[0]);
	return;
}
