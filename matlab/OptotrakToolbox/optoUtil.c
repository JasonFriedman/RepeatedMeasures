/********************************************************************
 OptotrakToolbox: Control your Optotrak from within Matlab
 Copyright (C) 2004 Volker Franz, volker.franz@psychol.uni-giessen.de 
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
********************************************************************/
/* Utility functions for Optotrak-Mex files */
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>
#include <limits.h>
#include <float.h>
#include <ndtypes.h>
#include <ndpack.h>
#include <ndopto.h>
#include <mex.h>
#include "optoUtil.h"

/********************************************************************/
/* optoNDIFlags */
/********************************************************************/
struct NDIFLAG_TABLE_ENTRY{
  const char *name;
  const long  value;
} NDIFLAG_TABLE[] = {
  "ANALOG_RAW",                      ANALOG_RAW,
  "DATA_PROPRIETOR",                 DATA_PROPRIETOR,                     
  "ODAU1",                           ODAU1,                               
  "ODAU2",                           ODAU2,                               
  "ODAU3",                           ODAU3,                               
  "ODAU4",                           ODAU4,                               
  "OPTOTRAK",                        OPTOTRAK,                            
  "OPTOTRAK_AUTO_DUTY_CYCLE_FLAG",   OPTOTRAK_AUTO_DUTY_CYCLE_FLAG,   
  "OPTOTRAK_BUFFER_RAW_FLAG",        OPTOTRAK_BUFFER_RAW_FLAG,        
  "OPTOTRAK_CONSTANT_RIGID_FLAG",    OPTOTRAK_CONSTANT_RIGID_FLAG,    
  "OPTOTRAK_DO_RIGID_CALCS_FLAG",    OPTOTRAK_DO_RIGID_CALCS_FLAG,    
  "OPTOTRAK_ECHO_CALIBRATE_FLAG",    OPTOTRAK_ECHO_CALIBRATE_FLAG,    
  "OPTOTRAK_EXTERNAL_CLOCK_FLAG",    OPTOTRAK_EXTERNAL_CLOCK_FLAG,    
  "OPTOTRAK_EXTERNAL_TRIGGER_FLAG",  OPTOTRAK_EXTERNAL_TRIGGER_FLAG,  
  "OPTOTRAK_FULL_DATA_FLAG",         OPTOTRAK_FULL_DATA_FLAG,         
  "OPTOTRAK_GET_NEXT_FRAME_FLAG",    OPTOTRAK_GET_NEXT_FRAME_FLAG,    
  "OPTOTRAK_ITERATIVE_RIGID_FLAG",   OPTOTRAK_ITERATIVE_RIGID_FLAG,   
  "OPTOTRAK_MARKER_BY_MARKER_FLAG",  OPTOTRAK_MARKER_BY_MARKER_FLAG,  
  "OPTOTRAK_NO_FIRE_MARKERS_FLAG",   OPTOTRAK_NO_FIRE_MARKERS_FLAG,   
  "OPTOTRAK_NO_INTERPOLATION_FLAG",  OPTOTRAK_NO_INTERPOLATION_FLAG,  
  "OPTOTRAK_NO_RIGID_CALCS_FLAG",    OPTOTRAK_NO_RIGID_CALCS_FLAG,    
  "OPTOTRAK_PIXEL_DATA_FLAG",        OPTOTRAK_PIXEL_DATA_FLAG,        
  "OPTOTRAK_QUATERN_RIGID_FLAG",     OPTOTRAK_QUATERN_RIGID_FLAG,     
  "OPTOTRAK_RAW",                    OPTOTRAK_RAW,
  "OPTOTRAK_RETURN_EULER_FLAG",      OPTOTRAK_RETURN_EULER_FLAG,      
  "OPTOTRAK_RETURN_MATRIX_FLAG",     OPTOTRAK_RETURN_MATRIX_FLAG,     
  "OPTOTRAK_RETURN_QUATERN_FLAG",    OPTOTRAK_RETURN_QUATERN_FLAG,    
  "OPTOTRAK_REVISIOND_FLAG",         OPTOTRAK_REVISIOND_FLAG,         
  "OPTOTRAK_RIGID_CAPABLE_FLAG",     OPTOTRAK_RIGID_CAPABLE_FLAG,     
  "OPTOTRAK_MARKERS_ACTIVE",         OPTOTRAK_MARKERS_ACTIVE,     
  "OPTOTRAK_SET_MIN_MARKERS_FLAG",   OPTOTRAK_SET_MIN_MARKERS_FLAG,   
  "OPTOTRAK_SET_QUATERN_ERROR_FLAG", OPTOTRAK_SET_QUATERN_ERROR_FLAG, 
  "OPTOTRAK_STATIC_RIGID_FLAG",      OPTOTRAK_STATIC_RIGID_FLAG,      
  "OPTOTRAK_STATIC_THRESHOLD_FLAG",  OPTOTRAK_STATIC_THRESHOLD_FLAG,  
  "OPTOTRAK_STATIC_XFRM_FLAG",       OPTOTRAK_STATIC_XFRM_FLAG,       
  "OPTOTRAK_UNDETERMINED_FLAG",      OPTOTRAK_UNDETERMINED_FLAG,      
  "OPTOTRAK_WAVEFORM_DATA_FLAG",     OPTOTRAK_WAVEFORM_DATA_FLAG,
  "OPTO_ASCII_RESPONSE_FLAG",        OPTO_ASCII_RESPONSE_FLAG,        
  "OPTO_BUFFER_OVERRUN_FLAG",        OPTO_BUFFER_OVERRUN_FLAG,        
  "OPTO_CONVERT_ON_HOST",            OPTO_CONVERT_ON_HOST,            
  //These flags are not needed and conflict with the use in Optotrak Certus:
  //  "OPTO_DATA_BUFFER_MESSAGE",        OPTO_DATA_BUFFER_MESSAGE,        
  //  "OPTO_DATA_HEADER_SIZE",           OPTO_DATA_HEADER_SIZE,           
  //  "OPTO_ERROR_COMMAND",              OPTO_ERROR_COMMAND,              
  //  "OPTO_ERROR_MESSAGE",              OPTO_ERROR_MESSAGE,              
  //  "OPTO_ERROR_REQUEST_COMMAND",      OPTO_ERROR_REQUEST_COMMAND,      
  //  "OPTO_ERROR_REQUEST_MESSAGE",      OPTO_ERROR_REQUEST_MESSAGE,      
  "OPTO_FRAME_OVERRUN_FLAG",         OPTO_FRAME_OVERRUN_FLAG,         
  "OPTO_HW_TYPE_ODAU",               OPTO_HW_TYPE_ODAU,               
  "OPTO_HW_TYPE_REALTIME",           OPTO_HW_TYPE_REALTIME,           
  "OPTO_HW_TYPE_SENSOR",             OPTO_HW_TYPE_SENSOR,             
  "OPTO_HW_TYPE_SU",                 OPTO_HW_TYPE_SU,                 
  //These flags are not needed and conflict with the use in Optotrak Certus:
  //  "OPTO_LATEST_BUFFER_MESSAGE",      OPTO_LATEST_BUFFER_MESSAGE,      
  //  "OPTO_LATEST_FRAME_MESSAGE",       OPTO_LATEST_FRAME_MESSAGE,       
  //  "OPTO_LATEST_RAW_FRAME_MESSAGE",   OPTO_LATEST_RAW_FRAME_MESSAGE,   
  //  "OPTO_LATEST_RIGID_FRAME_MESSAGE", OPTO_LATEST_RIGID_FRAME_MESSAGE, 
  //  "OPTO_LATEST_RIGID_MESSAGE",       OPTO_LATEST_RIGID_MESSAGE,       
  //  "OPTO_LATEST_WAVE_FRAME_MESSAGE",  OPTO_LATEST_WAVE_FRAME_MESSAGE,  
  "OPTO_LIB_POLL_REAL_DATA",         OPTO_LIB_POLL_REAL_DATA,         
  "OPTO_LOG_DEBUG_FLAG",             OPTO_LOG_DEBUG_FLAG,             
  "OPTO_LOG_ERRORS_FLAG",            OPTO_LOG_ERRORS_FLAG,            
  "OPTO_LOG_MESSAGES_FLAG",          OPTO_LOG_MESSAGES_FLAG,          
  //These flags are not needed and conflict with the use in Optotrak Certus:
  //  "OPTO_NEXT_FRAME_MESSAGE",         OPTO_NEXT_FRAME_MESSAGE,         
  //  "OPTO_NEXT_RAW_FRAME_MESSAGE",     OPTO_NEXT_RAW_FRAME_MESSAGE,     
  //  "OPTO_NEXT_RIGID_FRAME_MESSAGE",   OPTO_NEXT_RIGID_FRAME_MESSAGE,   
  //  "OPTO_NODE_INFO_MESSAGE",          OPTO_NODE_INFO_MESSAGE,          
  "OPTO_NO_ERROR_CODE",              OPTO_NO_ERROR_CODE,              
  "OPTO_NO_PRE_FRAMES_FLAG",         OPTO_NO_PRE_FRAMES_FLAG,         
  //These flags are not needed and conflict with the use in Optotrak Certus:
  //  "OPTO_NO_REPLY_FLAG",              OPTO_NO_REPLY_FLAG,              
  //  "OPTO_PROCESS_BITS",               OPTO_PROCESS_BITS,               
  //  "OPTO_REGISTER_EVENT_MESSAGE",     OPTO_REGISTER_EVENT_MESSAGE,     
  "OPTO_RIGID_HEADER_SIZE",          OPTO_RIGID_HEADER_SIZE,          
  "OPTO_RIGID_ON_HOST",              OPTO_RIGID_ON_HOST,              
  "OPTO_SECONDARY_HOST_FLAG",        OPTO_SECONDARY_HOST_FLAG,        
  //These flags are not needed and conflict with the use in Optotrak Certus:
  //  "OPTO_STATUS_REQUEST_MESSAGE",     OPTO_STATUS_REQUEST_MESSAGE,     
  //  "OPTO_SUCCESSFUL_COMMAND",         OPTO_SUCCESSFUL_COMMAND,         
  //  "OPTO_SUCCESSFUL_MESSAGE",         OPTO_SUCCESSFUL_MESSAGE,         
  "OPTO_SYSTEM_ERROR_CODE",          OPTO_SYSTEM_ERROR_CODE,          
  //These flags are not needed and conflict with the use in Optotrak Certus:
  //  "OPTO_TRANSFORM_DATA_MESSAGE",     OPTO_TRANSFORM_DATA_MESSAGE,     
  "OPTO_TRANSFORM_DATA_SIZE",        OPTO_TRANSFORM_DATA_SIZE,        
  //These flags are not needed and conflict with the use in Optotrak Certus:
  //  "OPTO_TRANS_BUFFER_MESSAGE",       OPTO_TRANS_BUFFER_MESSAGE,       
  //  "OPTO_TX_MANY_FRAME_MESSAGE",      OPTO_TX_MANY_FRAME_MESSAGE,      
  //  "OPTO_TX_ONE_FRAME_MESSAGE",       OPTO_TX_ONE_FRAME_MESSAGE,       
  //  "OPTO_UNSUCCESSFUL_COMMAND",       OPTO_UNSUCCESSFUL_COMMAND,       
  //  "OPTO_UNSUCCESSFUL_MESSAGE",       OPTO_UNSUCCESSFUL_MESSAGE,       
  "OPTO_USER_ERROR_CODE",            OPTO_USER_ERROR_CODE,            
  "OPTO_USE_INTERNAL_NIF",           OPTO_USE_INTERNAL_NIF,            
  "SENSOR_PROP1",                    SENSOR_PROP1                        
};
#define NDIFLAG_TABLE_SIZE ( sizeof NDIFLAG_TABLE / sizeof NDIFLAG_TABLE[0] )

/********************************************************************/
/* local functions: */
/********************************************************************/
/* Error handling: */
void optoNDIerror();
int  optoError(char *fmt,...);

/* Input utilities:  */
int            optoIs1Field (const mxArray *inval,const char *fieldName, const char *errName);
const mxArray *optoGet1Field (const mxArray *inval,const char *fieldName, const char *errName);
float          optoGet1Float (const mxArray *inval,const char *errName);
Position3d    *optoGetNPos3D (const mxArray *inval,const char *errName);
unsigned int   optoGet1UInt  (const mxArray *inval,const char *errName);
int            optoGet1Int   (const mxArray *inval,const char *errName);
char          *optoGet1String(const mxArray *inval,const char *errName);
long           optoGetFlags  (const mxArray *inval,const char *errName);
long           optoGetNDIFlagValue(char *flagName);
unsigned int   optoLong2UInt(long inval);
int            optoLong2Int(long inval);
float          optoDouble2Float(double inval);

/* Output utilities:  */
void optoSet1DoubleField  (mxArray *outval,const char *fieldName,double fieldValue);
void optoSet1StringField  (mxArray *outval,const char *fieldName,char *fieldValue);
void optoSet3DMarkersField(mxArray *outval,const char *fieldName,unsigned int uNumMarkers,Position3d *p3dFrame);
void optoSetRBsField      (mxArray *outval,const char *fieldName,unsigned int uNumRigids,struct OptotrakRigidStruct *pRBFrame);

/*  Print utilities: */
void optoPrint3DHeader(unsigned int uFrameNumber,unsigned int uNumMarkers,unsigned int uFlags);
void optoPrint3DMarkers(unsigned int uNumMarkers,Position3d *p3dFrame);
void optoPrintRBs(unsigned int uNumRigids,struct OptotrakRigidStruct *pRBFrame);

/* Data utilities:  */
double optoBadFloatFilter(double value);
void   optoBadRBFrameFilter(unsigned int uNumRigids,struct OptotrakRigidStruct *pRBFrame);

/* Help utilities: */
void optoStandardHelpHeader(char name[],char cname[]);

/* optoMatlabCommands (=wrapper for NDI API): */
optoFunctionPtr optoSelectFunction(char *optoCommandName);
void optoTransputerDetermineSystemCfg(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoTransputerInitializeSystem  (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoTransputerLoadSystem        (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoTransputerShutdownSystem    (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoOptotrakActivateMarkers     (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoOptotrakChangeCameraFOR     (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoOptotrakDeActivateMarkers   (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoOptotrakLoadCameraParameters(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoOptotrakSetProcessingFlags  (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoOptotrakSetupCollection     (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoDataBufferInitializeFile    (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoDataBufferSpoolData         (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoDataBufferStart             (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoDataBufferStop              (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoDataBufferWriteData         (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoDataGetLatest3D             (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoDataGetLatestTransforms     (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoDataGetNext3D               (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoDataGetNextTransforms       (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoDataIsReady                 (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoDataReceiveLatest3D         (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoDataReceiveLatestTransforms (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoRequestLatest3D             (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoRequestLatestTransforms     (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoRequestNext3D               (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoRequestNextTransforms       (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoRigidBodyAddFromFile        (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoRigidBodyChangeSettings     (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoRigidBodyDelete             (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoFileConvert                 (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
/* todonew xxx */
/* void opto(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]); */
/* void opto(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]); */

/* Additional optoMatlabCommands: */
void optoRead3DFileToMatlab          (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoRead3DFileWithRigidsToMatlab(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoOptotrakPrintStatus         (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);
void optoPrintNDIFlags               (char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);

/********************************************************************/
/* optoError */
/********************************************************************/
void optoNDIerror(){
  char szNDErrorString[MAX_ERROR_STRING_LENGTH+1];/* MAX_ERROR_STRING_LENGTH from: ndopto.h */
  mexPrintf("\n"); 
  mexPrintf("======================================================================\n"); 
  mexPrintf("OptotrakToolbox: An Optotrak-error occured!                            \n"); 
  mexPrintf("======================================================================\n"); 
  mexPrintf("The original Optotrak error message is:\n\n"); 
  if(OptotrakGetErrorString(szNDErrorString,MAX_ERROR_STRING_LENGTH+1)==0){
    mexPrintf(szNDErrorString);
    mexPrintf("\n\n"); 
  }
  mexPrintf("OptotrakToolbox: Switching off markers and shutting down transputer system.\n"); 
  OptotrakDeActivateMarkers();
  TransputerShutdownSystem();
  mexErrMsgTxt("!!!"); 
}

int optoError(char *fmt,...){
  /* Print error message for all optoGetInput functions */
  char errmsg[OPTO_ERROR_MSG_LENGTH];
  char errmsg_dummy[OPTO_ERROR_MSG_LENGTH];
  va_list ap;

  /* Print formatted message to errmsg: */
  va_start(ap,fmt);
  vsprintf(errmsg_dummy,fmt,ap);
  va_end(ap);
  sprintf(errmsg,"OptotrakToolbox: %s",errmsg_dummy);
  mexErrMsgTxt(errmsg);
}

/********************************************************************/
/* optoInput */
/********************************************************************/
int optoIs1Field (const mxArray *inval,const char *fieldName, const char *errName){
  /* We only allow structs of size 1x1 (the Optotrak API only uses these)! */
  mxArray  *fieldArray;
  if(!mxIsStruct(inval))              optoError("%s: must be a struct.",errName);
  if(mxGetNumberOfElements(inval)!=1) optoError("%s: must have size 1x1.",errName);

  /* Get the value of the field: */
  fieldArray = mxGetField(inval,0,fieldName);
  if(fieldArray==NULL) return 0;       
  else                 return 1;
}

const mxArray *optoGet1Field (const mxArray *inval,const char *fieldName, const char *errName){
  /* We only allow structs of size 1x1 (the Optotrak API only uses these)! */
  mxArray  *fieldArray;
  if(!mxIsStruct(inval))              optoError("%s: must be a struct.",errName);
  if(mxGetNumberOfElements(inval)!=1) optoError("%s: must have size 1x1.",errName);

  /* Get the value of the field: */
  fieldArray = mxGetField(inval,0,fieldName);
  if(fieldArray==NULL)        optoError("%s: must have a field named %s.",errName,fieldName);
  if(mxIsComplex(fieldArray)) optoError("%s: Field %s must be non-complex.",errName,fieldName);

  return fieldArray;
}

float optoGet1Float(const mxArray *inval,const char *errName){
  if(!mxIsNumeric(inval))             optoError("%s: must be numeric.",errName);
  if(mxGetNumberOfElements(inval)!=1) optoError("%s: must be a scalar.",errName);
  if(mxIsComplex(inval))              optoError("%s: must be non-complex.",errName);

  /* Savely convert to a float value:*/
  return optoDouble2Float(mxGetScalar(inval));
}

Position3d *optoGetNPos3D(const mxArray *inval,const char *errName){
  Position3d *pos;
  int        N,i;
  if(!mxIsNumeric(inval)) optoError("%s: must be numeric.",errName);
  if(mxGetM(inval)!=3)    optoError("%s: must have 3 rows.",errName);
  if(mxIsComplex(inval))  optoError("%s: must be non-complex.",errName);

  /* Convert to a Position3d array:*/
  N = mxGetN(inval);
  pos = (Position3d *)mxMalloc(N*sizeof(Position3d));
  for(i=0;i<N;i++){
    pos[i].x=optoDouble2Float(mxGetPr(inval)[i*3+0]);
    pos[i].y=optoDouble2Float(mxGetPr(inval)[i*3+1]);
    pos[i].z=optoDouble2Float(mxGetPr(inval)[i*3+2]);
  }
  return pos;
}

unsigned int optoGet1UInt(const mxArray *inval,const char *errName){
  double x_d;

  if(!mxIsNumeric(inval))             optoError("%s: must be numeric.",errName);
  if(mxGetNumberOfElements(inval)!=1) optoError("%s: must be a scalar.",errName);
  if(mxIsComplex(inval))              optoError("%s: must be non-complex.",errName);

  /* Savely convert to an unsigned int value:*/
  x_d = mxGetScalar(inval);
  if(floor(x_d)!=ceil(x_d))optoError("%s: must be an integer, not a double!",errName);
  if(x_d>(double)UINT_MAX) optoError("%s: too large for an uint.",errName);
  if(x_d<(double)0)        optoError("%s: too small for an uint.",errName);
  return (unsigned int)x_d;
}

int optoGet1Int(const mxArray *inval,const char *errName){
  double x_d;

  if(!mxIsNumeric(inval))             optoError("%s: must be numeric.",errName);
  if(mxGetNumberOfElements(inval)!=1) optoError("%s: must be a scalar.",errName);
  if(mxIsComplex(inval))              optoError("%s: must be non-complex.",errName);

  /* Savely convert to an integer value:*/
  x_d = mxGetScalar(inval);
  if(floor(x_d)!=ceil(x_d))optoError("%s: must be an integer, not a double!",errName);
  if(x_d>(double)INT_MAX) optoError("%s: too large for an int.",errName);
  if(x_d<(double)INT_MIN) optoError("%s: too small for an int.",errName);
  return (int)x_d;
}

char *optoGet1String(const mxArray *inval,const char *errName){
  char *buf;
  int   buflen;

  if(mxIsChar(inval)!=1) optoError("%s: must be a string.",errName);
  if(mxGetM(inval)!=1)   optoError("%s: must be a row vector.",errName);

  /* Convert input string to C string:  */
  buflen = mxGetNumberOfElements(inval)+1;
  buf    = mxCalloc(buflen, sizeof(char));
  if(mxGetString(inval,buf,buflen)) optoError("%s: Not enough space for string",errName);
  return buf;
}

long optoGetFlags(const mxArray *inval,const char *errName){
  int   numFlags,index,buflen;
  char  *buf; 
  const mxArray *flag;
  long  result=0;

  if(mxIsCell(inval)==0) optoError("%s: Flags must be a cell array",errName);
  numFlags = mxGetNumberOfElements(inval);
  if(OPTO_VERBOSE>=3) mexPrintf("Number of flags = %d\n", numFlags);

  for (index=0; index<numFlags; index++)  {
    /* Get flag: */
    flag = mxGetCell(inval,index);
    if (flag==NULL)       optoError("%s: Empty flags not allowed",errName);
    if(mxIsChar(flag)!=1) optoError("%s: Flags must only contain strings",errName);

    /* Convert input string to C string:  */
    buflen = mxGetNumberOfElements(flag)+1;
    buf    = mxCalloc(buflen,sizeof(char));
    if(mxGetString(flag,buf,buflen)) optoError("%s: Not enough space for flag",errName);

    /* Combine flags with binary OR: */
    result = optoGetNDIFlagValue(buf) | result;
  }
  if(OPTO_VERBOSE>=3) mexPrintf("Combining all flags gives: 0x%04x\n",result);
  return result;
}

/*todo: move to optoFlags */
long optoGetNDIFlagValue(char *flagName){ 
  int  index;
  long value;

  /* Search flags:: */
  for(index=0;index<NDIFLAG_TABLE_SIZE;index++){
    if(OPTO_VERBOSE>=5) mexPrintf("   Searching flag: %s at index: %i\n",flagName,index);
    if(strcmp(flagName,NDIFLAG_TABLE[index].name)==0) break;
  }
  if(index==NDIFLAG_TABLE_SIZE){
    optoError("Did not find %s\n",flagName);
  }
  else{
    value=NDIFLAG_TABLE[index].value;
    if(OPTO_VERBOSE>=4){
      mexPrintf("      Found: %s at index: %i, value: 0x%04x\n",flagName,index,value);
    }
  }
  return value;
}

unsigned int optoLong2UInt(long inval){
  /* Savely convert to an unsigned int value:*/
  if(inval>UINT_MAX) optoError("Value too large for an uint.");
  if(inval<0)        optoError("Value too small for an uint.");
  return (unsigned int)inval;
}

int optoLong2Int(long inval){
  /* Savely convert to an unsigned int value:*/
  if(inval>INT_MAX) optoError("Value too large for an int.");
  if(inval<INT_MIN) optoError("Value too small for an int.");
  return (int)inval;
}

float optoDouble2Float(double inval){
  /* Savely convert to a float value:*/
  if(inval> (double)FLT_MAX) optoError("Value %f too large for a float.",inval);
  if(inval<-(double)FLT_MAX) optoError("Value %f too small for a float.",inval);
  return (float)inval;
}
/********************************************************************/
/* optoOutput */
/********************************************************************/
void optoSet1DoubleField(mxArray *outval,const char *fieldName,double fieldValue){
  /* We only allow structs of size 1x1! */
  mxArray  *fieldArray;

  fieldArray = mxCreateDoubleMatrix(1,1,mxREAL);
  *mxGetPr(fieldArray) = fieldValue;
  mxSetField(outval,0,fieldName,fieldArray);
}

void optoSet1StringField(mxArray *outval,const char *fieldName,char *fieldValue){
  /* We only allow structs of size 1x1! */
  mxSetField(outval,0,fieldName,mxCreateString(fieldValue));
}

void optoSet3DMarkersField(mxArray *outval,const char *fieldName,unsigned int uNumMarkers,Position3d *p3dFrame){
  /* For each marker create an empty mxArray of size 3x1, 
     copy the marker values to this array, 
     collect all arrays in one cell and add the cell as field to 
     outval: */
  mxArray *MarkerArray, *MarkerCell;
  unsigned int i;
  /* We only allow a marker cell of size 1x1! */
  MarkerCell   = mxCreateCellMatrix(uNumMarkers,1);
  for(i=0;i<uNumMarkers;i++){
    MarkerArray = mxCreateDoubleMatrix(3,1,mxREAL);
    mxGetPr(MarkerArray)[0]=optoBadFloatFilter(p3dFrame[i].x);
    mxGetPr(MarkerArray)[1]=optoBadFloatFilter(p3dFrame[i].y);
    mxGetPr(MarkerArray)[2]=optoBadFloatFilter(p3dFrame[i].z);
    mxSetCell(MarkerCell,i,MarkerArray);
  }
  mxSetField(outval,0,fieldName,MarkerCell);
  return;
}

void optoSetRBsField(mxArray *outval,const char *fieldName,unsigned int uNumRigids,struct OptotrakRigidStruct *pRBFrame){
  /* For each RB determine its transformation and create a corresponding struct, 
     copy the RBvalues to this struct,
     collect all structs in one cell and add the cell as field to 
     outval: */
  mxArray *RBStruct, *RBCell, *Dummy;
  const char *EulerFieldNames[]     ={"TransformError","QuaternionError","IterativeError","Trans","RotEuler"};
  const char *MatrixFieldNames[]    ={"TransformError","QuaternionError","IterativeError","Trans","RotMatrix"};
  const char *QuaternionFieldNames[]={"TransformError","QuaternionError","IterativeError","Trans","RotQuaternion"};
  const int   nRBFields = sizeof(EulerFieldNames)/sizeof(char *);
  unsigned int i;
  long int flags;

  /* We only allow a RB cell of size uNumRigidsx1! */
  RBCell   = mxCreateCellMatrix(uNumRigids,1);
  for(i=0;i<uNumRigids;i++){
    flags=pRBFrame[i].flags;

    /* Create struct for this RB: */
    if(flags & OPTOTRAK_RETURN_EULER_FLAG ) 
      RBStruct = mxCreateStructMatrix(1,1,nRBFields,EulerFieldNames);
    else if(flags & OPTOTRAK_RETURN_MATRIX_FLAG ) 
      RBStruct = mxCreateStructMatrix(1,1,nRBFields,MatrixFieldNames);
    else if(flags & OPTOTRAK_RETURN_QUATERN_FLAG )
      RBStruct = mxCreateStructMatrix(1,1,nRBFields,QuaternionFieldNames);
    else optoError("Could not determine type of RB transformation");
    /* Set standard fields */
    if(flags & OPTOTRAK_UNDETERMINED_FLAG)
      optoSet1StringField(RBStruct,"TransformError",RB_UNDETERMINED_TRANS);
    else if(flags & OPTOTRAK_RIGID_ERR_MKR_SPREAD) 
      optoSet1StringField(RBStruct,"TransformError",RB_MARKER_SPREAD_ERROR);
    else
      optoSet1StringField(RBStruct,"TransformError",RB_NO_ERROR);
    optoSet1DoubleField(RBStruct,"QuaternionError",pRBFrame[i].QuaternionError);
    optoSet1DoubleField(RBStruct,"IterativeError" ,pRBFrame[i].IterativeError);
    if(flags & OPTOTRAK_RETURN_EULER_FLAG ){
      Dummy = mxCreateDoubleMatrix(3,1,mxREAL);
      mxGetPr(Dummy)[0]=optoBadFloatFilter(pRBFrame[i].transformation.euler.translation.x);
      mxGetPr(Dummy)[1]=optoBadFloatFilter(pRBFrame[i].transformation.euler.translation.y);
      mxGetPr(Dummy)[2]=optoBadFloatFilter(pRBFrame[i].transformation.euler.translation.z);
      mxSetField(RBStruct,0,"Trans",Dummy);
      Dummy = mxCreateDoubleMatrix(3,1,mxREAL);
      mxGetPr(Dummy)[0]=optoBadFloatFilter(pRBFrame[i].transformation.euler.rotation.yaw);
      mxGetPr(Dummy)[1]=optoBadFloatFilter(pRBFrame[i].transformation.euler.rotation.pitch);
      mxGetPr(Dummy)[2]=optoBadFloatFilter(pRBFrame[i].transformation.euler.rotation.roll);
      mxSetField(RBStruct,0,"RotEuler",Dummy);
    }
    else if(flags & OPTOTRAK_RETURN_MATRIX_FLAG ){
      Dummy = mxCreateDoubleMatrix(3,1,mxREAL);
      mxGetPr(Dummy)[0]=optoBadFloatFilter(pRBFrame[i].transformation.rotation.translation.x);
      mxGetPr(Dummy)[1]=optoBadFloatFilter(pRBFrame[i].transformation.rotation.translation.y);
      mxGetPr(Dummy)[2]=optoBadFloatFilter(pRBFrame[i].transformation.rotation.translation.z);
      mxSetField(RBStruct,0,"Trans",Dummy);
      Dummy = mxCreateDoubleMatrix(3,3,mxREAL);
      mxGetPr(Dummy)[0]=optoBadFloatFilter(pRBFrame[i].transformation.rotation.matrix[0][0]);
      mxGetPr(Dummy)[1]=optoBadFloatFilter(pRBFrame[i].transformation.rotation.matrix[1][0]);
      mxGetPr(Dummy)[2]=optoBadFloatFilter(pRBFrame[i].transformation.rotation.matrix[2][0]);
      mxGetPr(Dummy)[3]=optoBadFloatFilter(pRBFrame[i].transformation.rotation.matrix[0][1]);
      mxGetPr(Dummy)[4]=optoBadFloatFilter(pRBFrame[i].transformation.rotation.matrix[1][1]);
      mxGetPr(Dummy)[5]=optoBadFloatFilter(pRBFrame[i].transformation.rotation.matrix[2][1]);
      mxGetPr(Dummy)[6]=optoBadFloatFilter(pRBFrame[i].transformation.rotation.matrix[0][2]);
      mxGetPr(Dummy)[7]=optoBadFloatFilter(pRBFrame[i].transformation.rotation.matrix[1][2]);
      mxGetPr(Dummy)[8]=optoBadFloatFilter(pRBFrame[i].transformation.rotation.matrix[2][2]);
      mxSetField(RBStruct,0,"RotMatrix",Dummy);
    }
    else if(flags & OPTOTRAK_RETURN_QUATERN_FLAG ){
      Dummy = mxCreateDoubleMatrix(3,1,mxREAL);
      mxGetPr(Dummy)[0]=optoBadFloatFilter(pRBFrame[i].transformation.quaternion.translation.x);
      mxGetPr(Dummy)[1]=optoBadFloatFilter(pRBFrame[i].transformation.quaternion.translation.y);
      mxGetPr(Dummy)[2]=optoBadFloatFilter(pRBFrame[i].transformation.quaternion.translation.z);
      mxSetField(RBStruct,0,"Trans",Dummy);
      Dummy = mxCreateDoubleMatrix(4,1,mxREAL);
      mxGetPr(Dummy)[0]=optoBadFloatFilter(pRBFrame[i].transformation.quaternion.rotation.q0);
      mxGetPr(Dummy)[1]=optoBadFloatFilter(pRBFrame[i].transformation.quaternion.rotation.qx);
      mxGetPr(Dummy)[2]=optoBadFloatFilter(pRBFrame[i].transformation.quaternion.rotation.qy);
      mxGetPr(Dummy)[3]=optoBadFloatFilter(pRBFrame[i].transformation.quaternion.rotation.qz);
      mxSetField(RBStruct,0,"RotQuaternion",Dummy);
    }
    mxSetCell(RBCell,i,RBStruct);
  }
  mxSetField(outval,0,fieldName,RBCell);
  return;
}

/********************************************************************/
/* optoPrint */
/********************************************************************/
void optoPrint3DHeader(unsigned int uFrameNumber,unsigned int uNumMarkers,unsigned int uFlags){
    mexPrintf("FrameNumber       : %8u    \n",uFrameNumber);
    mexPrintf("Number of Elements: %8u    \n",uNumMarkers );
    mexPrintf("Flags             : 0x%04x \n",uFlags );
}

void optoPrint3DMarkers(unsigned int uNumMarkers,Position3d *p3dFrame){
  unsigned int i;
  for(i=0;i<uNumMarkers;i++){
    mexPrintf("   Marker %3i: X %8.2f Y %8.2f Z %8.2f\n",
              i,p3dFrame[i].x,p3dFrame[i].y,p3dFrame[i].z);
  }
}

void optoPrintRBs(unsigned int uNumRigids,struct OptotrakRigidStruct *pRBFrame){
  unsigned int i;
  long int flags;

  mexPrintf("Number of rigid bodies: %i\n",uNumRigids );
  for(i=0;i<uNumRigids;i++){
    flags=pRBFrame[i].flags;
    mexPrintf("Rigid body %3i (ID= %2i):\n",i,pRBFrame[i].RigidId);
    mexPrintf("  flags:           0x%04x\n",flags);
    mexPrintf("  QuaternionError: %f\n",pRBFrame[i].QuaternionError);
    mexPrintf("  IterativeError:  %f\n",pRBFrame[i].IterativeError);
    if(flags & OPTOTRAK_UNDETERMINED_FLAG)    mexPrintf("  Undetermined transform!\n");
    if(flags & OPTOTRAK_RIGID_ERR_MKR_SPREAD) mexPrintf("  Marker spread error!\n");
    if(flags & OPTOTRAK_RETURN_EULER_FLAG ){
      mexPrintf("  Transformation:\n");
      mexPrintf("  X %8.2f Y %8.2f Z %8.2f\n",
                pRBFrame[i].transformation.euler.translation.x,
                pRBFrame[i].transformation.euler.translation.y,
                pRBFrame[i].transformation.euler.translation.z);
      mexPrintf("  Euler angle format:\n");
      mexPrintf("  RotX/yaw %8.2f RotY/pitch %8.2f RotZ/roll %8.2f\n",
                pRBFrame[i].transformation.euler.rotation.yaw,
                pRBFrame[i].transformation.euler.rotation.pitch,
                pRBFrame[i].transformation.euler.rotation.roll);
    }
    else if(flags & OPTOTRAK_RETURN_MATRIX_FLAG ){
      mexPrintf("  Transformation:\n");
      mexPrintf("  X %8.2f Y %8.2f Z %8.2f\n",
                pRBFrame[i].transformation.rotation.translation.x,
                pRBFrame[i].transformation.rotation.translation.y,
                pRBFrame[i].transformation.rotation.translation.z);
      mexPrintf("  Rotation matrix format:\n");
      mexPrintf("    MAT(1,1) %8.2f MAT(1,2) %8.2f MAT(1,3) %8.2f\n",
                pRBFrame[i].transformation.rotation.matrix[0][0],
                pRBFrame[i].transformation.rotation.matrix[0][1],
                pRBFrame[i].transformation.rotation.matrix[0][2]);
      mexPrintf("    MAT(2,1) %8.2f MAT(2,2) %8.2f MAT(2,3) %8.2f\n",
                pRBFrame[i].transformation.rotation.matrix[1][0],
                pRBFrame[i].transformation.rotation.matrix[1][1],
                pRBFrame[i].transformation.rotation.matrix[1][2]);
      mexPrintf("    MAT(3,1) %8.2f MAT(3,2) %8.2f MAT(3,3) %8.2f\n",
                pRBFrame[i].transformation.rotation.matrix[2][0],
                pRBFrame[i].transformation.rotation.matrix[2][1],
                pRBFrame[i].transformation.rotation.matrix[2][2]);
    }
    else if(flags & OPTOTRAK_RETURN_QUATERN_FLAG ){
      mexPrintf("  Transformation:\n");
      mexPrintf("  X %8.2f Y %8.2f Z %8.2f\n",
                pRBFrame[i].transformation.quaternion.translation.x,
                pRBFrame[i].transformation.quaternion.translation.y,
                pRBFrame[i].transformation.quaternion.translation.z);
      mexPrintf("  Quaternion format:\n");
      mexPrintf("  Rotq0 %8.2f Rotqx %8.2f Rotqy %8.2f Rotqz %8.2f\n",
                pRBFrame[i].transformation.quaternion.rotation.q0,
                pRBFrame[i].transformation.quaternion.rotation.qx,
                pRBFrame[i].transformation.quaternion.rotation.qy,
                pRBFrame[i].transformation.quaternion.rotation.qz);
    }
  }
}

/********************************************************************/
/* optoData */
/********************************************************************/
double optoBadFloatFilter(double value){
  /*Sets missing markers to NaN */
  if(value < MAX_NEGATIVE) value=mxGetNaN();
  return value;
}

void optoBadRBFrameFilter(unsigned int uNumRigids,struct OptotrakRigidStruct *pRBFrame){
  unsigned int i;
  long int flags;

  for(i=0;i<uNumRigids;i++){
    flags=pRBFrame[i].flags;
    if((flags & OPTOTRAK_UNDETERMINED_FLAG) |
       (flags & OPTOTRAK_RIGID_ERR_MKR_SPREAD)){
      if(flags & OPTOTRAK_RETURN_EULER_FLAG ){
        pRBFrame[i].transformation.euler.translation.x =mxGetNaN();
        pRBFrame[i].transformation.euler.translation.y =mxGetNaN();
        pRBFrame[i].transformation.euler.translation.z =mxGetNaN();
        pRBFrame[i].transformation.euler.rotation.yaw  =mxGetNaN();
        pRBFrame[i].transformation.euler.rotation.pitch=mxGetNaN();
        pRBFrame[i].transformation.euler.rotation.roll =mxGetNaN();
      }
      else if(flags & OPTOTRAK_RETURN_MATRIX_FLAG ){
        pRBFrame[i].transformation.rotation.translation.x=mxGetNaN();
        pRBFrame[i].transformation.rotation.translation.y=mxGetNaN();
        pRBFrame[i].transformation.rotation.translation.z=mxGetNaN();
        pRBFrame[i].transformation.rotation.matrix[0][0] =mxGetNaN();
        pRBFrame[i].transformation.rotation.matrix[0][1] =mxGetNaN();
        pRBFrame[i].transformation.rotation.matrix[0][2] =mxGetNaN();
        pRBFrame[i].transformation.rotation.matrix[1][0] =mxGetNaN();
        pRBFrame[i].transformation.rotation.matrix[1][1] =mxGetNaN();
        pRBFrame[i].transformation.rotation.matrix[1][2] =mxGetNaN();
        pRBFrame[i].transformation.rotation.matrix[2][0] =mxGetNaN();
        pRBFrame[i].transformation.rotation.matrix[2][1] =mxGetNaN();
        pRBFrame[i].transformation.rotation.matrix[2][2] =mxGetNaN();
      }
      else if(flags & OPTOTRAK_RETURN_QUATERN_FLAG ){
        pRBFrame[i].transformation.quaternion.translation.x=mxGetNaN();
        pRBFrame[i].transformation.quaternion.translation.y=mxGetNaN();
        pRBFrame[i].transformation.quaternion.translation.z=mxGetNaN();
        pRBFrame[i].transformation.quaternion.rotation.q0  =mxGetNaN();
        pRBFrame[i].transformation.quaternion.rotation.qx  =mxGetNaN();
        pRBFrame[i].transformation.quaternion.rotation.qy  =mxGetNaN();
        pRBFrame[i].transformation.quaternion.rotation.qz  =mxGetNaN();
      }
    }
  }
}
/********************************************************************/
/* optoHelp */
/********************************************************************/
void optoStandardHelpHeader(char name[],char cname[]){
  mexPrintf("%-40s OptotrakToolbox, version: %f\n",name,OPTOTOOLBOX_VERSION); 
  mexPrintf("\n");
  if(cname!=NULL) mexPrintf("Calls the C-function: %s.\n\n",cname); 
}

/********************************************************************/
/* optoSelectFunction */
/********************************************************************/
optoFunctionPtr optoSelectFunction(char *optoCommandName){
  if(OPTO_VERBOSE>=4)mexPrintf("Called SelectFunction with optoCommandName: %s\n",optoCommandName);

  /* Time critical functions: */
  if(strcmp(optoCommandName,"DataGetLatest3D")==0)             return &optoDataGetLatest3D;
  if(strcmp(optoCommandName,"DataGetLatestTransforms")==0)     return &optoDataGetLatestTransforms;
  if(strcmp(optoCommandName,"DataReceiveLatest3D")==0)         return &optoDataReceiveLatest3D;
  if(strcmp(optoCommandName,"DataReceiveLatestTransforms")==0) return &optoDataReceiveLatestTransforms;
  if(strcmp(optoCommandName,"RequestLatest3D")==0)             return &optoRequestLatest3D;
  if(strcmp(optoCommandName,"RequestLatestTransforms")==0)     return &optoRequestLatestTransforms;
  if(strcmp(optoCommandName,"DataIsReady")==0)                 return &optoDataIsReady;
  if(strcmp(optoCommandName,"DataBufferWriteData")==0)         return &optoDataBufferWriteData;
  if(strcmp(optoCommandName,"DataBufferStop")==0)              return &optoDataBufferStop;
  if(strcmp(optoCommandName,"DataGetNext3D")==0)               return &optoDataGetNext3D;
  if(strcmp(optoCommandName,"DataGetNextTransforms")==0)       return &optoDataGetNextTransforms;
  if(strcmp(optoCommandName,"OptotrakActivateMarkers")==0)     return &optoOptotrakActivateMarkers;
  if(strcmp(optoCommandName,"RequestNext3D")==0)               return &optoRequestNext3D;
  if(strcmp(optoCommandName,"RequestNextTransforms")==0)       return &optoRequestNextTransforms;
  if(strcmp(optoCommandName,"OptotrakDeActivateMarkers")==0)   return &optoOptotrakDeActivateMarkers;
  /*  ... not so time critical functions:  */
  if(strcmp(optoCommandName,"TransputerDetermineSystemCfg")==0)return &optoTransputerDetermineSystemCfg;
  if(strcmp(optoCommandName,"TransputerInitializeSystem")==0)  return &optoTransputerInitializeSystem;
  if(strcmp(optoCommandName,"TransputerLoadSystem")==0)        return &optoTransputerLoadSystem;
  if(strcmp(optoCommandName,"TransputerShutdownSystem")==0)    return &optoTransputerShutdownSystem;
  if(strcmp(optoCommandName,"OptotrakChangeCameraFOR")==0)     return &optoOptotrakChangeCameraFOR;
  if(strcmp(optoCommandName,"OptotrakLoadCameraParameters")==0)return &optoOptotrakLoadCameraParameters;
  if(strcmp(optoCommandName,"OptotrakSetProcessingFlags")==0)  return &optoOptotrakSetProcessingFlags;
  if(strcmp(optoCommandName,"OptotrakSetupCollection")==0)     return &optoOptotrakSetupCollection;
  if(strcmp(optoCommandName,"DataBufferInitializeFile")==0)    return &optoDataBufferInitializeFile;
  if(strcmp(optoCommandName,"DataBufferSpoolData")==0)         return &optoDataBufferSpoolData;
  if(strcmp(optoCommandName,"DataBufferStart")==0)             return &optoDataBufferStart;
  if(strcmp(optoCommandName,"RigidBodyAddFromFile")==0)        return &optoRigidBodyAddFromFile;
  if(strcmp(optoCommandName,"RigidBodyChangeSettings")==0)     return &optoRigidBodyChangeSettings;
  if(strcmp(optoCommandName,"RigidBodyDelete")==0)             return &optoRigidBodyDelete;
  if(strcmp(optoCommandName,"FileConvert")==0)                 return &optoFileConvert;
  if(strcmp(optoCommandName,"Read3DFileToMatlab")==0)          return &optoRead3DFileToMatlab;
  if(strcmp(optoCommandName,"Read3DFileWithRigidsToMatlab")==0)return &optoRead3DFileWithRigidsToMatlab;
  if(strcmp(optoCommandName,"OptotrakPrintStatus")==0)         return &optoOptotrakPrintStatus;
  if(strcmp(optoCommandName,"PrintNDIFlags")==0)               return &optoPrintNDIFlags;
  /* todonew xxx */
/*   if(strcmp(optoCommandName,"")==0) return &opto; */

  /* Error if unknown command: */
  optoError("Unknown command: %s\n",optoCommandName);
  return NULL; /* never reached */
}

/********************************************************************/
/* The following commands are all wrapper for the NDI-Optotrak API: */
/********************************************************************/
void optoTransputerDetermineSystemCfg(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){ 
  char *pszLogFileName = NULL;
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"TransputerDetermineSystemCfg");
    mexPrintf("Determines the current configuration of the Optotrak Network   \n");
    mexPrintf("of transputers and writes the information to the default       \n");
    mexPrintf("network information file (.nif file), system.nif               \n");
    mexPrintf("                                                               \n");
    mexPrintf("Input variables:                                               \n");
    mexPrintf("  1. (OPTIONAL) The name of a log file that can                \n");
    mexPrintf("     be used to log status information, messages and errors    \n");
    mexPrintf("     occuring while determining and writing the network        \n");
    mexPrintf("     information file.                                         \n");
    mexPrintf("Output variables: NONE                                         \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs>1) optoError("Max. one input and no output arguments needed.");
  if(nrhs==1) pszLogFileName=optoGet1String(prhs[0],"Arg 1");
  /* Optotrak functionality: */
  if(OPTO_VERBOSE>=1)mexPrintf("Determining system configuration.\n"); 
  if(TransputerDetermineSystemCfg(pszLogFileName)) optoNDIerror();
  return;
} 

void optoTransputerInitializeSystem(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){ 
  unsigned int flag;
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"TransputerInitializeSystem");
    mexPrintf("Initializes the system for use with application programs.          \n");
    mexPrintf("                                                                   \n");
    mexPrintf("Input variables:                                                   \n");
    mexPrintf("   1. (OPTIONAL) Mode in which the application program is to be    \n");
    mexPrintf("       connected to the OPTOTRAK system                            \n");
    mexPrintf("                                                                   \n");
    mexPrintf("      Values:   OPTO_LOG_ERRORS_FLAG                               \n");
    mexPrintf("                OPTO_LOG_MESSAGES_FLAG                             \n");
    mexPrintf("                OPTO_SECONDARY_HOST_FLAG                           \n");
    mexPrintf("                                                                   \n");
    mexPrintf("   To pass two or more parameters to the routine, create a cell    \n");
    mexPrintf("   array.                                                          \n");
    mexPrintf("   E.g.: {'OPTO_LOG_ERRORS_FLAG'}                                  \n");
    mexPrintf("   or:   {'OPTO_LOG_ERRORS_FLAG';'OPTO_LOG_MESSAGES_FLAG'}         \n");
    mexPrintf("Output variables:                                                  \n");
    mexPrintf("      None.                                                        \n");
    mexPrintf("                                                                   \n");
    mexPrintf("Note: It is recommended to re-initialize your setup each time      \n");
    mexPrintf("      the OPTOTRAK is used, cables are changed, etc!               \n");
    mexPrintf("                                                                   \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs>1) optoError("Max. one input and no output arguments needed.");
  if(nrhs==1)
    flag=optoLong2UInt(optoGetFlags(prhs[0],"Arg 1"));
  else
    flag=0;
  /* Optotrak functionality: */
  if(OPTO_VERBOSE>=1)mexPrintf("Initializing transputer system.\n"); 
  if(TransputerInitializeSystem(flag)) optoNDIerror();
  return;
} 

void optoTransputerLoadSystem(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){ 
  char *pszNifFile = NULL;
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"TransputerLoadSystem");
    mexPrintf("Loads the OPTOTRAK transputers with the system code according to      \n");
    mexPrintf("the specified network information file (.nif)                         \n");
    mexPrintf("                                                                      \n");
    mexPrintf("Input variables:                                                      \n");      
    mexPrintf("   1. name of network information file without file extension         \n");
    mexPrintf("      (e.g., 'system' for system.nif)                                 \n");
    mexPrintf("Output variables:                                                     \n");
    mexPrintf("   None.                                                              \n");
    mexPrintf("                                                                      \n");
    mexPrintf("Note: Add a pause of ca. 1 sec after calling this function to allow   \n");
    mexPrintf("      enough time for the programs to download.                       \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs>1) optoError("Max. one input and no output arguments needed.");
  if(nrhs==1) pszNifFile=optoGet1String(prhs[0],"Arg 1");

  /* Optotrak functionality: */
  if(OPTO_VERBOSE>=1)mexPrintf("Loading transputer system.\n"); 
  if(TransputerLoadSystem(pszNifFile)) optoNDIerror();
  return;
} 

void optoTransputerShutdownSystem(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"TransputerShutdownSystem");
    mexPrintf("Informs the OPTOTRAK System that the application program will   \n");
    mexPrintf("no longer be communicating with it                              \n");
    mexPrintf("                                                                \n");
    mexPrintf("Input Variables:                                                \n");
    mexPrintf("  None                                                          \n");
    mexPrintf("Output variables:                                               \n");
    mexPrintf("  None                                                          \n");
    mexPrintf("                                                                \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=0) optoError("No input argument and no output argument allowed.");
  /* Optotrak functionality: */
  if(OPTO_VERBOSE>=1)mexPrintf("Shutting down transputer system.\n"); 
  if(TransputerShutdownSystem()) optoNDIerror();
}

void optoOptotrakActivateMarkers(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"OptotrakActivateMarkers");
    mexPrintf("Switch on optotrak markers.\n");
    mexPrintf("                                                                \n");
    mexPrintf("Input Variables:                                                \n");
    mexPrintf("  None                                                          \n");
    mexPrintf("Output variables:                                               \n");
    mexPrintf("  None                                                          \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=0) optoError("No input argument and no output argument allowed.");
  /* Optotrak functionality: */
  if(OPTO_VERBOSE>=1)mexPrintf("Switching on optotrak markers.\n"); 
  if(OptotrakActivateMarkers())optoNDIerror();
  return;
}

void optoOptotrakChangeCameraFOR(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){ 
  char       *pszInputCamFile,*pszAlignedCamFile;
  int         nNumPos,Ndum;
  Position3d  *pdtMeasuredPositions,*pdtAlignedPositions,*pdt3dErrors;
  float       fRmsError;
  const char  *FieldNames[] = {"PositionErrors","RmsError"};
  const int    nFields = sizeof(FieldNames)/sizeof(char *);

  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"OptotrakChangeCameraFOR");
    mexPrintf("todoURS  ... sample18.m \n");
    mexPrintf("Note: field 3dErrors not possible in Matlab!!! \n");
    return;
  }
  /* Gateway:  */
  if(nlhs>1 || nrhs!=1) optoError("One input and maximal one output argument needed.");
  pszInputCamFile     = optoGet1String(optoGet1Field(prhs[0],"InputCamFile"     ,"Arg 1"),"Arg 1/InputCamFile"   );
  nNumPos             = optoGet1Int   (optoGet1Field(prhs[0],"NumPositions"     ,"Arg 1"),"Arg 1/NumPositions"    );
  pdtMeasuredPositions= optoGetNPos3D (optoGet1Field(prhs[0],"MeasuredPositions","Arg 1"),"Arg 1/MeasuredPositions");
  pdtAlignedPositions = optoGetNPos3D (optoGet1Field(prhs[0],"AlignedPositions" ,"Arg 1"),"Arg 1/AlignedPositions");
  pszAlignedCamFile   = optoGet1String(optoGet1Field(prhs[0],"AlignedCamFile"   ,"Arg 1"),"Arg 1/AlignedCamFile"  );

  /* Test whether NumMarkers is specified correctly: */
  Ndum = mxGetN(optoGet1Field(prhs[0],"MeasuredPositions","Arg 1"));
  if(nNumPos != Ndum) optoError("NumMarkers not compatible with size of MeasuredPositions");
  Ndum = mxGetN(optoGet1Field(prhs[0],"AlignedPositions" ,"Arg 1"));
  if(nNumPos != Ndum) optoError("NumMarkers not compatible with size of AlignedPositions");

  if(OPTO_VERBOSE>=1)mexPrintf("Changing Optotrak camera frame of reference.\n"); 

  /* Optotrak functionality: */
  pdt3dErrors = (Position3d *)mxMalloc(nNumPos*sizeof(Position3d));
  if(OptotrakChangeCameraFOR(pszInputCamFile,nNumPos,
                             pdtAlignedPositions,pdtMeasuredPositions,
                             pszAlignedCamFile,pdt3dErrors,&fRmsError)) optoNDIerror();

  /* Write to output: */
  plhs[0] = mxCreateStructMatrix(1,1,nFields,FieldNames);
  optoSet1DoubleField  (plhs[0],"RmsError",fRmsError);
  optoSet3DMarkersField(plhs[0],"PositionErrors",nNumPos,pdt3dErrors);
  return;
} 

void optoOptotrakDeActivateMarkers(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"OptotrakDeActivateMarkers");
    mexPrintf("Switch off optotrak markers.\n");
    mexPrintf("                                                                \n");
    mexPrintf("Input Variables:                                                \n");
    mexPrintf("  None                                                          \n");
    mexPrintf("Output variables:                                               \n");
    mexPrintf("  None                                                          \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=0) optoError("No input argument and no output argument allowed.");
  /* Optotrak functionality: */
  if(OPTO_VERBOSE>=1)mexPrintf("Switching off optotrak markers.\n"); 
  if(OptotrakDeActivateMarkers())optoNDIerror();
  return;
}

void optoOptotrakLoadCameraParameters(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  char *pszCamFile;
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"OptotrakLoadCameraParameters");
    mexPrintf("Sends the contents of the specified camera paramter file          \n");
    mexPrintf("to the OPTOTRAK system                                            \n");
    mexPrintf("                                                                  \n");
    mexPrintf("Input variables:                                                  \n");
    mexPrintf("   1. Name of a camera paramter file.                             \n");
    mexPrintf("      By default set this to 'standard'.                          \n");
    mexPrintf("      This has to be specified without         \n");
    mexPrintf("      file extension (e.g. standard for standard.cam)             \n");
    mexPrintf("Output variables:                                                 \n");
    mexPrintf("      None                                                        \n");
    mexPrintf("                                                                  \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=1) optoError("One input and no output arguments needed.");
  pszCamFile=optoGet1String(prhs[0],"Arg 1");
  /* Optotrak functionality: */
  if(OPTO_VERBOSE>=1)mexPrintf("Loading camera parameters.\n"); 
  if(OptotrakLoadCameraParameters(pszCamFile)) optoNDIerror();
  return;
}

void optoOptotrakSetProcessingFlags(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){ 
  unsigned int flag;
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"OptotrakSetProcessingFlags");
    mexPrintf("Sets or clears bit flags that enable various processing options.    \n");
    mexPrintf("These flags can also be set in the initialization file, optotrak.ini.           \n");
    mexPrintf("                                                                                \n");
    mexPrintf("Input Variables:                                                                \n");
    mexPrintf("   1. Flags:                                                                    \n");
    mexPrintf("   Values: OPTO_LIB_POLL_REAL_DATA   controls blocking in real-time       \n");
    mexPrintf("                                        data retrieval routines           \n");
    mexPrintf("           OPTO_CONVERT_ON_HOST      causes 3D conversions to be done     \n");
    mexPrintf("                                        on the host computer instead      \n");
    mexPrintf("                                        of on the system                  \n");
    mexPrintf("           OPTO_RIGID_ON_HOST        causes rigid body 6D transformations \n");
    mexPrintf("                                        to be done on the host computer   \n");
    mexPrintf("                                        instead of on the system          \n");
    mexPrintf("           OPTO_USE_INTERNAL_NIF     causes the API to use internal net-  \n");
    mexPrintf("                                        work information instead of infor-\n");
    mexPrintf("                                        mation loaded from a .nif file    \n");
    mexPrintf("                                                                          \n");
    mexPrintf("   Note: You can set OPTO_RIGID_ON_HOST and not set OPTO_CONVERT_ON_HOST  \n");
    mexPrintf("         but it doesn't work the other way round!                         \n");
    mexPrintf("                                                                          \n");
    mexPrintf("   To pass two or more parameters to the routine, create a cell    \n");
    mexPrintf("   array.                                                          \n");
    mexPrintf("   E.g.: {'OPTO_CONVERT_ON_HOST'}                                  \n");
    mexPrintf("   or:   {'OPTO_CONVERT_ON_HOST';'OPTO_RIGID_ON_HOST'}             \n");
    mexPrintf("Output variables:                                                               \n");
    mexPrintf("    None                                                                        \n"); 
    mexPrintf("                                                                                \n"); 
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=1) optoError("One input and no output arguments needed.");
  flag = optoLong2UInt(optoGetFlags(prhs[0],"Arg 1"));
  /* Optotrak functionality: */
  if(OPTO_VERBOSE>=1)mexPrintf("Setting processing flags.\n"); 
  if(OptotrakSetProcessingFlags(flag)) optoNDIerror();
  return;
} 

void optoOptotrakSetupCollection(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){ 
  int   nMarkers;
  float fFrameFrequency,fMarkerFrequency;
  int   nThreshold,nMinimumGain,nStreamData;
  float fDutyCycle,fVoltage,fCollectionTime,fPreTriggerTime;
  int   nFlags;
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"OptotrakSetupCollection");
    mexPrintf("Configures the Optotrak collection using the specified parameters       \n");
    mexPrintf("                                                                        \n");
    mexPrintf("Input Variables:                                                         \n");
    mexPrintf(" 1. A struct containing the following fields:                           \n");
    mexPrintf("    (most fields are optional and a default value is choosen if they are\n");
    mexPrintf("     not specified)                                                     \n");
    mexPrintf("                                                                        \n");
    mexPrintf("    MANDATORY fields are:                                               \n");
    mexPrintf("                                                                        \n");
    mexPrintf("     NumMarkers        specifies the number of markers for which               \n");
    mexPrintf("                       data is collected. Bounds: [1,256]                      \n");
    mexPrintf("     FrameFrequency:   specifies the rate at which an entire frame             \n");
    mexPrintf("                        of data is generated. Bounds: [1,3000]                 \n");
    mexPrintf("                                                                        \n");
    mexPrintf("    OPTIONAL fields are:                                               \n");
    mexPrintf("                                                                        \n");
    mexPrintf("     MarkerFrequency:  specifies the frequency at which individual             \n");
    mexPrintf("                        markers are strobed. Bounds: [100,5000]                \n");
    mexPrintf("                        Default value: %f\n",OPTO_DEFAULT_MARKER_FREQUENCY);
    mexPrintf("     Threshold:        specifies the noise threshold under which all           \n");
    mexPrintf("                        sensor data is ignored when the centroid is            \n");
    mexPrintf("                       being calculated. Dependending on the mode in           \n");
    mexPrintf("                        which Optotrak is functioning this value is            \n");
    mexPrintf("                        used either as a dynamic or a static threshold         \n");
    mexPrintf("                        Bounds: [0,255]                                        \n");
    mexPrintf("                        Default value: %i\n",OPTO_DEFAULT_THRESHOLD);
    mexPrintf("     MinimumGain:      is the maximum amplification that can be applied to     \n");
    mexPrintf("                        the signal received by the sensors. Bounds: [0,255]    \n");
    mexPrintf("                        Default value: %i\n",OPTO_DEFAULT_MINIMUM_GAIN);
    mexPrintf("     StreamData:       indicates whether the Optotrak system is to either      \n");
    mexPrintf("                        send buffered data back by request only or             \n");
    mexPrintf("                        automatically send buffered data back once data        \n");
    mexPrintf("                        spooling is initiated.                                 \n");
    mexPrintf("                        Values:   0 send by request                            \n");
    mexPrintf("                                  1 send automatically                         \n");
    mexPrintf("                        Default value: %i\n",OPTO_DEFAULT_STREAM_DATA);
    mexPrintf("     DutyCycle:        is the percentage of time that a marker is              \n");
    mexPrintf("                        actually turned on during the marker period.           \n");
    mexPrintf("                        Bounds: [0.0,1.0]                                      \n");
    mexPrintf("                        Default value: %f\n",OPTO_DEFAULT_DUTY_CYCLE);
    mexPrintf("     Voltage:          is the voltage level used for strobing the markers.     \n");
    mexPrintf("                        Bounds: [5.0,12.0]                                     \n");
    mexPrintf("                        Default value: %f\n",OPTO_DEFAULT_STROBER_VOLTAGE);
    mexPrintf("     CollectionTime:   is the duration time, in seconds, for buffered          \n");
    mexPrintf("                        data collections. Bounds: [0,99999]                    \n");
    mexPrintf("                        Default value: %f\n",OPTO_DEFAULT_COLLECTION_TIME);
    mexPrintf("     PreTriggerTime:   Must be 0.                                              \n");
    mexPrintf("                        Default value: %f\n",OPTO_DEFAULT_PRE_TRIGGER_TIME);
    mexPrintf("     Flags:            indicates settings of low-level parameters for          \n");
    mexPrintf("                        the collections.                                       \n");
    mexPrintf("                       Default value: 0                                        \n");
    mexPrintf("                       Values which are often used (see the sample programs):  \n");
/*   todoURS: kannst Du hier alle Flags kurz uebernehmen und beschreiben? (S. 128).. */
    mexPrintf("                          OPTOTRAK_BUFFER_RAW_FLAG                             \n");
    mexPrintf("                          OPTOTRAK_GET_NEXT_FRAME_FLAG                         \n");
    mexPrintf("                       NOTE: If the Flags are set incorrectly, the Optotrak    \n");
    mexPrintf("                             will not complain, but you might get strange      \n");
    mexPrintf("                             behavior when buffering data.                     \n");
    mexPrintf("                             E.g., when buffering raw data, I forgot to set:   \n");
    mexPrintf("                                      OPTOTRAK_BUFFER_RAW_FLAG                 \n");
    mexPrintf("                             This resulted in WRONG values for the buffered    \n");
    mexPrintf("                             data (but not for the real time data)!!!          \n");
    mexPrintf("                                                                               \n");
    mexPrintf("    Note: use a delay of at least one second after the OptotrakSetupCollection \n");
    mexPrintf("          Routine to allow the system to adjust.                               \n");
    mexPrintf("Output variables:                                                                \n");
    mexPrintf("    None                                                                         \n");
    mexPrintf("                                                                                 \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=1) optoError("One input and no output arguments needed.");
  nMarkers          = optoGet1Int  (optoGet1Field(prhs[0],"NumMarkers"     ,"Arg 1"),"Arg 1/NumMarkers"     );
  fFrameFrequency   = optoGet1Float(optoGet1Field(prhs[0],"FrameFrequency" ,"Arg 1"),"Arg 1/FrameFrequency" );
  if(optoIs1Field(prhs[0],"MarkerFrequency","Arg 1"))
    fMarkerFrequency  = optoGet1Float(optoGet1Field(prhs[0],"MarkerFrequency","Arg 1"),"Arg 1/MarkerFrequency");
  else fMarkerFrequency = OPTO_DEFAULT_MARKER_FREQUENCY;
  if(optoIs1Field(prhs[0],"Threshold"      ,"Arg 1"))
    nThreshold        = optoGet1Int  (optoGet1Field(prhs[0],"Threshold"      ,"Arg 1"),"Arg 1/Threshold"      );
  else nThreshold = OPTO_DEFAULT_THRESHOLD;
  if(optoIs1Field(prhs[0],"MinimumGain"    ,"Arg 1"))
    nMinimumGain      = optoGet1Int  (optoGet1Field(prhs[0],"MinimumGain"    ,"Arg 1"),"Arg 1/MinimumGain"    );
  else nMinimumGain = OPTO_DEFAULT_MINIMUM_GAIN;
  if(optoIs1Field(prhs[0],"StreamData"     ,"Arg 1"))
    nStreamData       = optoGet1Int  (optoGet1Field(prhs[0],"StreamData"     ,"Arg 1"),"Arg 1/StreamData"     );
  else nStreamData = OPTO_DEFAULT_STREAM_DATA;
  if(optoIs1Field(prhs[0],"DutyCycle"      ,"Arg 1"))
    fDutyCycle        = optoGet1Float(optoGet1Field(prhs[0],"DutyCycle"      ,"Arg 1"),"Arg 1/DutyCycle"      );
  else fDutyCycle = OPTO_DEFAULT_DUTY_CYCLE;
  if(optoIs1Field(prhs[0],"Voltage"        ,"Arg 1"))
    fVoltage          = optoGet1Float(optoGet1Field(prhs[0],"Voltage"        ,"Arg 1"),"Arg 1/Voltage"        );
  else fVoltage = OPTO_DEFAULT_STROBER_VOLTAGE;
  if(optoIs1Field(prhs[0],"CollectionTime" ,"Arg 1"))
    fCollectionTime   = optoGet1Float(optoGet1Field(prhs[0],"CollectionTime" ,"Arg 1"),"Arg 1/CollectionTime" );
  else fCollectionTime = OPTO_DEFAULT_COLLECTION_TIME;
  if(optoIs1Field(prhs[0],"PreTriggerTime" ,"Arg 1"))
    fPreTriggerTime   = optoGet1Float(optoGet1Field(prhs[0],"PreTriggerTime" ,"Arg 1"),"Arg 1/PreTriggerTime" );
  else fPreTriggerTime = OPTO_DEFAULT_PRE_TRIGGER_TIME;
  if(optoIs1Field(prhs[0],"Flags","Arg 1"))
    nFlags=optoLong2Int(optoGetFlags(optoGet1Field(prhs[0],"Flags","Arg 1"),"Arg 1/Flags"));
  else nFlags=0;

  /* Optotrak functionality: */
  if(OPTO_VERBOSE>=1)mexPrintf("Setting up optotrak collection.\n"); 
  if(OptotrakSetupCollection(nMarkers,fFrameFrequency,fMarkerFrequency,nThreshold,
                             nMinimumGain,nStreamData,fDutyCycle,fVoltage,fCollectionTime,
                             fPreTriggerTime,nFlags)) optoNDIerror();
  return;
} 

void optoDataGetLatest3D(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  unsigned int uFrameNumber,uElements,uFlags,uNumMarkers;
  Position3d  *p3dFrame; 
  const char  *FieldNames[] = {"FrameNumber","NumMarkers","Flags","Markers"};
  const int    nFields = sizeof(FieldNames)/sizeof(char *);

  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"DataGetLatest3D");
    mexPrintf("Get latest 3D data. \n");
    mexPrintf("\n");
    mexPrintf("Input Variables:                                                         \n");
    mexPrintf("   1. number of markers (Note: this is different from the C-function!)   \n");
    mexPrintf("Output variables:                                                        \n");
    mexPrintf("   1. A struct containing all the info about the markers.                \n");
    return;
  }

  /* Gateway:  */
  if(nlhs>1 || nrhs!=1) optoError("One input and maximal one output argument needed.");
  uNumMarkers = optoGet1Int(prhs[0],"Arg 1");

  /* Get data from Optotrak: */
  p3dFrame = (Position3d *)mxMalloc(uNumMarkers*sizeof(Position3d));
  if(DataGetLatest3D(&uFrameNumber,&uElements,&uFlags,p3dFrame)) optoNDIerror();
  if(uNumMarkers!=uElements) optoError("Number of markers specified (%i) is not correct (correct is: %i).",
                                      uNumMarkers,uElements);

  if(OPTO_VERBOSE>=4){
    optoPrint3DHeader(uFrameNumber,uElements,uFlags);
    optoPrint3DMarkers(uNumMarkers,p3dFrame);
  }

  /* Write to output: */
  plhs[0] = mxCreateStructMatrix(1,1,nFields,FieldNames);
  optoSet1DoubleField (plhs[0],"FrameNumber",uFrameNumber);
  optoSet1DoubleField (plhs[0],"NumMarkers" ,uNumMarkers);
  optoSet1DoubleField (plhs[0],"Flags"      ,uFlags);
  optoSet3DMarkersField(plhs[0],"Markers",uNumMarkers,p3dFrame);
  return;
}

void optoDataGetLatestTransforms(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  unsigned int uFrameNumber,uElements,uFlags,uNumMarkers,uNumRigids;
  Position3d                 *p3dFrame; 
  struct OptotrakRigidStruct *pRBFrame;
  const char  *FieldNames[] = {"FrameNumber","NumMarkers","Flags","Markers","NumRigids","Rigids"};
  const int    nFields = sizeof(FieldNames)/sizeof(char *);

  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"DataGetLatestTransforms2");
    mexPrintf("Get latest transforms. \n");
    mexPrintf("\n");
    mexPrintf("Input Variables:                                                           \n");
    mexPrintf("   1. Number of markers      (Note: this is different from the C-function!)\n");
    mexPrintf("   2. Number of rigid bodies (Note: this is different from the C-function!)\n");
    mexPrintf("      Note: Make sure the number of rigid bodies is specified correctly!   \n");
    mexPrintf("     If it is smaller than the actual number of rigid bodies added to the  \n");
    mexPrintf("     system, the toolbox will crash.                                       \n");
    mexPrintf("     Sorry, there is no way to handle this case without speed impairments! \n");
    mexPrintf("Output variables:                                                          \n");
    mexPrintf("   1. A struct containing all the info about rigid bodies and markers.     \n");
    return;
  }

  /* Gateway:  */
  if(nlhs>=2 || nrhs!=2) optoError("Two input and maximal one output argument needed.");
  uNumMarkers = optoGet1Int(prhs[0],"Arg 1");
  uNumRigids  = optoGet1Int(prhs[1],"Arg 2");

  /* Get data from Optotrak: */
  p3dFrame = (Position3d *)mxMalloc(uNumMarkers*sizeof(Position3d));
  pRBFrame = (struct OptotrakRigidStruct *)mxMalloc(uNumRigids*sizeof(struct OptotrakRigidStruct));
  if(DataGetLatestTransforms2(&uFrameNumber,&uElements,&uFlags,pRBFrame,p3dFrame)) optoNDIerror();
  optoBadRBFrameFilter(uNumRigids,pRBFrame);
  if(OPTO_VERBOSE>=4){
    optoPrint3DHeader(uFrameNumber,uElements,uFlags);
    optoPrint3DMarkers(uNumMarkers,p3dFrame);
    optoPrintRBs(uNumRigids,pRBFrame);
  }
  if(uNumRigids!=uElements) optoError("Number of rigid bodies specified (%i) is not correct (correct is: %i).",
                                      uNumRigids,uElements);

  /* Write to output: */
  plhs[0] = mxCreateStructMatrix(1,1,nFields,FieldNames);
  optoSet1DoubleField  (plhs[0],"FrameNumber",uFrameNumber);
  optoSet1DoubleField  (plhs[0],"NumMarkers" ,uNumMarkers);
  optoSet1DoubleField  (plhs[0],"Flags"      ,uFlags);
  optoSet3DMarkersField(plhs[0],"Markers"    ,uNumMarkers,p3dFrame);
  optoSet1DoubleField  (plhs[0],"NumRigids"  ,uNumRigids);
  optoSetRBsField      (plhs[0],"Rigids"     ,uNumRigids,pRBFrame);
  return;
}

void optoDataGetNext3D(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  unsigned int uFrameNumber,uElements,uFlags,uNumMarkers;
  Position3d  *p3dFrame; 
  const char  *FieldNames[] = {"FrameNumber","NumMarkers","Flags","Markers"};
  const int    nFields = sizeof(FieldNames)/sizeof(char *);

  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"DataGetNext3D");
    mexPrintf("Get next 3D data. \n");
    mexPrintf("\n");
    mexPrintf("Input Variables:                                                         \n");
    mexPrintf("   1. number of markers (Note: this is different from the C-function!)   \n");
    mexPrintf("Output variables:                                                        \n");
    mexPrintf("   1. A struct containing all the info about the markers.                \n");
    return;
  }

  /* Gateway:  */
  if(nlhs>1 || nrhs!=1) optoError("One input and maximal one output argument needed.");
  uNumMarkers = optoGet1Int(prhs[0],"Arg 1");

  /* Get data from Optotrak: */
  p3dFrame = (Position3d *)mxMalloc(uNumMarkers*sizeof(Position3d));
  if(DataGetNext3D(&uFrameNumber,&uElements,&uFlags,p3dFrame)) optoNDIerror();
  if(uNumMarkers!=uElements) optoError("Number of markers specified (%i) is not correct (correct is: %i).",
                                      uNumMarkers,uElements);
  if(OPTO_VERBOSE>=4){
    optoPrint3DHeader(uFrameNumber,uElements,uFlags);
    optoPrint3DMarkers(uNumMarkers,p3dFrame);
  }

  /* Write to output: */
  plhs[0] = mxCreateStructMatrix(1,1,nFields,FieldNames);
  optoSet1DoubleField (plhs[0],"FrameNumber",uFrameNumber);
  optoSet1DoubleField (plhs[0],"NumMarkers" ,uNumMarkers);
  optoSet1DoubleField (plhs[0],"Flags"      ,uFlags);
  optoSet3DMarkersField(plhs[0],"Markers",uNumMarkers,p3dFrame);
  return;
}

void optoDataGetNextTransforms(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  unsigned int uFrameNumber,uElements,uFlags,uNumMarkers,uNumRigids;
  Position3d                 *p3dFrame; 
  struct OptotrakRigidStruct *pRBFrame;
  const char  *FieldNames[] = {"FrameNumber","NumMarkers","Flags","Markers","NumRigids","Rigids"};
  const int    nFields = sizeof(FieldNames)/sizeof(char *);

  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"DataGetNextTransforms2");
    mexPrintf("Get next transforms. \n");
    mexPrintf("\n");
    mexPrintf("Input Variables:                                                           \n");
    mexPrintf("   1. Number of markers      (Note: this is different from the C-function!)\n");
    mexPrintf("   2. Number of rigid bodies (Note: this is different from the C-function!)\n");
    mexPrintf("      Note: Make sure the number of rigid bodies is specified correctly!   \n");
    mexPrintf("     If it is smaller than the actual number of rigid bodies added to the  \n");
    mexPrintf("     system, the toolbox will crash.                                       \n");
    mexPrintf("     Sorry, there is no way to handle this case without speed impairments! \n");
    mexPrintf("Output variables:                                                          \n");
    mexPrintf("   1. A struct containing all the info about rigid bodies and markers.     \n");
    return;
  }

  /* Gateway:  */
  if(nlhs>=2 || nrhs!=2) optoError("Two input and maximal one output argument needed.");
  uNumMarkers = optoGet1Int(prhs[0],"Arg 1");
  uNumRigids  = optoGet1Int(prhs[1],"Arg 2");

  /* Get data from Optotrak: */
  p3dFrame = (Position3d *)mxMalloc(uNumMarkers*sizeof(Position3d));
  pRBFrame = (struct OptotrakRigidStruct *)mxMalloc(uNumRigids*sizeof(struct OptotrakRigidStruct));
  if(DataGetNextTransforms2(&uFrameNumber,&uElements,&uFlags,pRBFrame,p3dFrame)) optoNDIerror();
  optoBadRBFrameFilter(uNumRigids,pRBFrame);
  if(OPTO_VERBOSE>=4){
    optoPrint3DHeader(uFrameNumber,uElements,uFlags);
    optoPrint3DMarkers(uNumMarkers,p3dFrame);
    optoPrintRBs(uNumRigids,pRBFrame);
  }
  if(uNumRigids!=uElements) optoError("Number of rigid bodies specified (%i) is not correct (correct is: %i).",
                                      uNumRigids,uElements);

  /* Write to output: */
  plhs[0] = mxCreateStructMatrix(1,1,nFields,FieldNames);
  optoSet1DoubleField  (plhs[0],"FrameNumber",uFrameNumber);
  optoSet1DoubleField  (plhs[0],"NumMarkers" ,uNumMarkers);
  optoSet1DoubleField  (plhs[0],"Flags"      ,uFlags);
  optoSet3DMarkersField(plhs[0],"Markers"    ,uNumMarkers,p3dFrame);
  optoSet1DoubleField  (plhs[0],"NumRigids"  ,uNumRigids);
  optoSetRBsField      (plhs[0],"Rigids"     ,uNumRigids,pRBFrame);
  return;
}

void optoDataIsReady(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  int     *retValue;
  mxArray *retArray;


  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"DataIsReady");
    mexPrintf("todoURS   .\n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=1 || nrhs!=0) optoError("No input argument and one output argument allowed.");
  plhs[0]  = mxCreateDoubleMatrix(1,1,mxREAL);
  retValue = (int*)mxGetPr(plhs[0]);

  /* Optotrak functionality: */
  *retValue = DataIsReady();

  return;
}

void optoDataReceiveLatest3D(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  unsigned int uFrameNumber,uElements,uFlags,uNumMarkers;
  Position3d  *p3dFrame; 
  const char  *FieldNames[] = {"FrameNumber","NumMarkers","Flags","Markers"};
  const int    nFields = sizeof(FieldNames)/sizeof(char *);

  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"DataReceiveLatest3D");
    mexPrintf("Receive requested 3D data. \n");
    mexPrintf("\n");
    mexPrintf("Input Variables:                                                         \n");
    mexPrintf("   1. number of markers (Note: this is different from the C-function!)   \n");
    mexPrintf("Output variables:                                                        \n");
    mexPrintf("   1. A struct containing all the info about the markers.                \n");
    return;
  }

  /* Gateway:  */
  if(nlhs>1 || nrhs!=1) optoError("One input and maximal one output argument needed.");
  uNumMarkers = optoGet1Int(prhs[0],"Arg 1");

  /* Get data from Optotrak: */
  p3dFrame = (Position3d *)mxMalloc(uNumMarkers*sizeof(Position3d));
  if(DataReceiveLatest3D(&uFrameNumber,&uElements,&uFlags,p3dFrame)) optoNDIerror();
  if(uNumMarkers!=uElements) optoError("Number of markers specified (%i) is not correct (correct is: %i).",
                                      uNumMarkers,uElements);
  if(OPTO_VERBOSE>=4){
    optoPrint3DHeader(uFrameNumber,uElements,uFlags);
    optoPrint3DMarkers(uNumMarkers,p3dFrame);
  }

  /* Write to output: */
  plhs[0] = mxCreateStructMatrix(1,1,nFields,FieldNames);
  optoSet1DoubleField (plhs[0],"FrameNumber",uFrameNumber);
  optoSet1DoubleField (plhs[0],"NumMarkers"    ,uNumMarkers);
  optoSet1DoubleField (plhs[0],"Flags"      ,uFlags);
  optoSet3DMarkersField(plhs[0],"Markers",uNumMarkers,p3dFrame);
  return;
}

void optoDataReceiveLatestTransforms(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  unsigned int uFrameNumber,uElements,uFlags,uNumMarkers,uNumRigids;
  Position3d                 *p3dFrame; 
  struct OptotrakRigidStruct *pRBFrame;
  const char  *FieldNames[] = {"FrameNumber","NumMarkers","Flags","Markers","NumRigids","Rigids"};
  const int    nFields = sizeof(FieldNames)/sizeof(char *);

  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"DataReceiveLatestTransforms2");
    mexPrintf("Receive latest transforms. \n");
    mexPrintf("\n");
    mexPrintf("Input Variables:                                                           \n");
    mexPrintf("   1. Number of markers      (Note: this is different from the C-function!)\n");
    mexPrintf("   2. Number of rigid bodies (Note: this is different from the C-function!)\n");
    mexPrintf("      Note: Make sure the number of rigid bodies is specified correctly!   \n");
    mexPrintf("     If it is smaller than the actual number of rigid bodies added to the  \n");
    mexPrintf("     system, the toolbox will crash.                                       \n");
    mexPrintf("     Sorry, there is no way to handle this case without speed impairments! \n");
    mexPrintf("Output variables:                                                          \n");
    mexPrintf("   1. A struct containing all the info about rigid bodies and markers.     \n");
    return;
  }

  /* Gateway:  */
  if(nlhs>=2 || nrhs!=2) optoError("Two input and maximal one output argument needed.");
  uNumMarkers = optoGet1Int(prhs[0],"Arg 1");
  uNumRigids  = optoGet1Int(prhs[1],"Arg 2");

  /* Get data from Optotrak: */
  p3dFrame = (Position3d *)mxMalloc(uNumMarkers*sizeof(Position3d));
  pRBFrame = (struct OptotrakRigidStruct *)mxMalloc(uNumRigids*sizeof(struct OptotrakRigidStruct));
  if(DataReceiveLatestTransforms2(&uFrameNumber,&uElements,&uFlags,pRBFrame,p3dFrame)) optoNDIerror();
  optoBadRBFrameFilter(uNumRigids,pRBFrame);
  if(uNumRigids!=uElements) optoError("Number of rigid bodies specified (%i) is not correct (correct is: %i).",
                                      uNumRigids,uElements);
  if(OPTO_VERBOSE>=4){
    optoPrint3DHeader(uFrameNumber,uElements,uFlags);
    optoPrint3DMarkers(uNumMarkers,p3dFrame);
    optoPrintRBs(uNumRigids,pRBFrame);
  }

  /* Write to output: */
  plhs[0] = mxCreateStructMatrix(1,1,nFields,FieldNames);
  optoSet1DoubleField  (plhs[0],"FrameNumber",uFrameNumber);
  optoSet1DoubleField  (plhs[0],"NumMarkers" ,uNumMarkers);
  optoSet1DoubleField  (plhs[0],"Flags"      ,uFlags);
  optoSet3DMarkersField(plhs[0],"Markers"    ,uNumMarkers,p3dFrame);
  optoSet1DoubleField  (plhs[0],"NumRigids"  ,uNumRigids);
  optoSetRBsField      (plhs[0],"Rigids"     ,uNumRigids,pRBFrame);
  return;
}

void optoDataBufferStop(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"DataBufferStop");
    mexPrintf("todoURS   ...sample7.m\n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=0) optoError("No input argument and no output argument allowed.");
  /* Optotrak functionality: */
  if(OPTO_VERBOSE>=1)mexPrintf("Stop spooling of data to buffer.\n"); 
  if(DataBufferStop())optoNDIerror();
  return;
}

void optoDataBufferInitializeFile(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  unsigned int  uDataId;
  char         *pszFileName;
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"DataBufferInitializeFile");
    mexPrintf("Initializes a Northern Digital Floating Point format                                 \n");
    mexPrintf("file as a destination for buffered data                                              \n"); 
    mexPrintf("                                                                                     \n"); 
    mexPrintf("Input Variables:                                                                     \n"); 
    mexPrintf("   1. Identifies the device from which buffered data is to be spooled  \n"); 
    mexPrintf("      Value:     OPTOTRAK   specifies the OPTOTRAK data buffer        \n");
    mexPrintf("      (other values would specify ODAUs, which are not yet supported by  \n");
    mexPrintf("       the OptotrakToolbox).\n");
    /* mexPrintf("                  ODAU1      specifies the first ODAU's data buffer    \n");  */
    /* mexPrintf("                  ODAU2      specifies the second ODAU's data buffer   \n"); */
    /* mexPrintf("                  ODAU3      specifies the third ODAU's data buffer    \n"); */
    /* mexPrintf("                  ODAU4      specifies the fourth ODAU's data buffer   \n"); */
    mexPrintf("   2. FileName: Name of the file to which the data is spooled.                       \n"); 
    mexPrintf("Output variables:                                                                    \n"); 
    mexPrintf("    None                                                                             \n");
    return;
  }

  /* Gateway:  */
  if(nlhs!=0 || nrhs!=2) optoError("Two input arguments and no output argument needed.");
  uDataId=optoLong2UInt(optoGetFlags(prhs[0],"Arg 1"));
  pszFileName=optoGet1String(prhs[1],"Arg 2");

  /* Optotrak functionality: */
  if(DataBufferInitializeFile(uDataId,pszFileName)) optoNDIerror();
  return;
}

void optoDataBufferSpoolData(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){ 
  unsigned int uSpoolStatus = 0;
  double      *dSpoolStatus;
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"DataBufferSpoolData");
    mexPrintf("Spools an entire data buffer.                                                   \n"); 
    mexPrintf("                                                                                \n"); 
    mexPrintf("Input Variables:                                                                \n");
    mexPrintf("   None                                                                         \n");
    mexPrintf("Output variables:                                                               \n"); 
    mexPrintf("   1. SpoolStatus: indicates if there was a data buffer error               \n"); 
    mexPrintf("                   during the data spooling                                 \n"); 
    mexPrintf("                                                                                \n"); 
    /* mexPrintf("See also: DataBufferInitializeFile, DataBufferInitializeMem                     \n");  */
    return;
  }
  /* Gateway:  */
  if(nlhs!=1 || nrhs!=0) optoError("No input and one output arguments needed.");
  plhs[0]      = mxCreateDoubleMatrix(1,1,mxREAL);
  dSpoolStatus = mxGetPr(plhs[0]);

  /* Optotrak functionality: */
  if(OPTO_VERBOSE>=4)mexPrintf("DataBufferSpoolData.\n"); 
  if(DataBufferSpoolData(&uSpoolStatus)) optoNDIerror();

  *dSpoolStatus=uSpoolStatus;
  return;
} 

void optoDataBufferStart(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"DataBufferStart");
    mexPrintf("   DataBufferStart. \n");
    mexPrintf("todoURS. \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=0) optoError("No input arguments and no output argument allowed.");
  /* Optotrak functionality: */
  if(DataBufferStart()) optoNDIerror();
  return;
}

void optoDataBufferWriteData(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  double *pdRealtimeData,*pdSpoolComplete,*pdSpoolStatus,*pdFramesBuffered;
  unsigned int uRealtimeData     = 0;
  unsigned int uSpoolComplete    = 0;
  unsigned int uSpoolStatus      = 0;
  unsigned long ulFramesBuffered = 0;
  /* !!!ABSOLUTELY necessary!!! unsigned int do not seem to become initialized to 0!!! */
  /* AND: DataBufferWriteData DOES NOT SEEM TO ALWAYS ASSIGN A VALUE TO uSpoolComplete */
  /*      after a call !!! */

  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"DataBufferWriteData");
    mexPrintf("Receives data buffer data and writes them to the appropriate destination             \n"); 
    mexPrintf("                                                                                     \n");
    mexPrintf("Input Variables:                                                                     \n"); 
    mexPrintf("   None                                                                              \n");
    mexPrintf("Output variables:                                                                    \n");
    mexPrintf("    1. RealtimeData:     indicates if there is a frame of real-time              \n");
    mexPrintf("                           data to be received.                                  \n");
    mexPrintf("    2. SpoolComplete:    indicates if the data spooling  is complete.            \n");
    mexPrintf("    3. SpoolStatus:      indicates if there was a data buffer error              \n");
    mexPrintf("                           during the data spooling.                             \n");
    mexPrintf("    4. FramesBuffered:  indicates the number of frames of OPTOTRAK               \n");
    mexPrintf("                           data received since the latest call to                \n");
    mexPrintf("                           DataBufferStart, indlucing those                      \n");
    mexPrintf("                           received by the current call.                         \n");
    return;
  }

  /* Gateway:  */
  if(nlhs!=4 || nrhs!=0) optoError("No input argument and four output argument needed.");
  plhs[0]         = mxCreateDoubleMatrix(1,1,mxREAL);
  plhs[1]         = mxCreateDoubleMatrix(1,1,mxREAL);
  plhs[2]         = mxCreateDoubleMatrix(1,1,mxREAL);
  plhs[3]         = mxCreateDoubleMatrix(1,1,mxREAL);
  pdRealtimeData  = mxGetPr(plhs[0]);
  pdSpoolComplete = mxGetPr(plhs[1]);
  pdSpoolStatus   = mxGetPr(plhs[2]);
  pdFramesBuffered= mxGetPr(plhs[3]);

  /* Optotrak: */
  if(DataBufferWriteData(&uRealtimeData,&uSpoolComplete,
                         &uSpoolStatus,&ulFramesBuffered)) 
    optoNDIerror();

  /* Print data for debugging */
  if(OPTO_VERBOSE>=5){
    static unsigned int counter;
    counter++;
    mexPrintf("\noptoDataBufferWriteData: Called the %8u th time\n",counter);
    mexPrintf("   uRealtimeData do exist: %8u    \n",uRealtimeData);
    mexPrintf("   uSpoolComplete        : %8u    \n",uSpoolComplete);
    mexPrintf("   uSpoolStatus          : 0x%04x \n",uSpoolStatus);
    mexPrintf("   ulFramesBuffered      : %8u    \n",ulFramesBuffered);
  }
  /* Write data to output arrays: */
  *pdRealtimeData  = (double)uRealtimeData  ;
  *pdSpoolComplete = (double)uSpoolComplete ;
  *pdSpoolStatus   = (double)uSpoolStatus   ;
  *pdFramesBuffered= (double)ulFramesBuffered;
  return;
}

void optoRequestLatest3D(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"RequestLatest3D");
    mexPrintf("todoURS RequestLatest3D. \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=0) optoError("No input arguments and no output argument allowed.");
  /* Optotrak functionality: */
  if(RequestLatest3D()) optoNDIerror();
  return;
}

void optoRequestLatestTransforms(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"RequestLatestTransforms");
    mexPrintf("todoURS   \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=0) optoError("No input arguments and no output argument allowed.");
  /* Optotrak functionality: */
  if(RequestLatestTransforms()) optoNDIerror();
  return;
}

void optoRequestNext3D(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"RequestNext3D");
    mexPrintf("todoURS   RequestNext3D. \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=0) optoError("No input arguments and no output argument allowed.");
  /* Optotrak functionality: */
  if(RequestNext3D()) optoNDIerror();
  return;
}

void optoRequestNextTransforms(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"RequestNextTransforms");
    mexPrintf("todoURS   \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=0) optoError("No input arguments and no output argument allowed.");
  /* Optotrak functionality: */
  if(RequestNextTransforms()) optoNDIerror();
  return;
}

void optoRigidBodyAddFromFile(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  int nRigidBodyId,nStartMarker,nFlags;
  char *pszRigFile;

  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"RigidBodyAddFromFile");
    mexPrintf("todoURS   ... \n");
    mexPrintf("Flags:\n");
    mexPrintf("   OPTOTRAK_RETURN_QUATERN_FLAG ->  \n");
    mexPrintf("   OPTOTRAK_RETURN_MATRIX_FLAG ->  \n");
    mexPrintf("   OPTOTRAK_RETURN_EULER_FLAG ->  \n");
    mexPrintf("Comment on: nRigidBodyId      = nRigidBodyId-1;  \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=1) optoError("One input argument and no output arguments needed.");
  nRigidBodyId      = optoGet1Int   (optoGet1Field(prhs[0],"RigidBodyIndex"   ,"Arg 1"),"Arg 1/RigidBodyIndex");
  if(nRigidBodyId<1)optoError("RigidBodyIndex must not be smaller than 1");
  else nRigidBodyId--; /* Here, we go from Matlab-index to C-index !!! */
  nStartMarker      = optoGet1Int   (optoGet1Field(prhs[0],"StartMarker"      ,"Arg 1"),"Arg 1/StartMarker");
  pszRigFile        = optoGet1String(optoGet1Field(prhs[0],"RigFile"          ,"Arg 1"),"Arg 1/RigFile");
  if(optoIs1Field(prhs[0],"Flags","Arg 1"))
    nFlags=optoLong2Int(optoGetFlags(optoGet1Field(prhs[0],"Flags","Arg 1"),"Arg 1/Flags"));
  else
    nFlags=0;

  /* Optotrak functionality: */
  if(RigidBodyAddFromFile(nRigidBodyId,nStartMarker,pszRigFile,nFlags)) optoNDIerror();
  return;
}

void optoRigidBodyChangeSettings(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  int   nRigidBodyId,nMinMarkers,nMaxMarkersAngle,nFlags;
  float fMax3dError,fMaxSensorError,fMax3dRmsError,fMaxSensorRmsError;

  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"RigidBodyChangeSettings");
    mexPrintf("todoURS   ... \n");
    mexPrintf("Comment on: nRigidBodyId      = nRigidBodyId-1;  \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=1) optoError("One input and no output arguments needed.");
  nRigidBodyId      = optoGet1Int  (optoGet1Field(prhs[0],"RigidBodyIndex"   ,"Arg 1"),"Arg 1/RigidBodyIndex%todo"     );
  if(nRigidBodyId<1)optoError("RigidBodyIndex must not be smaller than 1");
  else nRigidBodyId--; /* Here, we go from Matlab-index to C-index !!! */
  nMinMarkers       = optoGet1Int  (optoGet1Field(prhs[0],"MinMarkers"       ,"Arg 1"),"Arg 1/MinMarkers"     );
  nMaxMarkersAngle  = optoGet1Int  (optoGet1Field(prhs[0],"MaxMarkersAngle"  ,"Arg 1"),"Arg 1/MaxMarkersAngle");
  fMax3dError       = optoGet1Float(optoGet1Field(prhs[0],"Max3dError"       ,"Arg 1"),"Arg 1/Max3dError"      );
  fMaxSensorError   = optoGet1Float(optoGet1Field(prhs[0],"MaxSensorError"   ,"Arg 1"),"Arg 1/MaxSensorError"  );
  fMax3dRmsError    = optoGet1Float(optoGet1Field(prhs[0],"Max3dRmsError"    ,"Arg 1"),"Arg 1/Max3dRmsError"   );
  fMaxSensorRmsError= optoGet1Float(optoGet1Field(prhs[0],"MaxSensorRmsError","Arg 1"),"Arg 1/MaxSensorRmsError");
  if(optoIs1Field(prhs[0],"Flags","Arg 1"))
    nFlags=optoLong2Int(optoGetFlags(optoGet1Field(prhs[0],"Flags","Arg 1"),"Arg 1/Flags"));
  else
    nFlags=0;

  /* Optotrak functionality: */
  if(RigidBodyChangeSettings(nRigidBodyId,nMinMarkers,nMaxMarkersAngle,
                             fMax3dError,fMaxSensorError,fMax3dRmsError,
                             fMaxSensorRmsError,nFlags)) optoNDIerror();
  return;
}

void optoRigidBodyDelete(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  int   nRigidBodyId;

  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"RigidBodyDelete");
    mexPrintf("todoURS   ... \n");
    mexPrintf("Comment on: nRigidBodyId      = nRigidBodyId-1;  \n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=1) optoError("One input and no output arguments needed.");
  nRigidBodyId = optoGet1Int(prhs[0],"Arg 1");
  if(nRigidBodyId<1)optoError("RigidBodyIndex must not be smaller than 1");
  else nRigidBodyId--; /* Here, we go from Matlab-index to C-index !!! */

  /* Optotrak functionality: */
  if(RigidBodyDelete(nRigidBodyId)) optoNDIerror();
  return;
}

void optoFileConvert(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  char *pszInputFilename,*pszOutputFilename;
  unsigned int uFileType = 0;
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,"FileConvert");
    mexPrintf("Converts raw data from the specified input file to the appropriate type and writes   \n");
    mexPrintf("the converted data to the specified output file. \n");
    mexPrintf("                                                                                     \n");
    mexPrintf("Input Variables:                                                                     \n");
    mexPrintf("   1. InputFilename: Name of the input file containing the raw data to be converted. \n");
    mexPrintf("   2. OutputFilename: Name of the output file to write the converted data to.        \n");
    mexPrintf("   3. FileType: The type of raw data that is being converted.   \n");
    mexPrintf("      Values: OPTOTRAK_RAW   converting OPTOTRAK raw data into 3D data.              \n");
    mexPrintf("      (other values would specify ODAU data, which are not yet supported by  \n");
    mexPrintf("       the OptotrakToolbox).\n");
    /* mexPrintf("              ANALOG_RAW     converting ODAU raw data to voltages                  \n"); */
    mexPrintf("                                                                                     \n");
    mexPrintf("Note: Do not invoke this routine if the OPTOTRAK system is currently spooling data!  \n");
    return;
  }

  /* Gateway:  */
  if(nlhs!=0 || nrhs!=3) optoError("Three input arguments and no output argument needed.");
  pszInputFilename =optoGet1String(prhs[0],"Arg 1");
  pszOutputFilename=optoGet1String(prhs[1],"Arg 2");
  uFileType        =optoLong2UInt(optoGetFlags(prhs[2],"Arg 3"));

  /* Optotrak functionality: */
  if(FileConvert(pszInputFilename,pszOutputFilename,uFileType)) optoNDIerror();
  return;
}

/* todonew xxx */

/********************************************************************/
/* Utitlity functions, not contained in NDI-Optotrak API:           */
/********************************************************************/
void optoRead3DFileToMatlab(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  unsigned int   uFileId      = OPTO_DEFAULT_FILE_ID;
  char          *pszFilename  = NULL;
  unsigned int   uFileMode    = OPEN_READ;
  int            nItems       = 0;
  int            nSubItems    = 0;
  long int       lnFrames     = 0;
  float          fFrequency   = 0.0;
  double        *pdFrequency  = NULL;
  char           pszComments[NDFP_USER_COMMENT_LENGTH];
  void          *pFileHeader  = NULL;
  float         *FramePtr     = NULL;
  const char    *FieldNames[] = {"NumMarkers","NumFrames","Frequency","Comments","Time","Markers"};
  const int      nFields = sizeof(FieldNames)/sizeof(char *);
  mxArray       *Time_val     = NULL;
  mxArray       *Items_val    = NULL;
  mxArray      **Items_arrays = NULL;
  long           i,k,l;

  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,NULL);
    mexPrintf("todoURS.\n");
    mexPrintf("optoReadFileToMatlab: Read Optotrak floating point file into Matlab.\n");
    mexPrintf("(Using the routine FileRead. That is: This routine only reads floating point files).\n");
    mexPrintf("Right parameter: \n");
    mexPrintf(" - pszFilename (name of input file, a char string).\n");
    mexPrintf("Left parameter: \n");
    return;
  }

  /* Gateway:  */
  if(nlhs>1 || nrhs!=1) optoError("One input and maximal one output arguments are needed.");
  pszFilename = optoGet1String(prhs[0],"Arg 1");

  /* Open InFile */
  FileClose(uFileId);
 if(FileOpen(pszFilename,uFileId,uFileMode,&nItems,&nSubItems,&lnFrames, 
             &fFrequency,pszComments,&pFileHeader))optoNDIerror(); 

  if(OPTO_VERBOSE>=1){
    mexPrintf("Header of Optotrak-file %s is:\n",pszFilename);
    mexPrintf("   nItems     %i\n",nItems      );
    mexPrintf("   nSubItems %i\n",nSubItems  );
    mexPrintf("   nFrames     %i\n",(int)lnFrames);
    mexPrintf("   Frequency   %f\n",fFrequency   );
    mexPrintf("   Comments    %s\n",pszComments  );
  }

  /* Write header to output: */
  plhs[0] = mxCreateStructMatrix(1,1,nFields,FieldNames);
  optoSet1DoubleField(plhs[0],"NumMarkers"  ,nItems);
/*todo   optoSet1DoubleField(plhs[0],"nSubItems",nSubItems); */
  optoSet1DoubleField(plhs[0],"NumFrames"  ,lnFrames);
  optoSet1DoubleField(plhs[0],"Frequency",fFrequency);
  optoSet1StringField(plhs[0],"Comments" ,pszComments);

  /* Create "Time" field:  */
  Time_val = mxCreateDoubleMatrix(1,lnFrames,mxREAL);
  for(i=0;i<lnFrames;i++){ 
    mxGetPr(Time_val)[i]=(float)i*1000.0/fFrequency; /*time is in msec*/
  } 
  mxSetField(plhs[0],0,"Time",Time_val);

  /* Read frames and write to "Markers" field (which is a cell array):  */
  Items_val    = mxCreateCellMatrix(nItems,1);
  Items_arrays = (mxArray**)mxMalloc(nItems*sizeof(mxArray*));
  for(k=0;k<nItems;k++){
    Items_arrays[k] = mxCreateDoubleMatrix(nSubItems,lnFrames,mxREAL);
  }
  FramePtr = (float*)mxMalloc(nItems*nSubItems*sizeof(float));
  for(i=0;i<lnFrames;i++){ 
    if(FileRead(uFileId,i,1,FramePtr))optoNDIerror();
    for(k=0;k<nItems;k++){
      for(l=0;l<nSubItems;l++){
        mxGetPr(Items_arrays[k])[nSubItems*i+l]=optoBadFloatFilter(FramePtr[nSubItems*k+l]);
      }
    }
  } 
  for(k=0;k<nItems;k++){
    mxSetCell(Items_val,k,Items_arrays[k]);
  }
  mxSetField(plhs[0],0,"Markers",Items_val);

  /* Close InFile */
  FileClose(uFileId);
  return;
}

void optoRead3DFileWithRigidsToMatlab(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  unsigned int   uFileId      = OPTO_DEFAULT_FILE_ID;
  char          *pszFilename  = NULL;
  unsigned int   uFileMode    = OPEN_READ;
  int            nItems       = 0;
  int            nSubItems    = 0;
  unsigned int   uNumRigids   = 0;
  long int       lnFrames     = 0;
  float          fFrequency   = 0.0;
  double        *pdFrequency  = NULL;
  char           pszComments[NDFP_USER_COMMENT_LENGTH];
  void          *pFileHeader  = NULL;
  Position3d    *p3dFrame     = NULL; 
  const char    *FieldNames[] = {"NumMarkers","NumFrames",
                                 "Frequency","Comments","Time","Markers",
                                 "NumRigids","Rigids"};
  const int    nFields = sizeof(FieldNames)/sizeof(char *);
  mxArray       *Time_val     = NULL;
  mxArray       *Items_val    = NULL;
  mxArray      **Items_arrays = NULL;
  long           i,k,l;
  /* for sample data: */
  unsigned int uFrameNumber,uElements,uFlags;
  struct OptotrakRigidStruct *pRBFrame = NULL;
  /* for rigid body output:  */
  mxArray **RBStructs, *RBCell, *Dummy;
  const char *EulerFieldNames[]     ={"QuaternionError","IterativeError","Trans","RotEuler"};
  const char *MatrixFieldNames[]    ={"QuaternionError","IterativeError","Trans","RotMatrix"};
  const char *QuaternionFieldNames[]={"QuaternionError","IterativeError","Trans","RotQuaternion"};
  const int   nRBFields = sizeof(EulerFieldNames)/sizeof(char *);
  unsigned int u = 0;
  mxArray  
    **QuatErrorArray,**IterativeErrorArray,**TransArray,
    **RotEulerArray,**RotMatrixArray,**RotQuaternionArray;
  int RotMatrixDims[3];

  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,NULL);
    mexPrintf("todoURS optoReadFileToMatlab: Read Optotrak floating point file into Matlab.\n");
    mexPrintf("(Using the routine FileRead. That is: This routine only reads floating point files).\n");
    mexPrintf("NOTE: everything must be switched on in exactly the same way as when the data were collected: markers, collection etc.!!! \n");
    mexPrintf("Right parameter: \n");
    mexPrintf(" - pszFilename (name of input file, a char string).\n");
    mexPrintf("Left parameter: \n");
    return;
  }

  /* Gateway:  */
  if(nlhs>1 || nrhs!=2) optoError("Two input and maximal one output arguments are needed.");
  pszFilename = optoGet1String(prhs[0],"Arg 1");
  uNumRigids  =    optoGet1Int(prhs[1],"Arg 2");

  /* Open InFile */
  if(FileOpen(pszFilename,uFileId,uFileMode,&nItems,&nSubItems,&lnFrames,
              &fFrequency,pszComments,&pFileHeader))optoNDIerror();

  if(OPTO_VERBOSE>=1){
    mexPrintf("Header of Optotrak-file %s is:\n",pszFilename);
    mexPrintf("   nItems     %i\n",nItems      );
    mexPrintf("   nSubItems %i\n",nSubItems  );
    mexPrintf("   nFrames     %i\n",(int)lnFrames);
    mexPrintf("   Frequency   %f\n",fFrequency   );
    mexPrintf("   Comments    %s\n",pszComments  );
  }

  /* Write header to output: */
  plhs[0] = mxCreateStructMatrix(1,1,nFields,FieldNames);
  optoSet1DoubleField(plhs[0],"NumMarkers"  ,nItems);
/*todo   optoSet1DoubleField(plhs[0],"nSubItems",nSubItems); */
  optoSet1DoubleField(plhs[0],"NumFrames"  ,lnFrames);
  optoSet1DoubleField(plhs[0],"Frequency",fFrequency);
  optoSet1StringField(plhs[0],"Comments" ,pszComments);
  optoSet1DoubleField(plhs[0],"NumRigids",uNumRigids);

  /* Create "Time" field:  */
  Time_val = mxCreateDoubleMatrix(1,lnFrames,mxREAL);
  for(i=0;i<lnFrames;i++){ 
    mxGetPr(Time_val)[i]=(float)i*1000.0/fFrequency; /*time is in msec*/
  } 
  mxSetField(plhs[0],0,"Time",Time_val);

  /* Read frames and write to "Markers" field (which is a cell array):  */
  Items_val    = mxCreateCellMatrix(nItems,1);
  Items_arrays = (mxArray**)mxMalloc(nItems*sizeof(mxArray*));
  for(k=0;k<nItems;k++){
    Items_arrays[k] = mxCreateDoubleMatrix(nSubItems,lnFrames,mxREAL);
  }
  p3dFrame = (Position3d*)mxMalloc(nItems*sizeof(Position3d));
  for(i=0;i<lnFrames;i++){ 
    if(FileRead(uFileId,i,1,p3dFrame))optoNDIerror();
    for(k=0;k<nItems;k++){
      mxGetPr(Items_arrays[k])[3*i+0]=optoBadFloatFilter(p3dFrame[k].x);
      mxGetPr(Items_arrays[k])[3*i+1]=optoBadFloatFilter(p3dFrame[k].y);
      mxGetPr(Items_arrays[k])[3*i+2]=optoBadFloatFilter(p3dFrame[k].z);
    }
  } 
  for(k=0;k<nItems;k++){
    mxSetCell(Items_val,k,Items_arrays[k]);
  }
  mxSetField(plhs[0],0,"Markers",Items_val);

  /* Close InFile */
  FileClose(uFileId);

  /* Open InFile AGAIN (for Rigid bodies...) todo: make in one run ???*/
  if(FileOpen(pszFilename,uFileId,uFileMode,&nItems,&nSubItems,&lnFrames,
              &fFrequency,pszComments,&pFileHeader))optoNDIerror();

  /* Prepare one struct for each rigid body: */
  RBStructs = (mxArray**)mxMalloc(uNumRigids*sizeof(mxArray*));
  QuatErrorArray      = (mxArray**)mxMalloc(uNumRigids*sizeof(mxArray*));
  IterativeErrorArray = (mxArray**)mxMalloc(uNumRigids*sizeof(mxArray*));
  TransArray          = (mxArray**)mxMalloc(uNumRigids*sizeof(mxArray*));
  RotEulerArray       = (mxArray**)mxMalloc(uNumRigids*sizeof(mxArray*));
  RotMatrixArray      = (mxArray**)mxMalloc(uNumRigids*sizeof(mxArray*));
  RotQuaternionArray  = (mxArray**)mxMalloc(uNumRigids*sizeof(mxArray*));

  /* Read frames and write to "Rigids" fields (which is a cell array):  */
  pRBFrame = (struct OptotrakRigidStruct *)mxMalloc(uNumRigids*sizeof(struct OptotrakRigidStruct));
  for(i=0;i<lnFrames;i++){ 
    if(FileRead(uFileId,i,1,p3dFrame))optoNDIerror();
    if(OptotrakConvertTransforms(&uElements,pRBFrame,p3dFrame))optoNDIerror();
    if(uNumRigids!=uElements) optoError("Number of rigid bodies specified (%i) is not correct (correct is: %i).",
                                        uNumRigids,uElements);
    optoBadRBFrameFilter(uNumRigids,pRBFrame);

    for(u=0;u<uNumRigids;u++){
      uFlags=pRBFrame[u].flags;
      if(i==0){
        /* Create struct for this RB: */
        if(uFlags & OPTOTRAK_RETURN_EULER_FLAG ) 
          RBStructs[u] = mxCreateStructMatrix(1,1,nRBFields,EulerFieldNames);
        else if(uFlags & OPTOTRAK_RETURN_MATRIX_FLAG ) 
          RBStructs[u] = mxCreateStructMatrix(1,1,nRBFields,MatrixFieldNames);
        else if(uFlags & OPTOTRAK_RETURN_QUATERN_FLAG )
          RBStructs[u] = mxCreateStructMatrix(1,1,nRBFields,QuaternionFieldNames);
        else optoError("Could not determine type of RB transformation");
        /* Create arrays for fields which contain more than one value: */
        QuatErrorArray[u]     =mxCreateDoubleMatrix(1,lnFrames,mxREAL);
        IterativeErrorArray[u]=mxCreateDoubleMatrix(1,lnFrames,mxREAL);
        TransArray[u]         =mxCreateDoubleMatrix(3,lnFrames,mxREAL);
        RotEulerArray[u]      =mxCreateDoubleMatrix(3,lnFrames,mxREAL);
        RotQuaternionArray[u] =mxCreateDoubleMatrix(4,lnFrames,mxREAL);
        RotMatrixDims[0]=3;
        RotMatrixDims[1]=3;
        RotMatrixDims[2]=lnFrames;
        RotMatrixArray[u]=mxCreateNumericArray(3,RotMatrixDims,mxDOUBLE_CLASS,mxREAL);
      }
      mxGetPr(QuatErrorArray[u])[i]     =pRBFrame[u].QuaternionError;
      mxGetPr(IterativeErrorArray[u])[i]=pRBFrame[u].IterativeError;
      if(uFlags & OPTOTRAK_RETURN_EULER_FLAG ){
        mxGetPr(TransArray[u])[3*i+0]=optoBadFloatFilter(pRBFrame[u].transformation.euler.translation.x);
        mxGetPr(TransArray[u])[3*i+1]=optoBadFloatFilter(pRBFrame[u].transformation.euler.translation.y);
        mxGetPr(TransArray[u])[3*i+2]=optoBadFloatFilter(pRBFrame[u].transformation.euler.translation.z);
        mxGetPr(RotEulerArray[u])[3*i+0]=optoBadFloatFilter(pRBFrame[u].transformation.euler.rotation.yaw);
        mxGetPr(RotEulerArray[u])[3*i+1]=optoBadFloatFilter(pRBFrame[u].transformation.euler.rotation.pitch);
        mxGetPr(RotEulerArray[u])[3*i+2]=optoBadFloatFilter(pRBFrame[u].transformation.euler.rotation.roll);
      } 
      else if (uFlags & OPTOTRAK_RETURN_MATRIX_FLAG ){
        mxGetPr(TransArray[u])[3*i+0]=optoBadFloatFilter(pRBFrame[u].transformation.rotation.translation.x);
        mxGetPr(TransArray[u])[3*i+1]=optoBadFloatFilter(pRBFrame[u].transformation.rotation.translation.y);
        mxGetPr(TransArray[u])[3*i+2]=optoBadFloatFilter(pRBFrame[u].transformation.rotation.translation.z);
        mxGetPr(RotMatrixArray[u])[9*i+0]=optoBadFloatFilter(pRBFrame[u].transformation.rotation.matrix[0][0]);
        mxGetPr(RotMatrixArray[u])[9*i+1]=optoBadFloatFilter(pRBFrame[u].transformation.rotation.matrix[1][0]);
        mxGetPr(RotMatrixArray[u])[9*i+2]=optoBadFloatFilter(pRBFrame[u].transformation.rotation.matrix[2][0]);
        mxGetPr(RotMatrixArray[u])[9*i+3]=optoBadFloatFilter(pRBFrame[u].transformation.rotation.matrix[0][1]);
        mxGetPr(RotMatrixArray[u])[9*i+4]=optoBadFloatFilter(pRBFrame[u].transformation.rotation.matrix[1][1]);
        mxGetPr(RotMatrixArray[u])[9*i+5]=optoBadFloatFilter(pRBFrame[u].transformation.rotation.matrix[2][1]);
        mxGetPr(RotMatrixArray[u])[9*i+6]=optoBadFloatFilter(pRBFrame[u].transformation.rotation.matrix[0][2]);
        mxGetPr(RotMatrixArray[u])[9*i+7]=optoBadFloatFilter(pRBFrame[u].transformation.rotation.matrix[1][2]);
        mxGetPr(RotMatrixArray[u])[9*i+8]=optoBadFloatFilter(pRBFrame[u].transformation.rotation.matrix[2][2]);
      }
      else if (uFlags & OPTOTRAK_RETURN_QUATERN_FLAG ){
        mxGetPr(TransArray[u])[3*i+0]=optoBadFloatFilter(pRBFrame[u].transformation.quaternion.translation.x);
        mxGetPr(TransArray[u])[3*i+1]=optoBadFloatFilter(pRBFrame[u].transformation.quaternion.translation.y);
        mxGetPr(TransArray[u])[3*i+2]=optoBadFloatFilter(pRBFrame[u].transformation.quaternion.translation.z);
        mxGetPr(RotQuaternionArray[u])[4*i+0]=optoBadFloatFilter(pRBFrame[u].transformation.quaternion.rotation.q0);
        mxGetPr(RotQuaternionArray[u])[4*i+1]=optoBadFloatFilter(pRBFrame[u].transformation.quaternion.rotation.qx);
        mxGetPr(RotQuaternionArray[u])[4*i+2]=optoBadFloatFilter(pRBFrame[u].transformation.quaternion.rotation.qy);
        mxGetPr(RotQuaternionArray[u])[4*i+3]=optoBadFloatFilter(pRBFrame[u].transformation.quaternion.rotation.qz);
      }
      else optoError("Could not determine type of RB transformation");
    }
  }

  /* Add fields which contain more than one value to RBstructs: */
  for(u=0;u<uNumRigids;u++){
    uFlags=pRBFrame[u].flags;
    mxSetField(RBStructs[u],0,"QuaternionError",QuatErrorArray[u]);
    mxSetField(RBStructs[u],0,"IterativeError" ,IterativeErrorArray[u]);
    mxSetField(RBStructs[u],0,"Trans"          ,TransArray[u]);
    if(uFlags & OPTOTRAK_RETURN_EULER_FLAG){
      mxSetField(RBStructs[u],0,"RotEuler",RotEulerArray[u]);
    }
    else if(uFlags & OPTOTRAK_RETURN_MATRIX_FLAG ){
      mxSetField(RBStructs[u],0,"RotMatrix",RotMatrixArray[u]);
    }
    else if (uFlags & OPTOTRAK_RETURN_QUATERN_FLAG ){
      mxSetField(RBStructs[u],0,"RotQuaternion",RotQuaternionArray[u]);
    }
    else optoError("Could not determine type of RB transformation");
  }

  /* Collect all RBstructs in one cell array:: */
  RBCell = mxCreateCellMatrix(uNumRigids,1);
  for(u=0;u<uNumRigids;u++){
    mxSetCell(RBCell,u,RBStructs[u]);
  }
  mxSetField(plhs[0],0,"Rigids",RBCell);

  /* Close InFile */
  FileClose(uFileId);
  return;
}

void optoOptotrakPrintStatus(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){ 
  int nFlags,nNumSensors,nNumOdaus,nRigidBodies,nMarkers,nThreshold,nMinimumGain,nStreamData;
  float fVoltage,fDutyCycle,fCollectionTime,fPreTriggerTime,fFrameFrequency,fMarkerFrequency;
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,NULL);
    mexPrintf("todoURS Print Optotrak status to Matlab shell.\n");
    return;
  }
  /* Gateway:  */
  if(nlhs!=0 || nrhs!=0) optoError("No input argument and no output argument allowed.");
  /* Print Optotrak status to Matlab shell: */
  if(OptotrakGetStatus(&nNumSensors,&nNumOdaus,&nRigidBodies,&nMarkers,&fFrameFrequency,&fMarkerFrequency,
                       &nThreshold,&nMinimumGain,&nStreamData,&fDutyCycle,&fVoltage,&fCollectionTime,
                       &fPreTriggerTime,&nFlags)) optoNDIerror();
  mexPrintf("\n   Optotrak Status Information:\n");
  mexPrintf("   Sensors in system       :%20i  \n", nNumSensors );
  mexPrintf("   ODAUs in system         :%20i  \n", nNumOdaus );
  mexPrintf("   Rigid Bodies in system  :%20i  \n", nRigidBodies );
  mexPrintf("   Markers in system       :%20i  \n", nMarkers );
  mexPrintf("   Frame Frequency         :%20.3f\n", fFrameFrequency );   
  mexPrintf("   Marker Frequency        :%20.3f\n", fMarkerFrequency );  
  mexPrintf("   Threshold               :%20i  \n", nThreshold );        
  mexPrintf("   Minimum Gain            :%20i  \n", nMinimumGain );      
  mexPrintf("   Stream Data             :%20i  \n", nStreamData );       
  mexPrintf("   Duty Cycle              :%20.3f\n", fDutyCycle );        
  mexPrintf("   Voltage                 :%20.3f\n", fVoltage );          
  mexPrintf("   Collection Time         :%20.3f\n", fCollectionTime );   
  mexPrintf("   Pre Trigger Time        :%20.3f\n", fPreTriggerTime );   
  mexPrintf("   Flags                   :          0x%x\n", nFlags );            
}

void optoPrintNDIFlags(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]){
  char         *type =NULL;
  long         lflags=0;
  int          nflags=0;
  unsigned int uflags=0;
  /* Help: */
  if(hlp){
    optoStandardHelpHeader(name,NULL);
    mexPrintf("Print value of NDI-flags to Matlab shell. This is mainly for testing purposes.\n");
    mexPrintf("Input Variables:                                                              \n");
    mexPrintf("   1: C-data-type of flag ('long', 'int', or 'uint')\n");
    mexPrintf("   2: Flags  (as a cell array of strings)\n");
    mexPrintf("Output variables: None                                                        \n");
    return;
  }
  /* Gateway & printing:  */
  if(nlhs!=0 || nrhs!=2) optoError("Two input arguments and no output argument needed.");
  type = optoGet1String(prhs[0],"Arg 1");
  if(strcmp(type,"long")==0){
    lflags=optoGetFlags(prhs[1],"Arg 2");
    mexPrintf("Value of NDI flags (as long): 0x%x\n",lflags);
    return;
  }
  if(strcmp(type,"int")==0){
    nflags=optoLong2Int(optoGetFlags(prhs[1],"Arg 2"));
    mexPrintf("Value of NDI flags (as int): 0x%x\n",nflags);
    return;
  }
  if(strcmp(type,"uint")==0){
    uflags=optoLong2UInt(optoGetFlags(prhs[1],"Arg 2"));
    mexPrintf("Value of NDI flags (as uint): 0x%x\n",uflags);
    return;
  }
  optoError("Type of flags not valid");
}
/********************************************************************/
