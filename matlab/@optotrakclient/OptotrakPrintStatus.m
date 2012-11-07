% OPTOTRAKPRINTSTATUS - print the current status (will appear in the server window) 
%
% OptotrakPrintStatus(oc)

function OptotrakPrintStatus(oc)

codes = messagecodes;

m.command = codes.OPTO_OptotrakPrintStatus;
m.parameters = [];

sendmessage(oc,m,'OptotrakPrintStatus');
