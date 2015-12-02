#include "mex.h"
#include <cbw.h>

// Local functions
float readSingleSample(int boardNum,int channel,int gain);
void readSample(int boardNum,int minChannel,int maxChannel,int gain,float* values);
void writeDigital(int boardNum, int channels, unsigned short DataValue);

// Global variables
static HANDLE bufferHandle = NULL;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if (nrhs < 1)
        mexErrMsgTxt("Must provide at least one parameter. Type help MCDAQMex for options");
    else {
        unsigned int cmd = (unsigned int) mxGetScalar(prhs[0]);
        int UDStat;
        float RevLevel = (float)CURRENTREVNUM;
        
        
        switch((unsigned int) cmd) {
            // Setup
            case 0:
            {
                if (nrhs<2)
                    mexErrMsgTxt("Must provide 2 arguments for just analog input (0,numChannelTotal) or 3 arguments for analog input and digital output (0,numChannelTotal,digitalOutputPort)");
                int numChannelsTotal = (unsigned int) mxGetScalar(prhs[1]);

                /* Declare UL Revision Level */
                UDStat = cbDeclareRevision(&RevLevel);
                // Initiate error handling
                cbErrHandling (PRINTALL, DONTSTOP);
                // Declare that we are using single or differential input
                int boardNum = 0;
                cbSetConfig(BOARDINFO, boardNum, 0, BINUMADCHANS, numChannelsTotal);
                
                // Allocate some memory (we allocate 1000)
                bufferHandle = cbWinBufAlloc(1000);
                
                if (nrhs==3) {
                  int channels = (unsigned int) mxGetScalar(prhs[2]);
                  cbDConfigPort(boardNum,channels,DIGITALOUT);
                }                        
            }
            break;
            // Read a single analog channel
            case 1:
            {
                if (nrhs<4)
                    mexErrMsgTxt("Must provide 4 arguments (1,boardNum,channel,gain)");
                
                if (bufferHandle==NULL)
                    mexErrMsgTxt("Must initialize before using: MCDAQMex(0);");
                
                int boardNum = (unsigned int) mxGetScalar(prhs[1]);
                int channel = (unsigned int) mxGetScalar(prhs[2]);
                int gain = (unsigned int) mxGetScalar(prhs[3]);
                float value = readSingleSample(boardNum,channel,gain);
                int dims[2]; dims[0]=1;dims[1]=1;
                mxArray* output = mxCreateNumericArray(2,dims,mxSINGLE_CLASS,mxREAL);
                plhs[0] = output;
                float* outArray = (float*)mxGetData(plhs[0]);
                outArray[0] = value;
            }
            break;
            // Read analog inputs (multiple channels)
            case 2:
            {
                if (nrhs<5)
                    mexErrMsgTxt("Must provide 5 arguments (2,boardNum,minChannel,maxChannel,gain)");
                
                if (bufferHandle==NULL)
                    mexErrMsgTxt("Must initialize before using: MCDAQMex(0);");
                
                int boardNum = (unsigned int) mxGetScalar(prhs[1]);
                int minChannel = (unsigned int) mxGetScalar(prhs[2]);
                int maxChannel = (unsigned int) mxGetScalar(prhs[3]);
                int gain = (unsigned int) mxGetScalar(prhs[4]);
                
                int dims[2];dims[0] = 1;dims[1] = maxChannel-minChannel+1;
                
                mxArray* output = mxCreateNumericArray(2,dims,mxSINGLE_CLASS,mxREAL);
                plhs[0] = output;
                float* outArray = (float*)mxGetData(plhs[0]);
                readSample(boardNum,minChannel,maxChannel,gain,outArray);
            }
            break;
            // Write to digital output
            case 3:
            {
                if (nrhs<4)
                    mexErrMsgTxt("Must provide 4 arguments (3,boardNum,channels,value)");
                if (bufferHandle==NULL)
                    mexErrMsgTxt("Must initialize before using: MCDAQMex(0);");
                int boardNum = (unsigned int) mxGetScalar(prhs[1]);
                int channels = (unsigned int) mxGetScalar(prhs[2]);
                unsigned short dataValue = (unsigned short) mxGetScalar(prhs[3]);
                writeDigital(boardNum,channels,dataValue);
            }
            break;
            default:
                mexErrMsgTxt("Unknown parameter. Type help MCDAQMex for valid options");
        }
    }
    
}

// read a single sample from a single channel and return it
float readSingleSample(int boardNum,int channel,int gain) {
    int UDStat;
    WORD dataValue = 0;
    float EngUnits;
    UDStat = cbAIn (boardNum, channel, gain, &dataValue);
    UDStat = cbToEngUnits (boardNum, gain, dataValue, &EngUnits);
    //printf("Raw value is %d, voltage is %.6f\n",dataValue,EngUnits);
    return EngUnits;
}

// read samples from channels minChannel to maxChannel, and put the results in the array "result"
void readSample(int boardNum,int minChannel,int maxChannel,int gain,float* result) {
    long rate = 1000; // Not really important because we only take one sample
    long count = maxChannel-minChannel+1;
    unsigned int options = CONVERTDATA;
    int UDStat = cbAInScan(boardNum, minChannel, maxChannel, count, &rate, gain, bufferHandle, options);
    WORD* data = (WORD*) bufferHandle;
    WORD dataValue = 0;
    
    for (int channel=minChannel;channel<=maxChannel;channel++) {
        UDStat = cbToEngUnits (boardNum, gain, data[channel-minChannel], &result[channel-minChannel]);
        //printf("Raw value is %d, Voltage is %.6f\n",data[channel-minChannel],result[channel-minChannel]);
    }
}

// We use the above version because it is slightly faster
/*
void readSample(int boardNum, int minChannel, int maxChannel, int gain, float* result) {
    for (int channel=minChannel;channel<=maxChannel;channel++) {
        result[channel-minChannel] = readSingleSample(boardNum,channel,gain);
        
    } 
}
*/

// Write to the digital outputs
void writeDigital(int boardNum, int channels, unsigned short dataValue) {   
    int UDStat = cbDOut(boardNum,channels,dataValue);
}
