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
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ndtypes.h>
#include <ndpack.h>
#include <ndopto.h>
#include <mex.h>
#include "optoUtil.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
  char            optoCommandName[OPTO_COMMAND_NAME_LENGTH]; 
  int             giveHelp=0;
  optoFunctionPtr optoCommand;

  /* Get optoCommandName from Matlab: */
  mxGetString(prhs[0],optoCommandName,OPTO_COMMAND_NAME_LENGTH);
  nrhs--;
  prhs++;

  /* Determine whether help is requested: */
 if (optoCommandName[strlen(optoCommandName)-1]=='?'){
   giveHelp=1;
   optoCommandName[strlen(optoCommandName)-1]=0;
 }

  /* Select function pointer and call it: */
  optoCommand=optoSelectFunction(optoCommandName);
  (*optoCommand)(optoCommandName,giveHelp,nlhs,plhs,nrhs,prhs);
}
