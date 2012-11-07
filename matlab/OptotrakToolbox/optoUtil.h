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
#ifndef OPTOUTIL_H
#define OPTOUTIL_H

#include <mex.h>

/* General constants defined for OptotrakToolbox: */
#define OPTO_VERBOSE                  0  /*0=not verbose ... 5=max. verbose */
#define OPTOTOOLBOX_VERSION        0.73  /*Version of this software */
#define OPTO_COMMAND_NAME_LENGTH   1024  /*max. length of commands passed to: optoSelectFunction */
#define OPTO_ERROR_MSG_LENGTH      1024  /*max. length of error messages of optoUtil */

/* Constants defined by NDFP (Northern Digital Floating Point) format: */
#define NDFP_USER_COMMENT_LENGTH   60   /*size of user-comment */

/* Error strings defined for OptotrakToolbox: */
#define RB_UNDETERMINED_TRANS  "Undetermined Transform"
#define RB_MARKER_SPREAD_ERROR "Marker spread error"
#define RB_NO_ERROR            "Transformation successful"

/* Default values for Optotrak collection: */
/* (cf. the API manual at OptotracSetupCollectionFromFile) */
#define OPTO_DEFAULT_MARKER_FREQUENCY  (float)2500.0 /* Marker frequency for marker maximum on-time. */
#define OPTO_DEFAULT_DUTY_CYCLE        (float)0.5    /* Marker Duty Cycle to use. */
#define OPTO_DEFAULT_STROBER_VOLTAGE   (float)7.0    /* Voltage to use when turning on markers. */
#define OPTO_DEFAULT_COLLECTION_TIME   (float)2.0    /* Number of seconds of data to collect. */
#define OPTO_DEFAULT_STREAM_DATA              1      /* Stream mode for the data buffers. */
#define OPTO_DEFAULT_PRE_TRIGGER_TIME  (float)0.0    /* Number of seconds to pre-trigger data by. */
#define OPTO_DEFAULT_MINIMUM_GAIN             160    /* Minimum gain code amplification to use. */
#define OPTO_DEFAULT_THRESHOLD                30     /* Dynamic or Static Threshold value to use. */

/* Default values for File ID: */
/* NOTE: MUST BE BETWEEN 0 .. 15 !!! */
#define OPTO_DEFAULT_FILE_ID 9 /* todo: HANDLE BETTER!!! */

typedef void (*optoFunctionPtr)(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]);

extern optoFunctionPtr optoSelectFunction(char *optoCommandName);
/* extern void optoTransputerLoadSystem(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]); */
/* extern void optoTransputerInitializeSystem(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]); */
/* todo void optoPrintAllNDIFlags(void); */
/* extern long optoGetNDIFlag(char name[],int hlp,int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]); */

#endif /* OPTOUTIL_H */
