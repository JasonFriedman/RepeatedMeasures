function [OptoPositions] = optotrakTransformRigid2Opto(RigidBody,Positions)
%Transforms Positions (which are in RigidBody coordinates) to Optotrak
%coordinates.
%
%Input variables: 
%  1. Rigid body is struct, as returned for example by
%     optotrak('DataGetLatestTransforms') and the rotation must be expressed as a
%     rotation matrix (set the flag 'OPTOTRAK_RETURN_MATRIX_FLAG' for this!).
%  2. Positions is an array, with each column being a 3D position in
%     RigidBody coordinates.
%Output variables: 
%  1. OptoPositions: Positions in Optotrak coordinates.
%
%Copyright (C) 2004 Volker Franz, see README.txt and COPYING.txt.

%Input checks and evaluation:
if(nargin < 2) error('Not enough input arguments'); end
if(nargin > 2) error('Too much input arguments');   end
if(~isDoubleArray(Positions,3,':')) error('Origin must be a double array with three rows'); end
if(~isfield(RigidBody,'RotMatrix'))
  error('Rigid body must be in rotation matrix format. Set flag: OPTOTRAK_RETURN_MATRIX_FLAG');
end
if(~isDoubleArray(RigidBody.Trans,3,1)) error('RigidBody.Trans must be a 3x1 array'); end 
%TODO!!!check RotMatrix also!!!
%TODO!!!handle time-series data!!!
sizePositions = size(Positions);
colsPositions = sizePositions(2);

%todo--todo--todo--todo--todo--todo--todo--todo--todo--todo--
%handle time-series data!!!
%fprintf('RigidBody.RotMatrix(:)\n');
%RigidBody.RotMatrix(:)
%fprintf('RigidBody.Trans\n');
%RigidBody.Trans
%todo--todo--todo--todo--todo--todo--todo--todo--todo--todo--

%Transformation:
if(max(isnan([RigidBody.RotMatrix(:);RigidBody.Trans]))==1)
  %Missing values in Rigid body -> Return NaN
  OptoPositions=ones(sizePositions)*NaN;
else
  Origin=RigidBody.Trans*ones(1,colsPositions);
  invRotMat=inv(RigidBody.RotMatrix);
  OptoPositions=(invRotMat*Positions)+Origin;
end

%Origin=RigidBody.Trans;
%RotMat=RigidBody.RotMatrix;
%OptoPositions=(RotMat*Positions)+Origin;%todo
