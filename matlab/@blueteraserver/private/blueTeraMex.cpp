#define _WIN32_LEAN_AND_MEAN
#include "mex.h"
#include <string.h> // for stricmp
#include <windows.h> // for Sleep
#include <IotEraSDK.h>

// Change this if you want to use more than 6 sensors
// (will also need to define more OnAccelerationDataX and onQuaternionDataX functions,
// and update these in connectToSensors)
#define MAXSENSORS 6 

char addresses[MAXSENSORS][18];
char discoveredAddresses[MAXSENSORS][18];
int discovered = 0;
mwSize numSensors = 0;

double quaternions[MAXSENSORS][4];
double accelerations[MAXSENSORS][3];
double accelerationUpdateTime[MAXSENSORS];
double quaternionUpdateTime[MAXSENSORS];
int state[MAXSENSORS];

void initialize();
void shutdown();
void disconnectFromSensor(const char* address);
void connectToSensors(const mxArray* details);
int identifySensor(const char* address);
void OnDiscovered(const char* address); 
void OnConnected(const char* address);
void OnDisconnected(const char* address);
void OnAccelerationData(int sensorNumber, uint32_t timestamp, const float* acceleration);
void OnQuaternionData(int sensorNumber, uint32_t timestamp, const float* quaternion);

// The callback does not include the current sensor, so this is a workaround
void OnAccelerationData0(uint32_t timestamp, const float* acceleration) {OnAccelerationData(0,timestamp,acceleration);}
void OnAccelerationData1(uint32_t timestamp, const float* acceleration) {OnAccelerationData(1,timestamp,acceleration);}
void OnAccelerationData2(uint32_t timestamp, const float* acceleration) {OnAccelerationData(2,timestamp,acceleration);}
void OnAccelerationData3(uint32_t timestamp, const float* acceleration) {OnAccelerationData(3,timestamp,acceleration);}
void OnAccelerationData4(uint32_t timestamp, const float* acceleration) {OnAccelerationData(4,timestamp,acceleration);}
void OnAccelerationData5(uint32_t timestamp, const float* acceleration) {OnAccelerationData(5,timestamp,acceleration);}
void OnQuaternionData0(uint32_t timestamp, const float* quaternion) {OnQuaternionData(0,timestamp,quaternion);}
void OnQuaternionData1(uint32_t timestamp, const float* quaternion) {OnQuaternionData(1,timestamp,quaternion);}
void OnQuaternionData2(uint32_t timestamp, const float* quaternion) {OnQuaternionData(2,timestamp,quaternion);}
void OnQuaternionData3(uint32_t timestamp, const float* quaternion) {OnQuaternionData(3,timestamp,quaternion);}
void OnQuaternionData4(uint32_t timestamp, const float* quaternion) {OnQuaternionData(4,timestamp,quaternion);}
void OnQuaternionData5(uint32_t timestamp, const float* quaternion) {OnQuaternionData(5,timestamp,quaternion);}

inline mwSize sub2ind(mwSize irow, mwSize icol, mwSize numRows) { return irow + icol*numRows; }

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // If mex file is unloaded, do the shutdown (to free the bluetooth and release the memory)
    mexAtExit(shutdown);
    //Check the number of received parameters to the Mex function
    if(nrhs < 1) {
        mexErrMsgTxt("There must be at least one argument. Run help blueTeraMex for usage\n");
        return;
    }
    
    int cmd = (unsigned int) mxGetScalar(prhs[0]);
    mxArray *arrayOutput = NULL;
    mxArray *singleoutput = NULL;
    double *outArray;

    switch(cmd) {
        // Initialize the system
        case 0:
            initialize();
            break;
        // Connect to the sensors(s)
        case 1:
            if(nrhs < 2) {
                mexErrMsgTxt("The second argument must be a cell array with the hardware addresses of the sensors to connect to. Run help blueTeraMex for usage\n");
                return;
            }
            connectToSensors(prhs[1]);
            break;
        // Return number of sensors and their states
        case 2:
            singleoutput = mxCreateDoubleMatrix(1,1, mxREAL);
            plhs[0] = singleoutput;
            *(mxGetPr(plhs[0])) = (double) numSensors;
            arrayOutput = mxCreateDoubleMatrix(1,numSensors,mxREAL);
            plhs[1] = arrayOutput;
            outArray = mxGetPr(plhs[1]);
            for (mwSize i=0;i<numSensors;i++) {
                outArray[i] = state[i];
            }
            break;
        // Return the data
        case 3:
            // cols = 4 quaternions + 3 acceleration + 2 * time stamps
            arrayOutput = mxCreateDoubleMatrix(numSensors,9,mxREAL);
            plhs[0] = arrayOutput;
            outArray = mxGetPr(plhs[0]);            
            
            for (mwSize i=0;i<numSensors;i++) {
                // Matlab arrays are 1D, so need to find the right index
                outArray[sub2ind(i,0,numSensors)] = quaternions[i][0];
                outArray[sub2ind(i,1,numSensors)] = quaternions[i][1];
                outArray[sub2ind(i,2,numSensors)] = quaternions[i][2];
                outArray[sub2ind(i,3,numSensors)] = quaternions[i][3];
                outArray[sub2ind(i,4,numSensors)] = accelerations[i][0];
                outArray[sub2ind(i,5,numSensors)] = accelerations[i][1];
                outArray[sub2ind(i,6,numSensors)] = accelerations[i][2];
                outArray[sub2ind(i,7,numSensors)] = quaternionUpdateTime[i];
                outArray[sub2ind(i,8,numSensors)] = accelerationUpdateTime[i];
            }
            break;
        case 4:
            shutdown();
            break;
        // Scan for devices
        case 5:
        {int scantime = 10;
            
            if(nrhs >= 2) {
                scantime = (int)*mxGetPr(prhs[1]);
            }            
            IOTE_StartScan(true); // only scan for blueTera devices
            
            mexPrintf("Scanning, please wait %d seconds. . .\n",scantime);
            // Needed to print the string now
            mexEvalString("drawnow;");
            Sleep(scantime*1000);
            IOTE_StopScan();
            mexPrintf("Discovered %d sensor(s)\n",discovered);
            for(int k=0;k<discovered;k++) {
                mexPrintf("Sensor %d: %s\n",k,discoveredAddresses[k]);
            }
            // Return the values in a cell array
            mxArray *cell_array = mxCreateCellMatrix((mwSize)discovered,1);
            for(int k=0; k<discovered; k++){               
                mxSetCell(cell_array,k,mxCreateString(discoveredAddresses[k]));                
            }
            
            plhs[0] = cell_array;            
            break;
        }
    }
    
}

void initialize() {
    // Before calling any other functions we need to initialize it:
	int statusCode = IOTE_Initialize();
        
    if(statusCode != STATUS_SUCCESS) {
        mexErrMsgTxt("Error, could not connect to bluetooth\n");
    }   
    mexPrintf("Initialize bluetooth connection to blueTera\n");
    
    IOTE_SetOnDeviceDiscovered(OnDiscovered);
    IOTE_SetOnDeviceConnected(OnConnected);
    IOTE_SetOnDeviceDisconnected(OnDisconnected);
}

void shutdown() {
    // Although IOTE_Terminate is supposed to disconnect, it doesn't seem to do it
    for (int i=0;i<numSensors;i++) {
        disconnectFromSensor(addresses[i]);
    }
    // Give it some time to disconnect
    Sleep(2000);
    
    IOTE_Terminate();
    mexPrintf("Terminated blueTera connection\n");
    numSensors = 0;
}

void disconnectFromSensor(const char* address) {
    IOTE_Disconnect(address);
}

void connectToSensors(const mxArray* details) {
    const mxArray* cellPtr;
    mwSize strlength, numChars;
    int status;
    
    // Check input is really a cell array
    if (!mxIsCell(details))
        mexErrMsgTxt("The second argument must be a cell array\n");
    
    numSensors = (mwSize)mxGetNumberOfElements(details);
        
    for(mwIndex i=0;i<numSensors;i++){
        state[i] = 5;
        cellPtr = mxGetCell(details,i);
        numChars = (mwSize)mxGetN(cellPtr); // This is the number of characters
        if (numChars!=17) {
            mexErrMsgTxt("Each hardware address in the cell array must have a length of exactly 17");
            return;
        }
        
        strlength = (mwSize)mxGetN(cellPtr)*sizeof(mxChar)+1; 
        // Note: use the upper case version of the string (prevents crashing)
        //_strupr(addresses[i]);
        
        status = mxGetString(cellPtr,addresses[i],strlength);
    }
        
    // Connect to the first sensor
    int result = IOTE_Connect(addresses[0]);    
}

// When discovered, add it to the list, and increment the counter
void OnDiscovered(const char* address) {
    // Check we don't already know about it - if so return without adding it
    for(int k=0;k<discovered;k++) {
        if (_stricmp(discoveredAddresses[k],address)==0)
                return;
    }
    strcpy(discoveredAddresses[discovered++],address);
}

int identifySensor(const char* address) {
    int sensorNumber = -1;
    for (int i=0;i<numSensors;i++) {
        if (_stricmp(addresses[i],address)==0) { // Case invariant!
           sensorNumber = i;
           break;
        }
    }
    return sensorNumber;
    
}

// When connected, enable data streaming
void OnConnected(const char* address) {
    
    int sensorNumber=identifySensor(address);
    switch(sensorNumber) {
        case 0:
            IOTE_SetOnQuatData(address,OnQuaternionData0);
            IOTE_SetOnAccData(address,OnAccelerationData0);
            break;
        case 1:
            IOTE_SetOnQuatData(address,OnQuaternionData1);
            IOTE_SetOnAccData(address,OnAccelerationData1);
            break;
        case 2:
            IOTE_SetOnQuatData(address,OnQuaternionData2);
            IOTE_SetOnAccData(address,OnAccelerationData2);
            break;
        case 3:
            IOTE_SetOnQuatData(address,OnQuaternionData3);
            IOTE_SetOnAccData(address,OnAccelerationData3);
            break;
        case 4:
            IOTE_SetOnQuatData(address,OnQuaternionData4);
            IOTE_SetOnAccData(address,OnAccelerationData4);
            break;
        case 5:
            IOTE_SetOnQuatData(address,OnQuaternionData5);
            IOTE_SetOnAccData(address,OnAccelerationData5);
            break;
    }
    IOTE_EnableQuatData(address, true);
    IOTE_EnableAccData(address, true);
    
    // Mark sensor as connected
    state[sensorNumber] = 0;
    
    if (numSensors>sensorNumber+1)
        IOTE_Connect(addresses[sensorNumber+1]);
}

// Mark sensors as disconnected
void OnDisconnected(const char* address) {
    int sensorNumber=identifySensor(address);
    state[sensorNumber] = 2;
}

// Copy the new data into the array
void OnAccelerationData(int sensorNumber, uint32_t timestamp, const float* acceleration)
{
    // Copy the accleration data into the array    
    accelerations[sensorNumber][0] = acceleration[0];
    accelerations[sensorNumber][1] = acceleration[1];
    accelerations[sensorNumber][2] = acceleration[2];
    accelerationUpdateTime[sensorNumber] = timestamp;            
}

void OnQuaternionData(int sensorNumber, uint32_t timestamp, const float* quaternion)
{
    // Copy the quaternion data into the array   
    quaternions[sensorNumber][0] = quaternion[0];
    quaternions[sensorNumber][1] = quaternion[1];
    quaternions[sensorNumber][2] = quaternion[2];
    quaternions[sensorNumber][3] = quaternion[3];
    quaternionUpdateTime[sensorNumber] = timestamp;
}