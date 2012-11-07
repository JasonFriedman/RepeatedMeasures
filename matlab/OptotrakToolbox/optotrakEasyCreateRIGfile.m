function optotrakEasyCreateRIGfile(RIGFileName,Origin,xDir,xyPlane,Markers,Settings,Normals)
%todo
%Copyright (C) 2004 Volker Franz, see README.txt and COPYING.txt.

%Input checks and evaluation:
if(nargin < 5) error('Not enough input arguments'); end
if(nargin > 7) error('Too much input arguments');   end
if(~isDoubleArray(Origin ,3,1))   error('Origin must be 3x1 double vector'); end
if(~isDoubleArray(xDir   ,3,1))   error('xDir must be 3x1 double vector'); end
if(~isDoubleArray(xyPlane,3,1))   error('xyPlane must be 3x1 double vector'); end
if(~isDoubleArray(Markers,3,':')) error('Markers must be double array with 3 rows'); end
NumMarkersCols=length(Markers(1,:));
if(NumMarkersCols<3) error('You must specify at least 3 Markers'); end
if(nargin == 5)
  %If no settings are specified, create an empty struct and fill it below with default values.
  Settings=struct;
end
if(nargin == 6)
  if(~isstruct(Settings)) error('Settings must be a struct'); end
end
%If settings field is not specified, choose sensible defaults:
if(~isfield(Settings,'MaxSensorError')) Settings.MaxSensorError = 0.2;                   end
if(~isfield(Settings,'Max3dError'    )) Settings.Max3dError     = 0.5;                   end
if(~isfield(Settings,'MarkerAngle'   )) Settings.MarkerAngle    = 60;                    end
if(~isfield(Settings,'RmsError'      )) Settings.RmsError       = 0.5;                   end
if(~isfield(Settings,'SensorRmsError')) Settings.SensorRmsError = 0.1;                   end
if(~isfield(Settings,'MinimumMarkers')) Settings.MinimumMarkers = min(NumMarkersCols,4); end
if(NumMarkersCols<Settings.MinimumMarkers) 
  error('Settings.MinimumMarkers must not be larger than the number of markers');
end
if(nargin == 7)
  if(~isDoubleArray(Normals,3,':')) error('Normals must be double array with 3 rows'); end
  AddNormals=true;
  NumNormalsCols=length(Normals(1,:));
  if(NumMarkersCols~=NumNormalsCols) error('You must specify as much Normals as Markers'); end
else
  AddNormals=false;
end

%Translate to RB-origin: 
xDir    =    xDir-Origin;
xyPlane = xyPlane-Origin;
Markers = Markers-Origin*ones(1,NumMarkersCols);
if(AddNormals)
  Normals = Normals-Origin*ones(1,NumNormalsCols);
end

%Create orthonormal RB coordinates: 
ux=xDir/norm(xDir);
uz=cross(xDir,xyPlane)/norm(cross(xDir,xyPlane));
uy=cross(uz,ux);

%Create rotation matrix:
A=[ux,uy,uz];
Ainv=inv(A);

%Rotate Markers and Normals to RB coordinates: 
Markers = Ainv*Markers;
if(AddNormals)
  Normals = Ainv*Normals;
end

%Write to .rig file: 
fid = fopen([RIGFileName,'.rig'],'w');
fprintf(fid,'         Marker Description File\n');
fprintf(fid,'\n');
fprintf(fid,'Real 3D\n');
fprintf(fid,'%i     ;Number of markers\n',NumMarkersCols);
fprintf(fid,'1      ;Number of different views\n');
fprintf(fid,'Front\n');
fprintf(fid,'Marker                   X       Y            Z      Views\n');
fprintf(fid,'%i                   %f      %f    %f    1\n',[[1:NumMarkersCols]',Markers']');
fprintf(fid,'\n');
if(AddNormals)
  fprintf(fid,'Normals\n');
  fprintf(fid,'\n');
  fprintf(fid,'Marker       X          Y         Z\n');
  fprintf(fid,'                   %f      %f    %f    \n',Normals);
end
fprintf(fid,'MaxSensorError\n');
fprintf(fid,'%f\n',Settings.MaxSensorError);
fprintf(fid,'\n');
fprintf(fid,'Max3dError\n');
fprintf(fid,'%f\n',Settings.Max3dError);
fprintf(fid,'\n');
fprintf(fid,'MarkerAngle\n');
fprintf(fid,'%i\n',Settings.MarkerAngle);
fprintf(fid,'\n');
fprintf(fid,'3dRmsError\n');
fprintf(fid,'%f\n',Settings.RmsError);
fprintf(fid,'\n');
fprintf(fid,'SensorRmsError\n');
fprintf(fid,'%f\n',Settings.SensorRmsError);
fprintf(fid,'\n');
fprintf(fid,'MinimumMarkers\n');
fprintf(fid,'%i\n',Settings.MinimumMarkers);
fprintf(fid,'\n');
fclose(fid);

