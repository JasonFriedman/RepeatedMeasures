#define _WIN32_LEAN_AND_MEAN
#include "mex.h"
#include <windows.h>

#include <string>
#include <iostream>
#include "tchar.h"

#include "PDI.h"

using namespace std ;

CPDIg4		g_pdiDev;
//CPDImdat    g_pdiMDat;
CPDIser		g_pdiSer;
//DWORD		g_dwFrameSize;
BOOL		g_bCnxReady;
DWORD		g_dwStationMap;
DWORD		g_dwLastHostFrameCount;
TCHAR       g_G4CFilePath[_MAX_PATH+1];
#define DEFAULT_G4C_PATH _T("C:\\Polhemus\\G4 Files\\default.g4c")

#define BUFFER_SIZE 0x1FA400   // 30 seconds of xyzaer+fc 8 sensors at 240 hz
//BYTE	g_pMotionBuf[0x0800];  // 2K worth of data.  == 73 frames of XYZAER
BYTE	g_pMotionBuf[BUFFER_SIZE];

bool InitializeSystem();
bool ConnectToSystem();
bool SetupDevice();
void Disconnect();
bool readSingleSample(float currentData[]);
bool readSampleContinuous(float currentData[]);
bool ParseG4NativeFrame(PBYTE pBuf, DWORD dwSize, float currentData[]);
bool StartContinuousSampling();
bool StopContinuousSampling();
int GetFrameRate();
void UpdateStationMap();


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	//Check the number of received parameters to the Mex function
	if(nrhs < 1) {
		mexErrMsgTxt("There must be at least one argument. Run help G4Mex for usage\n");
		return;
	}

	int cmd = (unsigned int) mxGetScalar(prhs[0]);
	mxArray *arrayOutput = NULL;
	mxArray *singleoutput = NULL;
	double *outArray;
	float *currentData;
	int numMarkers;

    // Set to a default value
   	_tcsncpy_s(g_G4CFilePath, _countof(g_G4CFilePath), DEFAULT_G4C_PATH, _tcslen(DEFAULT_G4C_PATH));

	switch(cmd) {
		// Initialize the system
	case 0:
        {
        if(nrhs < 2) {
            mexErrMsgTxt("The second argument must specify the config file. Run help G4Mex for usage\n");
            return;
        }

       char* filepath = mxArrayToString(prhs[1]);
        
        
        DWORD dwAttrib = GetFileAttributes(filepath);
        if( dwAttrib==INVALID_FILE_ATTRIBUTES ) {
            mexPrintf("Config file: %s\n",filepath);
            mexErrMsgTxt("The specified config file does not exist\n");
        }
               
       	_tcsncpy_s(g_G4CFilePath, _countof(g_G4CFilePath), filepath, _tcslen(filepath));
        }

		InitializeSystem();
		ConnectToSystem();
		SetupDevice();		
		break;

		// Get a single sample (when not in continuous mode)
	case 1:
		if(nrhs < 2) {
			mexErrMsgTxt("The second argument must specify the number of markers. Run help G4Mex for usage\n");
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
		if(nrhs < 2) {
			mexErrMsgTxt("The second argument must specify the number of markers. Run help G4Mex for usage\n");
			return;
		}
		numMarkers = (unsigned int) mxGetScalar(prhs[1]);

		// sample size = num markers * 6 + 1
		currentData = new float[numMarkers*6+1];

		arrayOutput = mxCreateDoubleMatrix(1,numMarkers*6+1,mxREAL);
		plhs[0] = arrayOutput;
		outArray = mxGetPr(plhs[0]);

		bool success = readSampleContinuous(currentData);

		if (success) {
			for (int k=0;k<numMarkers*6+1;k++)
				outArray[k] = currentData[k];
		}
		else {
			for (int k=0;k<numMarkers*6+1;k++)
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
        
   default:
       mexErrMsgTxt("Unknown argument (first value must be between 0-6)");
       break;     
   }
}


bool InitializeSystem()
{
	bool retVal = true;

	g_pdiDev.Trace(true, 7);

	//g_pdiMDat.Empty();
	//g_pdiMDat.Append( PDI_MODATA_POS );
	//g_pdiMDat.Append( PDI_MODATA_ORI );
	//g_pdiMDat.Append( PDI_MODATA_FRAMECOUNT );
	//g_dwFrameSize = 8+12+12+4;

	g_bCnxReady = FALSE;
	g_dwStationMap =0;
//	g_dwStationMap = 5;
//	SetStationMap();

	return retVal;
}

bool ConnectToSystem()
{
    
	if (!(g_pdiDev.CnxReady()))
	{
		g_pdiDev.ConnectG4( g_G4CFilePath );

        mexPrintf("ConnectG4 using %s: %s\n",g_G4CFilePath,g_pdiDev.GetLastResultStr());

		g_bCnxReady = g_pdiDev.CnxReady();

	}
	else
	{
        mexPrintf("Already connected\n");
		g_bCnxReady = true;
	}

	if (g_bCnxReady==0) {
		mexErrMsgTxt("Can't connect to G4. Is it turned on? It may need to be reset\n");
	}

	return (g_bCnxReady>0);
}

bool SetupDevice()
{
	g_pdiDev.SetPnoBuffer( g_pMotionBuf, BUFFER_SIZE );
    mexPrintf("SetPnoBuffer\n");
	
	g_pdiDev.StartPipeExport();
    mexPrintf("StartPipeExport\n");
	
    UpdateStationMap();
    
	return true;
}

void UpdateStationMap() {
    g_pdiDev.GetStationMap( g_dwStationMap );
    mexPrintf("GetStationMap %x \n",g_dwStationMap );
}


bool readSingleSample(float currentData[]) {


	PBYTE pBuf;
	DWORD dwSize;
	

	if (g_dwStationMap==0) 	{
		UpdateStationMap();
	}

	if (!(g_pdiDev.ReadSinglePnoBufG4(pBuf, dwSize))) {
		mexPrintf("Error in reading a frame\n");
		return false;	
	}
	else 	{
		bool err=ParseG4NativeFrame( pBuf, dwSize,currentData );
		return err;

	}

}
 

bool readSampleContinuous(float currentData[]) {

	PBYTE pBuf;
	DWORD dwSize;
	DWORD dwFC;

/*	
	if (!(g_pdiDev.LastHostFrameCount( dwFC ))) {
		mexPrintf("Error in reading frame count during continuous recording type1\n");
	    return false;
	}
	else {
		if (dwFC == g_dwLastHostFrameCount) {
			// no new frames since last peek
			mexPrintf("No new data available type1\n");
			return false;
		}
		else {
			if (!(g_pdiDev.LastPnoPtr( pBuf, dwSize ))) {
				mexPrintf("Error in reading a frame during continuous recording\n");
				return false;
			}
			else 	{
				g_dwLastHostFrameCount = dwFC;
				bool err=ParseG4NativeFrame( pBuf, dwSize,currentData );
				return err;
			}
		}
	}  
*/	

  		if (!(g_pdiDev.LastPnoPtr( pBuf, dwSize ))) {
				mexPrintf("Error in reading a frame during continuous recording\n");
				return false;
			}
			else 	{
				bool err=ParseG4NativeFrame( pBuf, dwSize,currentData );
				return err;
			}

			
}


/////////////////////////////////////////////////////////////////////

bool ParseG4NativeFrame( PBYTE pBuf, DWORD dwSize, float currentData[] )
{
	if ((!pBuf) || (!dwSize))
	{
			mexPrintf("No data available\n");
		    return false;
	}
	else
	{
		DWORD i = 0;
		LPG4_HUBDATA	pHubFrame;
		int iHub = 0;

		while (i < dwSize)
		{
			pHubFrame = (LPG4_HUBDATA)(&pBuf[i]);

			i += sizeof(G4_HUBDATA);

			UINT	nHubID = pHubFrame->nHubID;
			UINT	nFrameNum = pHubFrame->nFrameCount;
			UINT	nSensorMap = pHubFrame->dwSensorMap;
			UINT	nDigIO = pHubFrame->dwDigIO;
			UINT	nSensMask = 1;

			currentData[0] = (float)nFrameNum;

			if (nHubID==0)
				iHub=0;
			else
				iHub=18;


			for (int j = 0; j < G4_MAX_SENSORS_PER_HUB; j++)
			{

				if (((nSensMask << j) & nSensorMap) != 0) {
					G4_SENSORDATA * pSD = &(pHubFrame->sd[j]);
					currentData[iHub + j * 6 + 1] = pSD->pos[0];
					currentData[iHub + j * 6 + 2] = pSD->pos[1];
					currentData[iHub + j * 6 + 3] = pSD->pos[2];
					currentData[iHub + j * 6 + 4] = pSD->ori[0];
					currentData[iHub + j * 6 + 5] = pSD->ori[1];
					currentData[iHub + j * 6 + 6] = pSD->ori[2];

				}
			} // end while dwsize
		
		}


	}

	return true;
}


void Disconnect()
{
	if (!(g_pdiDev.CnxReady()))
	{
        mexPrintf("Already disconnnected\n");
	}
	else
	{
		g_pdiDev.Disconnect();
        mexPrintf("Disconnect result: %s\n",g_pdiDev.GetLastResultStr());
	}
}

bool StartContinuousSampling() {

  //  if (g_dwStationMap==0)
        UpdateStationMap();
    
	g_pdiDev.ResetPnoPtr();
    g_pdiDev.ResetHostFrameCount();
    g_dwLastHostFrameCount = 0;
    
	if (!(g_pdiDev.StartContPnoG4(0))) {

		mexPrintf("Error in starting continuous sampling\n");
		return false;
	}

//	Sleep(500);  
	return true;

}

bool StopContinuousSampling() {

	if (!(g_pdiDev.StopContPno())) {
		mexPrintf("Error in stopping continuous sampling\n");
		return false;
	}

//  Sleep(500);  
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