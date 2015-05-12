% POINTTOPOINTRESPONSE - class representing point to point movements

function [r,params] = pointToPointresponse(inputParams)

params.name = {'start','end','startDistance','endDistance','repetitions','beep','endtime'};
params.type = {'number','number','number','number','number','boolean','number'};
params.description = {'The start point for the centre out movement (from those defined in setup.positions)','The end point for the centre out movement (from those defined in setup.positions)',...
    'How close to the start point you need to be to start a trial (inf for any distance), relative to screen width (1 = screen width)','How close to the end point you need to be to end a trial (inf for any distance), in pixels',...
    'Number of repetitions to perform. The trial will end when this number of repetitions has been reached (or the recordingTime has been reached)',...
    'Whether to beep afer each successful movement','The amount of time (in seconds) that you need to be at the target for'};
params.required = [1 1 0 0 1 0 0];
params.default = {[0 0],[0 1],0.02,0.02,10,0,0};
params.classdescription = 'This response is to for (possibly repeated) point to point measurements.';
params.classname = 'pointToPointresponse';
params.parentclassname = 'response';

if nargout>1
    r = [];
    return;
end

[r,parent] = readParameters(params,inputParams);

r = class(r,'pointToPointresponse',response(parent));


