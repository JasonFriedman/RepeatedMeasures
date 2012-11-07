// Copyright 2012 Jason Friedman, Department of Cognitive Science, Macquarie University
// This file is part of Repeated Measures.
// Repeated Measures is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Repeated Measures is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Repeated Measures.  If not, see <http://www.gnu.org/licenses/>.

#define _WIN32_MEAN_AND_LEAN
#include <iostream>
using std::cout;
#include <vhandtk/vhtIOConn.h>
#include <vhandtk/vhtTracker.h>
#include <vhandtk/vhtTrackerData.h>
#include <vhandtk/vht6DofDevice.h>
#include <vhandtk/vhtBaseException.h>
#include "mex.h"
#include <windows.h>

#define M_PI 3.14159265

//Define the local functions
bool MakeConnection(int number_receivers);
int GetSample(int number_receivers, double currentdata[24]);
bool DeleteConnection();
void cleanup(void);

// Define Global variables
vhtTracker *tracker;
vht6DofDevice **rcvr;
int number_receivers; //number of receivers connected to the tracker 

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 unsigned int cmd;  
 double currentdata[24];

 //Check the number of received parameters to the Mex function
 if(nrhs < 1) {
		mexPrintf("Press any number between 0 to 4\n\n");
		mexPrintf("0 is for connecting to the Fastrak\n");
        mexPrintf("1 is for start Recording\n");
		mexPrintf("2 is for getting tracker data\n");
		mexPrintf("3 is for disconnecting the tracker\n");
        mexPrintf("4 is for closing the device\n");
		return;
	}
 else {
       if (nrhs >= 1 ) {
            cmd = (unsigned int) mxGetScalar(prhs[0]);}  
   }
 if (cmd > 0 && tracker == NULL) {
            mexPrintf(" The Fastrack hasn't been connected yet...\n");  // Making sure that the tracker has been initialized and connected before reading data
            return;
  }    
 switch((unsigned int) cmd) {
        case 0:
                  if (nrhs >= 2 ) 
                       number_receivers = (unsigned int) mxGetScalar(prhs[1]);
                  else
                       number_receivers = 1;
                  plhs[0] = mxCreateDoubleMatrix(1,1, mxREAL);
                  *mxGetPr(plhs[0]) = (double) MakeConnection(number_receivers); // function to create the connection
        break;
        case 1: 
                  if (!tracker->getConnectStatus())
                       tracker->connect();
                       mexPrintf("Fastrak is ready to sample.....................\n");
        break;
        case 2:
                   {   
                       tracker->update();
                       int samplesize = GetSample(number_receivers, currentdata); 
					   plhs[0] = mxCreateDoubleMatrix(1,samplesize,mxREAL);
                       double *outArray = mxGetPr(plhs[0]); 
                       for(int i=0;i<samplesize;i++) {
						     outArray[i] = currentdata[i]; 
                       }
					   // second value returned is the update time
					   plhs[1] = mxCreateDoubleMatrix(1,1, mxREAL);
                       *mxGetPr(plhs[1]) = tracker->getLastUpdateTime();
                   }
        break;
        case 3:
                 if (tracker->getConnectStatus()){
                       tracker->disconnect();
                       mexPrintf("Fastrak has been disconnected successfully.....................\n");
                 }     
        break;   
        case 4:
               DeleteConnection();
        break;    
              
   }
   mexAtExit(cleanup);
 }

bool MakeConnection(int number_receivers)
{
    vhtIOConn *fastrakConn = NULL;
    fastrakConn = vhtIOConn::getDefault( vhtIOConn::tracker );
    try
	{
		tracker = (vhtTracker*) mxMalloc(sizeof(vhtTracker));
        new (tracker) vhtTracker(fastrakConn,1);
        mexMakeMemoryPersistent((void *)tracker); 
     }
	catch (vhtBaseException *e)
	{
		mexPrintf("Error with Fastrak\n");
        mexPrintf("???%s\n ",e->getMessage());
        if (tracker != NULL){
            tracker = NULL;
            mxFree(tracker);
        }   
		return 0;
	}
        
    //Find and store the number of receivers connected to the tracker device
    rcvr = (vht6DofDevice**) mxMalloc( sizeof(vht6DofDevice) *  number_receivers);
    for (int i = 0; i < number_receivers; i++){
        rcvr[i] = new vht6DofDevice(tracker);
        rcvr[i] = tracker->getLogicalDevice(i);
     }
    mexMakeMemoryPersistent((void *)rcvr);
    mexPrintf("Connected to the Fastrak with %d receivers.....\n", number_receivers);
    return 1;
}     

int GetSample(int number_receivers, double currentdata[24])
{
    int Data_Dim = tracker->getDimensionRange(); 
    if (rcvr == NULL) //check whether receivers are already assigned or not
          return 0;
    else{
          for (int i = 0; i < number_receivers; i++){
                   if (rcvr[i] != NULL){
						vhtTrackerData *d = tracker->getLogicalDevice(i)->getSensorArray();
						currentdata[i * Data_Dim + 0] = d->position[0];
						currentdata[i * Data_Dim + 1] = d->position[1];
						currentdata[i * Data_Dim + 2] = d->position[2];
						currentdata[i * Data_Dim + 3] = d->position[3]*180/M_PI;
						currentdata[i * Data_Dim + 4] = d->position[4]*180/M_PI;
						currentdata[i * Data_Dim + 5] = d->position[5]*180/M_PI;


					   /*
                      //mexPrintf("current  receiver is %d %f \n", i, rcvr[i]->getRawData(rcvr[i]->xPos) );
                      currentdata[i * Data_Dim + 0] = rcvr[i]->getRawData(rcvr[i]->xPos);
	                  currentdata[i * Data_Dim + 1] = rcvr[i]->getRawData(rcvr[i]->yPos);
	                  currentdata[i * Data_Dim + 2] = rcvr[i]->getRawData(rcvr[i]->zPos);
	                  currentdata[i * Data_Dim + 3] = rcvr[i]->getRawData(rcvr[i]->xAngle);
	                  currentdata[i * Data_Dim + 4] = rcvr[i]->getRawData(rcvr[i]->yAngle);
	                  currentdata[i * Data_Dim + 5] = rcvr[i]->getRawData(rcvr[i]->zAngle);
					  */
                   }    
           } 
    }     
   return (number_receivers * Data_Dim);    
}    

bool DeleteConnection()
{
    if (tracker->getConnectStatus())
        tracker->disconnect();
    tracker = NULL;
    mxFree(tracker); //Free the memory occupied by tracker
    rcvr = NULL;
    mxFree(rcvr); //Free the memory occupied by receiver
    number_receivers = 0;
    mexPrintf("The connection has been deleted successfully.................\n");  
    return 1;  
}

void cleanup(void)
{
   mexPrintf("MEX-file is terminating, destroying persistent variables\n");
    if (tracker != NULL){
                      tracker = NULL;
                      mxFree(tracker);
     } 
   mxFree(rcvr);
}