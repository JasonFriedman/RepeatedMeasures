#define _WIN32_LEAN_AND_MEAN
#include <iostream>
using std::cout;

#include <vhandtk/vhtCyberGlove.h>

#include <vhandtk/vhtIOConn.h>
#include <vhandtk/vhtBaseException.h>
#include "mex.h"
#include <windows.h>


//Define the local functions
bool MakeConnection();
int GetSample(double jointdata[23]);
int GetSampleRaw(double jointdata[23]);
bool DeleteConnection();
void cleanup(void);

// Define Global variables
static vhtCyberGlove *glove; 
mxArray *singleoutput = NULL, *arrayoutput=NULL;
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
 unsigned int cmd;
 double jointdata[23], *outArray;

 //Check the number of received parameters to the Mex function
 if(nrhs < 1) {
		mexPrintf("Press any number between 0 to 4\n\n");
		mexPrintf("0 is for connecting to the cyber Glove\n");
        mexPrintf("1 is for start Recording\n");
		mexPrintf("2 is for getting Joint data\n");
		mexPrintf("3 is for getting raw Joint data\n");
		mexPrintf("4 is for disconnecting the Cyber Glove\n");
        mexPrintf("5 is for closing the device\n");
		return;
	}
 else {
       if (nrhs >= 1 ) {
            cmd = (unsigned int) mxGetScalar(prhs[0]);}  
   }
 if (cmd > 0 && glove == NULL) {
            mexPrintf(" The Cyber Glove hasn't been connected yet...\n");  // Making sure that the glove has been initialized and connected before reading data
            return;
  }    
 switch((unsigned int) cmd) {
        case 0:  {
                   singleoutput = mxCreateDoubleMatrix(1,1, mxREAL); //mxReal is our data-type
                   mexMakeArrayPersistent( singleoutput); //make the array persistent in the memory
                   arrayoutput = mxCreateDoubleMatrix(1,23, mxREAL); //mxReal is our data-type
                   mexMakeArrayPersistent( arrayoutput);
                   plhs[0] = singleoutput;
                   *(mxGetPr(plhs[0])) = (double) MakeConnection();// function to create the connection
          }  
        break;
        case 1: 
                  if (!glove->getConnectStatus())
                       glove->connect();
                       mexPrintf("Cyber Glove is ready to sample.....................\n");
        break;
		case 2:   {  
                       //mexPrintf("Get sample started.....................\n");
                       glove->update();
                       //mexPrintf("Cyber Glove is updated .....................\n");
                       double LastUpdateTime = glove->getLastUpdateTime();
                       //mexPrintf("Lastupdatetime is recorded .....................\n");
                       //mexPrintf("Retrun Matrix 1 is suceessfully created .....................\n");
                       plhs[1] = singleoutput;
                       *(mxGetPr(plhs[1])) = (double) LastUpdateTime;
					   plhs[0] = arrayoutput;
                       outArray = mxGetPr(plhs[0]);
                       int samplesize = GetSample(outArray); 
                       
                       //mexPrintf("Data is assigned.....................\n");
                  }     
        break;
        case 3:   {  
                       //mexPrintf("Get sample started.....................\n");
                       glove->update();
                       //mexPrintf("Cyber Glove is updated .....................\n");
                       double LastUpdateTime = glove->getLastUpdateTime();
                       //mexPrintf("Lastupdatetime is recorded .....................\n");
                       //mexPrintf("Retrun Matrix 1 is suceessfully created .....................\n");
                       plhs[1] = singleoutput;
                       *(mxGetPr(plhs[1])) = (double) LastUpdateTime;
                       int samplesize = GetSampleRaw(jointdata); 
                       plhs[0] = arrayoutput;
                       outArray = mxGetPr(plhs[0]);
                       for(int i=0;i<samplesize;i++){
                             outArray[i] = jointdata[i]; 
                        }
                       //mexPrintf("Data is assigned.....................\n");
                  }     
        break;
        case 4:
               if (glove->getConnectStatus()){
                      glove->disconnect();
                      mexPrintf("Cyber Glove has been disconnected successfully.....................\n");
               }      
        break;   
        case 5:
               DeleteConnection();
        break;    
              
 }
 mexAtExit(cleanup);
 }

bool MakeConnection()
{
    vhtIOConn *gloveDict = NULL;
    gloveDict = vhtIOConn::getDefault( vhtIOConn::glove );
    try
	{
		glove = (vhtCyberGlove *) mxMalloc(sizeof(vhtCyberGlove));
        new (glove) vhtCyberGlove(gloveDict);
        mexMakeMemoryPersistent((void *)glove); 
        
     }
	catch (vhtBaseException* e) {
                   mexPrintf("Error with glove: \n");
                   mexPrintf("Check the glove is turned on and master is running\n");
                   if (glove != NULL){
                      glove = NULL;
                      mxFree(glove);
                    }   
		return 0;
	 }
        
    return 1;
}     

int GetSample(double currentdata[23])
{
    int Data_Dim = glove->getDimensionRange();
	for ( int i = 0; i < Data_Dim; i++ ) {
         currentdata[i]= glove->getData(i);
     }
    
	//for (int i=0;i<5;i++) {
	//	for (int j=0;j<4;j++) {
	//		mexPrintf("Finger %d, joint %d = %.4f\n",i,j,glove->getData((GHM::Fingers)i,(GHM::Joints)j));
	//	}
	//}
	return Data_Dim;    
}    

int GetSampleRaw(double currentdata[23])
{
    int i;
    int Data_Dim = glove->getDimensionRange(); 
	for ( i = 0; i < Data_Dim; i++ ) {
		currentdata[i]= glove->getRawData(i);         
     }
    return Data_Dim;    
}    


bool DeleteConnection()
{
    if (glove->getConnectStatus())
        glove->disconnect();
    glove = NULL;
    mxFree(glove); //Free the memory occupied by glove
    mexPrintf("The connection has been deleted successfully.................\n"); 
   
    return 1;  
}  

void cleanup(void)
{
    mexPrintf("MEX-file is terminating, destroying persistent variables\n");
    if (glove != NULL){
                      glove = NULL;
                      mxFree(glove);
     }   
    if(arrayoutput != NULL){
                      arrayoutput = NULL;
                      mxDestroyArray( arrayoutput);
      }     
    if(singleoutput != NULL){
                      singleoutput = NULL;
                      mxDestroyArray(singleoutput);
     }      
    
}