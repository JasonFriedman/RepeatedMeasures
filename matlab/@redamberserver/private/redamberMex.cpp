#define _WIN32_LEAN_AND_MEAN
#include "mex.h"
#include <time.h>
#include <GemSDK.h>

// Change this if you want to use more than 6 gems
// (will also need to define more OnStateChangedX, OnCombinedDataX functions,
// and update these in connectToGems)
#define MAXGEMS 6 

GemHandle gemHandles[MAXGEMS];
mwSize numGems = 0;

double quaternions[MAXGEMS][4];
double accelerations[MAXGEMS][3];
double updateTime[MAXGEMS];
int gemState[MAXGEMS];

void initialize();
void shutdown();
void connectToGems(const mxArray* details);
void OnStateChanged(int gemNumber, GemState state);
void OnCombinedData(int gemNumber, const float* quaternion, const float* acceleration);
// The callback does not include the current gem, so this is a workaround
void OnStateChanged0(GemState state) {OnStateChanged(0,state);}
void OnStateChanged1(GemState state) {OnStateChanged(1,state);}
void OnStateChanged2(GemState state) {OnStateChanged(2,state);}
void OnStateChanged3(GemState state) {OnStateChanged(3,state);}
void OnStateChanged4(GemState state) {OnStateChanged(4,state);}
void OnStateChanged5(GemState state) {OnStateChanged(5,state);}
void OnCombinedData0(const float* quaternion, const float* acceleration) {OnCombinedData(0,quaternion,acceleration);}
void OnCombinedData1(const float* quaternion, const float* acceleration) {OnCombinedData(1,quaternion,acceleration);}
void OnCombinedData2(const float* quaternion, const float* acceleration) {OnCombinedData(2,quaternion,acceleration);}
void OnCombinedData3(const float* quaternion, const float* acceleration) {OnCombinedData(3,quaternion,acceleration);}
void OnCombinedData4(const float* quaternion, const float* acceleration) {OnCombinedData(4,quaternion,acceleration);}
void OnCombinedData5(const float* quaternion, const float* acceleration) {OnCombinedData(5,quaternion,acceleration);}

inline mwSize sub2ind(mwSize irow, mwSize icol, mwSize numRows) { return irow + icol*numRows; }

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // If mex file is unloaded, do the shutdown (to free the bluetooth and release the memory)
    mexAtExit(shutdown);
    //Check the number of received parameters to the Mex function
    if(nrhs < 1) {
        mexErrMsgTxt("There must be at least one argument. Run help redamberMex for usage\n");
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
        // Connect to the gem(s)
        case 1:
            if(nrhs < 2) {
                mexErrMsgTxt("The second argument must be a cell array with the hardware addresses of the Gems to connec to. Run help redamberMexz for usage\n");
                return;
            }
            connectToGems(prhs[1]);
            break;
        // Return number of gems and their states
        case 2:
            singleoutput = mxCreateDoubleMatrix(1,1, mxREAL);
            plhs[0] = singleoutput;
            *(mxGetPr(plhs[0])) = (double) numGems;
            arrayOutput = mxCreateDoubleMatrix(1,numGems,mxREAL);
            plhs[1] = arrayOutput;
            outArray = mxGetPr(plhs[1]);
            for (mwSize i=0;i<numGems;i++) {
                outArray[i] = gemState[i];
            }
            break;
        // Return the data
        case 3:
            // cols = 4 quaternions + 3 acceleration + time stamp
            arrayOutput = mxCreateDoubleMatrix(numGems,8,mxREAL);
            plhs[0] = arrayOutput;
            outArray = mxGetPr(plhs[0]);

            for (mwSize i=0;i<numGems;i++) {
                // Matlab arrays are 1D, so need to find the right index
                outArray[sub2ind(i,0,numGems)] = quaternions[i][0];
                outArray[sub2ind(i,1,numGems)] = quaternions[i][1];
                outArray[sub2ind(i,2,numGems)] = quaternions[i][2];
                outArray[sub2ind(i,3,numGems)] = quaternions[i][3];
                outArray[sub2ind(i,4,numGems)] = accelerations[i][0];
                outArray[sub2ind(i,5,numGems)] = accelerations[i][1];
                outArray[sub2ind(i,6,numGems)] = accelerations[i][2];
                outArray[sub2ind(i,7,numGems)] = updateTime[i];
            }
            break;
        case 4:
            shutdown();
            break;
    }
    
}

void initialize() {
    // Before calling any other functions in the GemSDK we need to initialize it:
    GemStatusCode err = Gem_Initialize();
    
    if(err != GEM_SUCCESS) {
        mexErrMsgTxt("Error, could not connect to bluetooth\n");
    }   
}

void shutdown() {
    Gem_Terminate();
    mexPrintf("Terminated gemsense connection\n");
    numGems = 0;
}

void connectToGems(const mxArray* details) {
    const mxArray* cellPtr;
    mwSize strlength, numChars;
    char* array;
    int status;

    numGems = (mwSize)mxGetNumberOfElements(details);
    
    for(mwIndex i=0;i<numGems;i++){
        gemState[i] = 5;
        cellPtr = mxGetCell(details,i);
        numChars = (mwSize)mxGetN(cellPtr); // This is the number of characters
        if (numChars!=17) {
            mexErrMsgTxt("Each hardware address in the cell array must have a length of exactly 17");
            mxFree(gemHandles);
            return;
        }
        
        strlength = (mwSize)mxGetN(cellPtr)*sizeof(mxChar)+1; // This is for allocating memory
        array = (char*)mxMalloc(strlength);
        status = mxGetString(cellPtr,array,strlength);
        // Get a handle for this gem
        Gem_Get(array, &gemHandles[i]);        
        mexPrintf("Got handle for gem %s\n",array);
        mxFree(array);
        // Set callback
        switch(i) {
            case 0:
                Gem_SetOnStateChanged(gemHandles[0], OnStateChanged0);
                Gem_SetOnCombinedData(gemHandles[0], OnCombinedData0);                
                break;
            case 1:
                Gem_SetOnStateChanged(gemHandles[1], OnStateChanged1);
                Gem_SetOnCombinedData(gemHandles[1], OnCombinedData1);
                break;
            case 2:
                Gem_SetOnStateChanged(gemHandles[2], OnStateChanged2);
                Gem_SetOnCombinedData(gemHandles[2], OnCombinedData2);
                break;
            case 3:
                Gem_SetOnStateChanged(gemHandles[3], OnStateChanged3);
                Gem_SetOnCombinedData(gemHandles[3], OnCombinedData3);
                break;
            case 4:
                Gem_SetOnStateChanged(gemHandles[4], OnStateChanged4);
                Gem_SetOnCombinedData(gemHandles[4], OnCombinedData4);
                break;
            case 5:
                Gem_SetOnStateChanged(gemHandles[5], OnStateChanged5);
                Gem_SetOnCombinedData(gemHandles[5], OnCombinedData5);
                break;
        }
        // Connect to the first gem
        int result = Gem_Connect(gemHandles[0]);
    }
}

// Update the states
void OnStateChanged(int gemNumber, GemState state) {

    gemState[gemNumber] = state;
    switch (state)
    {
    case Connected:
        mexPrintf("Gem %d connected\n",gemNumber);
        Gem_EnableCombinedData(gemHandles[gemNumber]); // i.e. orientation + acceleration
        // If there are more gems, connect them
        if (numGems>gemNumber+1)
            Gem_Connect(gemHandles[gemNumber+1]);
        break;
    case Connecting:
        mexPrintf("Gem %d connecting\n",gemNumber);
        break;
    case Disconnected:
        mexPrintf("Gem %d disconnected\n",gemNumber);
        break;
    case Disconnecting:
        mexPrintf("Gem %d disconnecting\n",gemNumber);
        break;
    }

}

// Copy the new data into the array
void OnCombinedData(int gemNumber, const float* quaternion, const float* acceleration)
{
    // Copy the date into the array    
    quaternions[gemNumber][0] = quaternion[0];
    quaternions[gemNumber][1] = quaternion[1];
    quaternions[gemNumber][2] = quaternion[2];
    quaternions[gemNumber][3] = quaternion[3];
    accelerations[gemNumber][0] = acceleration[0];
    accelerations[gemNumber][1] = acceleration[1];
    accelerations[gemNumber][2] = acceleration[2];
    updateTime[gemNumber] = (double) clock()/CLOCKS_PER_SEC;            
}