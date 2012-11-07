function [result]=optotrakEasyChangeCameraFOR(OldCAMFileName,NewCAMFileName,Origin,xDir,xyPlane)
%Create a new camera-file which changes the frame of reference of the Optotrak. 
%To do this, you must first measure the following points using the
%old camera-file ("OldCAMFileName"):
%
% - Origin: is the new origin.
% - xDir: is a vector from the new origin to ANY point on the new x-axis.
% - xyPlane: is a vector from the new origin to ANY point on the new
%   xy-plane.
%
%After creating the new camera file, you must load it into the Optotrak to take effect. 
%For example like this: 
%
% optotrakEasyChangeCameraFOR('standard','newFOR',Origin,xDir,xyPlane)
% optotrak('OptotrakLoadCameraParameters','newFOR');
% optotrak('OptotrakSetupCollection',coll);
% pause(1);
%
%Copyright (C) 2004 Volker Franz, see README.txt and COPYING.txt.

%Input checks and evaluation:
if(nargin < 5) error('Not enough input arguments'); end
if(nargin > 5) error('Too much input arguments');   end
if(strcmp(NewCAMFileName,'standard')) error('Attempt to overwrite the standard camera file'); end
if(~isDoubleArray(Origin ,3,1))   error('Origin must be 3x1 double vector'); end
if(~isDoubleArray(xDir   ,3,1))   error('xDir must be 3x1 double vector'); end
if(~isDoubleArray(xyPlane,3,1))   error('xyPlane must be 3x1 double vector'); end

%Create a zDir which is orthogonal to xDir:
zDir=cross(xDir-Origin,xyPlane-Origin)+Origin;

%Determine the following mapping:
%old coordinates -> new coordinates
%         Origin -> Origin
%         xDir   -> x-axis
%         zDir   -> z-axis
AlignedPositions=[0,norm(xDir-Origin),               0;
                  0,                0,               0;
                  0,                0,norm(zDir-Origin)];

%Transform the frame of reference and write it to the file NewCAMFileName:
newSet.InputCamFile     =OldCAMFileName;
newSet.AlignedCamFile   =NewCAMFileName;
newSet.NumPositions     =3;
newSet.MeasuredPositions=[Origin,xDir,zDir];
newSet.AlignedPositions =AlignedPositions;
result=optotrak('OptotrakChangeCameraFOR',newSet);
disp(['Wrote new camera file: ',NewCAMFileName,'.CAM']);
