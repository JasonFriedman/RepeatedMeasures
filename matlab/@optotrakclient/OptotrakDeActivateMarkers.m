% OPTOTRAKDEACTIVATEMARKERS - deactivate the markers 
%
% OptotrakDeActivateMarkers(oc)

function OptotrakDeActivateMarkers(oc)

codes = messagecodes;

m.command = codes.OPTO_OptotrakDeActivateMarkers;
m.parameters = [];

sendmessage(oc,m,'OptotrakDeActivateMarkers');
