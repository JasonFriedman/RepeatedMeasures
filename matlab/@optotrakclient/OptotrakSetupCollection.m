% OPTOTRAKSETUPCOLLECTION - setup collection parameters (when primary host) 
%
% OptotrakSetupCollection(oc,coll)
 
function OptotrakSetupCollection(oc,coll)

codes = messagecodes;

m.command = codes.OPTO_OptotrakSetupCollection;
m.parameters = coll;

sendmessage(oc,m,'OptotrakSetupCollection');
