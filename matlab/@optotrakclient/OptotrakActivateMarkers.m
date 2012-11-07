% OPTOTRAKACTIVATEMARKERS - activate the markers 
%
% OptotrakActivateMarkers(oc)

function OptotrakActivateMarkers(oc)

codes = messagecodes;

m.command = codes.OPTO_OptotrakActivateMarkers;
m.parameters = [];

sendmessage(oc,m,'OptotrakActivateMarkers');
