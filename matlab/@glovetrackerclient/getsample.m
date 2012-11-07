% GETSAMPLE - get the last sample recorded - concatenated glove and tracker data
% 
% data = getsample(gfc)

function data = getsample(gfc)

data.glove = getsample(gfc.glove);
data.tracker = getsample(gfc.tracker);
