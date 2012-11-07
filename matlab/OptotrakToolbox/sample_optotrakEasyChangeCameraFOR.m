function sample_optotrakEasyChangeCameraFOR
%Example of how to transform the frame of reference (i.e., the
%coordinate system) of your Optotrak using the function
%optotrakEasyChangeCameraFOR. 
%
%This is what you do:
%
% - Connect 4 markers to the Optotrak. 
% - Fix marker 1,2,3 to the table (e.g. by adhesive tape) => 
%   - marker 1 will become the origin of your new coordinates. 
%   - marker 2 will define the x-axis of your new coordinates. 
%   - marker 3 will define the xy-plane of your new coordinates. 
%   (I will call markers 1-3 table markers in the following). 
% - marker 4 will be a probe which allows to test the new coordinates.
% - call this function in Matlab. 
%
%This is what happens:
%
% - Part 1: Creates a new camera file describing the new coordinates: 
%    - We first measure the table markers for a while and
%      average the data (to increase precision). This will be done in
%      the standard coordinate system of the Optotrak 
%      (i.e., using the camera file standard.cam). 
%    - We will then call optotrakEasyChangeCameraFOR. This will create a
%      new camera file (called newcoor.cam) containing all information 
%      needed for the Optotrak to work in the new coordinates. 
%    - The Optotrak is switched off
% - Part 2: Load the new coordinates and check them:
%    - The Optotrak is started again, using the new 
%      coordinates.  (i.e., the camera file newcoor.cam).
%    - The markers will be displayed for a while to allow you checking 
%      the new coordinate system. You should play around especially with
%      marker 4 (which is not attached to anything) and check whether the 
%      coordinates are correct. 
%
%Note: 
%
% - When using this code you could split part 1 and part 2 in two separate 
%   functions, thus allowing you to determine the coordinate transformation 
%   at another time as the measurement. All you need to do to use the new 
%   coordinate system is to use the NewCAMFile instead of the OldCAMFile. 
%
%Copyright (C) 2004 Volker Franz, see README.txt and COPYING.txt.

%Just to be on the save side, we first reset all Matlab functions:
clear functions

%Settings:
coll.NumMarkers         = 4;   %Number of markers in the collection.         
coll.FrameFrequency     = 100; %Frequency to collect data frames at.          
%Settings for the "table markers" (these define the new coordinate system):
tableMarkersStartMarker = 1;   %marker 1=. origin of the new coordinates
                               %marker 2=> defines the x-axis
                               %marker 3=> defines the xy-plane.
calibcoorNcollect       = 100; %Number of data points to sample.
calibcoorMaxStd         = 0.1; %Max. allowed std. of data points
%Settings for the camera parameters:
OldCAMFile ='standard';
NewCAMFile ='newcoor';
%Settings for checking the new coordinates: 
NTestSamples = 100;

%Part 1:
disp('----------------------------------------------------------------------')
disp('Part 1: Measure the table markers to determine the new coordinates:')
disp('----------------------------------------------------------------------')
disp(['Old camera parameter file: ',OldCAMFile]);
disp(['We attempt to generate   : ',NewCAMFile]);

%Start optotrak using the standard coordinates (i.e., OldCAMFile)
optostart(OldCAMFile,coll);

%Measure table markers:
input(['To measure the table markers, press RETURN!']) 
[OriginMean,xDirMean,xyPlaneMean]=...
    optoMeasureTableMarkers(calibcoorNcollect,...
                            calibcoorMaxStd,...
                            coll.NumMarkers,...
                            tableMarkersStartMarker);

%Transform the frame of reference: OldCAMFile -> epar.CAMFile:
result=optotrakEasyChangeCameraFOR(OldCAMFile,NewCAMFile,OriginMean,xDirMean,xyPlaneMean);
disp(['RmsError: ',num2str(result.RmsError)]);

%... switch Optotrak off:
optostop;

%Part 2:
disp('----------------------------------------------------------------------')
disp('Part 2: Measure the markers for a while to check the new coordinates:')
disp('----------------------------------------------------------------------')

%Switch Optotrak on, using the new coordinates (i.e., NewCAMFile): 
optostart(NewCAMFile,coll);

%Measure the markers for a while and display their positions: 
input(['To measure the markers in the new coordinates, press RETURN!']) 
for FrameCnt = 1:NTestSamples
  clc;
  data=optotrak('DataGetLatest3D',coll.NumMarkers);
  for MarkerCnt = 1:coll.NumMarkers
    fprintf('Marker %u X %f Y %f Z %f\n', MarkerCnt,...
            data.Markers{MarkerCnt}(1),...
            data.Markers{MarkerCnt}(2),...
            data.Markers{MarkerCnt}(3))
  end
  pause(0.2)
end

%... switch Optotrak off:
optostop;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Subfunctions:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [OriginMean,xDirMean,xyPlaneMean]=optoMeasureTableMarkers(Ncollect,MaxStd,NumMarkers,StartMarker)
%We assume that Origin is the 1st, xDir the 2nd, xyPlaneMean the 3rd marker...

%Measure table-markers:
success=false;
while(~success)
  for i = 1:Ncollect
    data=optotrak('DataGetNext3D',NumMarkers);
    Origin(:,i)=data.Markers{StartMarker};
    xDir(:,i)=data.Markers{StartMarker+1};
    xyPlane(:,i)=data.Markers{StartMarker+2};
  end
  OriginMean=mean(Origin')'
  xDirMean=mean(xDir')'
  xyPlaneMean=mean(xyPlane')'
  OriginSD=std(Origin')'
  xDirSD=std(xDir')'
  xyPlaneSD=std(xyPlane')'
  if(max([OriginSD;xDirSD;xyPlaneSD])>MaxStd)
    disp('Variability too large, try again')
  elseif(max(isnan([OriginMean;xDirMean;xyPlaneMean]))==1)
    disp('Missing values not allowed, try again')
  else
    success=true;
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function optostart(CAMFile,Collection)
%Simple starter for Optotrak...

optotrak('TransputerLoadSystem','system');
pause(1);
optotrak('TransputerInitializeSystem')
optotrak('OptotrakLoadCameraParameters',CAMFile);
optotrak('OptotrakSetupCollection',Collection);
pause(1);
optotrak('OptotrakActivateMarkers');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function optostop()
%Switch Optotrak off...

optotrak('OptotrakDeActivateMarkers')
optotrak('TransputerShutdownSystem')
disp('... done with Optotrak')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
