% OPTOTRAKLOADCAMERAPARAMETERS - load the camera parameters 
%
% OptotrakLoadCameraParameters(oc,cameraparameters)
% cameraparameters is the name of the camera file (e.g. 'TouchScreen'),
% which should be placed in the "realtime" directory of the optotrak

function OptotrakLoadCameraParameters(oc,cameraparameters)

codes = messagecodes;

m.command = codes.OPTO_OptotrakLoadCameraParameters;
m.parameters = cameraparameters;

sendmessage(oc,m,'LoadCameraParameters');
