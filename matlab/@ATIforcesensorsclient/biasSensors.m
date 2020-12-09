% BIASSENSORS - bias (zero) the force sensors
%
% biasSensors(fc)
 
function biasSensors(fc)

codes = messagecodes;

m.command = codes.ATI_bias;
m.parameters = [];

sendmessage(fc,m,'biasSensors');
