#define _WIN32_LEAN_AND_MEAN
#include "mex.h"
#include <windows.h>

#include <string>
#include <iostream>
#include "tchar.h"

#include "PDI.h"

using namespace std ;

CPDIdev		g_pdiDev;
CPDImdat    g_pdiMDat;
CPDIser		g_pdiSer;
DWORD		g_dwFrameSize;
BOOL		g_bCnxReady;
DWORD		g_dwStationMap;

#define BUFFER_SIZE 0x1FA400   // 30 seconds of xyzaer+fc 8 sensors at 240 hz
//BYTE	g_pMotionBuf[0x0800];  // 2K worth of data.  == 73 frames of XYZAER
BYTE	g_pMotionBuf[BUFFER_SIZE];

bool InitializeSystem();
bool ConnectToSystem();
bool SetupDevice();
void Disconnect();
bool readSingleSample(float currentData[]);
bool readSampleContinuous(float currentData[],int numMarkers, int dataRequested);
bool StartContinuousSampling();
bool StopContinuousSampling();
int GetFrameRate();
bool SetBinary(bool useBinary);
bool SetMetric(bool useMetric);
bool SetHemisphere(int station,float x,float y,float z);
bool SetFrameRate(int frameRate);
bool ResetFrameCount();
bool SetOutputFormat(int station,int outputType);
bool ClearAlignmentFrame(int station);
bool SetAlignmentFrame(int station,float O1,float O2,float O3,float X1,float X2,float X3,float Y1,float Y2,float Y3);


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	//Check the number of received parameters to the Mex function
	if(nrhs < 1) {
		mexErrMsgTxt("There must be at least one argument. Run help LibertyMex for usage\n");
		return;
	}

	int cmd = (unsigned int) mxGetScalar(prhs[0]);
	mxArray *arrayOutput = NULL;
	mxArray *singleoutput = NULL;
	double *outArray;
	float *currentData;
	int numMarkers;


	switch(cmd) {
		// Initialize the system
	case 0:
		InitializeSystem();
		ConnectToSystem();
		SetupDevice();		
		break;

		// Get a single sample (when not in continuous mode)
	case 1:
		if(nrhs < 2) {
			mexErrMsgTxt("The second argument must specify the number of markers. Run help LibertyMex for usage\n");
			return;
		}
		numMarkers = (unsigned int) mxGetScalar(prhs[1]);
		// sample size = num markers * 6 + 1
		currentData = new float[numMarkers*6+1];

		arrayOutput = mxCreateDoubleMatrix(1,numMarkers*6+1,mxREAL);
		plhs[0] = arrayOutput;
		outArray = mxGetPr(plhs[0]);

		readSingleSample(currentData);

		for (int k=0;k<numMarkers*6+1;k++)
			outArray[k] = currentData[k];
		free(currentData);
		break;

		// Start continuous mode
	case 2:
		StartContinuousSampling();
		break;

		// Get a sample in continuous mode
	case 3: {
		if(nrhs < 3) {
			mexErrMsgTxt("The second argument must specify the number of markers and the third the data requested. Run help LibertyMex for usage\n");
			return;
		}
		numMarkers = (unsigned int) mxGetScalar(prhs[1]);
		int dataRequested = (unsigned int) mxGetScalar(prhs[2]); // 1=just position, 2 = position + orientation

		// sample size = num markers * 6 + 1
		currentData = new float[numMarkers*dataRequested*3+1];

		arrayOutput = mxCreateDoubleMatrix(1,numMarkers*dataRequested*3+1,mxREAL);
		plhs[0] = arrayOutput;
		outArray = mxGetPr(plhs[0]);

		bool success = readSampleContinuous(currentData,numMarkers,dataRequested);

		if (success) {
			for (int k=0;k<numMarkers*dataRequested*3+1;k++)
				outArray[k] = currentData[k];
		}
		else {
			for (int k=0;k<numMarkers*dataRequested*3+1;k++)
				outArray[k] = 0;
		}

		free(currentData);
		break;
			}

			// Stop sampling in continuous mode
	case 4:
		StopContinuousSampling();
		break;

		// Disconnect
	case 5:
		Disconnect();
		break;

		// Get the frame rate
	case 6:
		singleoutput = mxCreateDoubleMatrix(1,1, mxREAL);
		plhs[0] = singleoutput;
		*(mxGetPr(plhs[0])) = (double) GetFrameRate();
		break;

		// Set binary / ASCII
	case 7:
		{
			if(nrhs < 2) {
				mexErrMsgTxt("The second argument must specify whether to use binary (1) or ASCII (0). Run help LibertyMex for usage\n");
				return;
			}
			bool useASCII = (mxGetScalar(prhs[1])>0?true:false);
			SetBinary(useASCII);
			break;
		}

		// Set units (0=inches, 1 = cm)
	case 8:
		{
			if(nrhs < 2) {
				mexErrMsgTxt("The second argument must specify whether to use inches (0) or cm (1). Run help LibertyMex for usage\n");
				return;
			}
			bool units = (mxGetScalar(prhs[1])>0?true:false);
			SetMetric(units);
			break;
		}


		// Set hemisphere (station, x, y, z) xyz is a unit vector in the direction of the hemisphere
	case 9:
		{
			if(nrhs < 5) {
				mexErrMsgTxt("Requires 5 arguments. Run help LibertyMex for usage\n");
				return;
			}

			int station = (int) mxGetScalar(prhs[1]);
			float x = (float) mxGetScalar(prhs[2]);
			float y = (float) mxGetScalar(prhs[3]);
			float z = (float) mxGetScalar(prhs[4]);

			SetHemisphere(station,x,y,z);
			break;
		}
		// Set the frame rate
	case 10:
		{
			if(nrhs < 2) {
				mexErrMsgTxt("The second argument must be the frame rate (60 or 120 or 240). Run help LibertyMex for usage\n");
				return;
			}
			int frameRate = (int) mxGetScalar(prhs[1]);
			SetFrameRate(frameRate);
			break;
		}

		// Reset the frame counter
	case 11:
		ResetFrameCount();
		break;

		// Set the output type
	case 12:
		{
			if(nrhs < 3) {
				mexErrMsgTxt("Requires 3 arguments. Run help LibertyMex for usage\n");
				return;
			}

			int station = (int) mxGetScalar(prhs[1]);
			int outputType = (int) mxGetScalar(prhs[2]);
			SetOutputFormat(station,outputType);
			break;
		}

	case 13:
		{
			if(nrhs < 2) {
				mexErrMsgTxt("Requires 2 arguments, the second must be the station number. Run help LibertyMex for usage\n");
				return;
			}

			int station = (int) mxGetScalar(prhs[1]);
			ClearAlignmentFrame(station);
			break;
		}
	case 14:
		{
			if(nrhs < 11) {
				mexErrMsgTxt("Requires 11 arguments. Run help LibertyMex for usage\n");
				return;
			}

			int station = (int) mxGetScalar(prhs[1]);
			float O1 = (float) mxGetScalar(prhs[2]);
			float O2 = (float) mxGetScalar(prhs[3]);
			float O3 = (float) mxGetScalar(prhs[4]);
			float X1 = (float) mxGetScalar(prhs[5]);
			float X2 = (float) mxGetScalar(prhs[6]);
			float X3 = (float) mxGetScalar(prhs[7]);
			float Y1 = (float) mxGetScalar(prhs[8]);
			float Y2 = (float) mxGetScalar(prhs[9]);
			float Y3 = (float) mxGetScalar(prhs[10]);

			SetAlignmentFrame(station,O1,O2,O3,X1,X2,X3,Y1,Y2,Y3);
			break;
		}
	}

}


bool InitializeSystem()
{
	bool retVal = true;

	g_pdiDev.Trace(true, 7);

	g_pdiMDat.Empty();
	g_pdiMDat.Append( PDI_MODATA_POS );
	g_pdiMDat.Append( PDI_MODATA_ORI );
	g_pdiMDat.Append( PDI_MODATA_FRAMECOUNT );
	g_dwFrameSize = 8+12+12+4;

	g_bCnxReady = FALSE;
	g_dwStationMap = 0;

	return retVal;
}

bool ConnectToSystem( )
{
	if (!(g_pdiDev.CnxReady()))
	{
		g_pdiDev.SetSerialIF( &g_pdiSer );

		ePiCommType eType = g_pdiDev.DiscoverCnx();
		switch (eType)
		{
		case PI_CNX_USB:
			cout << "USB Connection: ";
			break;
		case PI_CNX_SERIAL:
			cout << "Serial Connection: ";
			break;
		default:
			cout << "DiscoverCnx result: ";
			break;
		}
		cout << g_pdiDev.GetLastResultStr() << endl;
		g_bCnxReady = g_pdiDev.CnxReady();

	}
	else
	{
		cout << "Already connected" << endl;
		g_bCnxReady = true;
	}

	if (g_bCnxReady==0) {
		mexErrMsgTxt("Can't connect to Liberty. Is it turned on? It may need to be reset\n");
	}

	return (g_bCnxReady>0);
}

bool SetupDevice()
{
	g_pdiDev.SetPnoBuffer( g_pMotionBuf, BUFFER_SIZE );
	cout << "SetPnoBuffer" << endl;

	g_pdiDev.StartPipeExport();
	cout << "StartPipeExport" << endl;

	g_pdiDev.SetSDataList( -1, g_pdiMDat );
	cout << "SetSDataList" << endl;

	CPDIbiterr cBE;
	g_pdiDev.GetBITErrs( cBE );
	cout << "GetBITErrs" << endl;

	if (!(cBE.IsClear()))
	{
		g_pdiDev.ClearBITErrs();
		cout << "ClearBITErrs" << endl;
	}

	return true;
}


bool readSingleSample(float currentData[]) {

	PBYTE pBuf;
	DWORD dwSize;
	int sampleSize = 6;

	if (!(g_pdiDev.ReadSinglePnoBuf(pBuf, dwSize)))
	{
		mexPrintf("Error in reading a frame\n");
		return false;
	}
	DWORD i =0;

	while (i<dwSize)
	{
		BYTE sensorNum = pBuf[i+2];
		SHORT shSize = pBuf[i+6];

		// skip rest of header
		i += 8;

		PFLOAT pPno = (PFLOAT)(&pBuf[i]);
		for (int k=0;k<sampleSize;k++) {
			currentData[(sensorNum-1)*sampleSize+k+1] = pPno[k];
		}
		PDWORD pFrameCount  = (PDWORD)(&pBuf[i+sampleSize*4]);
		currentData[0] =  (float) *pFrameCount;

		i += shSize;
	}
	return true;
}

bool readSampleContinuous(float currentData[],int numMarkers,int dataRequested) {

	PBYTE pBuf;
	DWORD dwSize;
	int sampleSize;

	if (dataRequested==1)
		sampleSize = 3;
	else
		sampleSize = 6;

	if (!(g_pdiDev.LastPnoPtr(pBuf, dwSize)))
	{
		mexPrintf("Error in reading a frame during continuous recording\n");
		return false;
	}

	// no data ready
	if (dwSize==0) {
		mexPrintf("No data available\n");
		return false;
	}

	// per sensor = 8(header) + 3 * 4 + 4 (timestamp) + 2 (CR/LF) = 16  [just position]
	//              8(header) + 6 * 4 + 4 (timestamp) + 2 (CR/LF) = 38  [position + orientation]

	int expectedSize = numMarkers * (8 + sampleSize * 4 + 4 + 2);
	// no data ready
	if (dwSize!=expectedSize) {
		mexPrintf("Data is not the expected size (%d when should be %d)\n",dwSize,expectedSize);
		return false;
	} 

	DWORD i =0;

	while (i<dwSize)
	{
		BYTE sensorNum = pBuf[i+2];
		SHORT shSize = pBuf[i+6];

		// skip rest of header
		i += 8;

		PFLOAT pPno = (PFLOAT)(&pBuf[i]);
		for (int k=0;k<sampleSize;k++) {
			currentData[(sensorNum-1)*sampleSize+k+1] = pPno[k];
		}
		// Read the frame number
		PDWORD pFrameCount  = (PDWORD)(&pBuf[i+sampleSize*4]);
		currentData[0] =  (float) *pFrameCount;
		
		i += shSize;
	}
	return true;
}

void Disconnect()
{
	if (!(g_pdiDev.CnxReady()))
	{
		cout << "Already disconnected\n";
	}
	else
	{
		g_pdiDev.Disconnect();
		cout << "Disconnect result: " + string(g_pdiDev.GetLastResultStr()) + "\r\n";
	}
}

bool StartContinuousSampling() {

	if (!(g_pdiDev.StartContPno(0))) {
		mexPrintf("Error in starting continuous sampling\n");
		return false;
	}
	return true;

}

bool StopContinuousSampling() {

	if (!(g_pdiDev.StopContPno())) {
		mexPrintf("Error in stopping continuous sampling\n");
		return false;
	}
	return true;

}

int GetFrameRate() {
	ePiFrameRate eRate;

	g_pdiDev.GetFrameRate(eRate);

	if (eRate==PI_FRATE_60)
		return 60;
	else if(eRate==PI_FRATE_120)
		return 120;
	else if(eRate==PI_FRATE_240)
		return 240;
	else
		return -1;
}

bool SetBinary(bool useBinary) {
	return (g_pdiDev.SetBinary(useBinary)>0);
}

bool SetMetric(bool useBinary) {
	return (g_pdiDev.SetMetric(useBinary)>0);
}

bool SetHemisphere(int station,float x,float y,float z) {
	PDI3vec hemisphereVec = {x,y,z};

	return (g_pdiDev.SetSHemisphere ( station, hemisphereVec)>0);
}

bool SetFrameRate(int frameRate) {
	ePiFrameRate eRate;

	if (frameRate==60)
		eRate=PI_FRATE_60;
	else if(frameRate==120)
		eRate=PI_FRATE_120;
	else if(frameRate==240)
		eRate=PI_FRATE_240;
	else
		mexPrintf("Error in setting frame rate: unknown value %d\n",frameRate);

	return (g_pdiDev.SetFrameRate(eRate)>0);
}

bool ResetFrameCount() {
	return (g_pdiDev.ResetFrameCount()>0);
}

// outputType = 1 -> just position (+ framenumber), = 2 -> position and orientation (+framenumber)
bool SetOutputFormat(int station,int outputType) {
	CPDImdat m_pdiMDat;
	m_pdiMDat.Empty();
	m_pdiMDat.Append( PDI_MODATA_POS );
	if (outputType==2) {
		m_pdiMDat.Append( PDI_MODATA_ORI );
	}
	m_pdiMDat.Append( PDI_MODATA_FRAMECOUNT);
	m_pdiMDat.Append( PDI_MODATA_CRLF );

	return(g_pdiDev.SetSDataList (station, m_pdiMDat)>0);
}

bool ClearAlignmentFrame(int station) {
	return(g_pdiDev.ResetSAlignment (station)>0);
}

bool SetAlignmentFrame(int station,float O1,float O2,float O3,float X1,float X2,float X3,float Y1,float Y2,float Y3) {
	PDI3vec O = {O1,O2,O3};
	PDI3vec X = {X1,X2,X3};
	PDI3vec Y = {Y1,Y2,Y3};

	return(g_pdiDev.SetSAlignment(station,O,X,Y)>0);
}