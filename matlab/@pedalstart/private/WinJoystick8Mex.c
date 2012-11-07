/*------------------------------------------------------------------------------
WinJoystick8Mex.c -- A simple Matlab/Octave MEX file for query of joysticks on Microsoft Windows.

***** Modified to sample from 8 buttons instead of 4 ******

On Matlab, compile with:

mex -v -g WinJoystick8Mex.c winmm.lib

On Octave, compile with:

mex -v -g WinJoystick8Mex.c -lwinmm

------------------------------------------------------------------------------

    WinJoystickMex.c is Copyright (C) 2009 Mario Kleiner

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

	One copy of the license can be found in the License.txt file inside the
	Psychtoolbox-3 top level folder.
------------------------------------------------------------------------------*/

/* Windows includes: */
#include <windows.h>

/* Matlab includes: */
#include "mex.h"

/* This is the main entry point from Matlab: */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
	JOYINFO joy;	// Struct into which joystick state is returned.
	MMRESULT rc;	// Return code of function.
	unsigned int cmd;
	double* out;
	
	// Get our name for output:
	const char* me = mexFunctionName();

	if(nrhs < 1) {
		mexPrintf("WinJoystickMex: A simple Matlab/Octave MEX file for query of simple joysticks on Microsoft Windows\n\n");
		mexPrintf("(C) 2009 by Mario Kleiner -- Licensed to you under GPLv2 or any later version.\n");
		mexPrintf("This file is part of Psychtoolbox-3 but should also work independently.\n");
		mexPrintf("\n");
		mexPrintf("Usage:\n\n");
		mexPrintf("[x, y, z, buttons] = %s(joystickId);\n", me);
		mexPrintf("- Query joystick device 'joystickId'. This can be any number between 0 and 15.\n");
		mexPrintf("0 is the first connected joystick, 1 the 2nd, etc...\n");
		mexPrintf("x, y and z are the current x, y and z coordinate of the joystick.\n");
		mexPrintf("buttons is an 8-element vector, each element being zero if the corresponding button is released,\n");
		mexPrintf("one if the corresponding button is pressed.\n\n\n");
        return;
	}
	
	/* First argument must be the joystick id: */
	cmd = (unsigned int) mxGetScalar(prhs[0]);
	
	/* Call joystick function: */
	if ((rc = joyGetPos((UINT) cmd, &joy)) != JOYERR_NOERROR) {
		// Failed!
		mexPrintf("For failed joystick call with 'joystickId' = %i.\n", cmd);
		switch((int) rc) {
			case MMSYSERR_NODRIVER:
				mexErrMsgTxt("The joystick driver is not present or active on this system! [MMSYSERR_NODRIVER]");
			break;
			
			case JOYERR_NOCANDO:
				mexErrMsgTxt("Some system service for joystick support is not present or active on this system! [JOYERR_NOCANDO]");
			break;
			
			case MMSYSERR_INVALPARAM:
			case JOYERR_PARMS:
				mexErrMsgTxt("Invalid 'joystickId' passed! [MMSYSERR_INVALPARAM or JOYERR_PARMS]");
			break;

			case JOYERR_UNPLUGGED:
				mexErrMsgTxt("The specified joystick is not connected to the system! [JOYERR_UNPLUGGED]");
			break;

			default:
				mexPrintf("Return code of failed joystick call is %i.\n", rc);
				mexErrMsgTxt("Unknown error! See return code above.");
		}
	}

	// Return X pos:
	plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
	*(mxGetPr(plhs[0])) = (double) joy.wXpos;

	// Return Y pos:
	plhs[1] = mxCreateDoubleMatrix(1, 1, mxREAL);
	*(mxGetPr(plhs[1])) = (double) joy.wYpos;

	// Return Z pos:
	plhs[2] = mxCreateDoubleMatrix(1, 1, mxREAL);
	*(mxGetPr(plhs[2])) = (double) joy.wZpos;
	
	// Return 8-element button state vector:
	plhs[3] = mxCreateDoubleMatrix(1, 8, mxREAL);
	out = mxGetPr(plhs[3]);
	out[0] = (joy.wButtons & JOY_BUTTON1) ? 1 : 0;
	out[1] = (joy.wButtons & JOY_BUTTON2) ? 1 : 0;
	out[2] = (joy.wButtons & JOY_BUTTON3) ? 1 : 0;
	out[3] = (joy.wButtons & JOY_BUTTON4) ? 1 : 0;
	out[4] = (joy.wButtons & JOY_BUTTON5) ? 1 : 0;
	out[5] = (joy.wButtons & JOY_BUTTON6) ? 1 : 0;
	out[6] = (joy.wButtons & JOY_BUTTON7) ? 1 : 0;
	out[7] = (joy.wButtons & JOY_BUTTON8) ? 1 : 0;
    

	// Done.
	return;
}
