% GETUPDATERATE - get the update rate
% updaterate = getupdaterate(l)
%
% It will return 3 for 120 Hz, 4 for 240 Hz

function rate = getupdaterate(l)

IOPort('Write',l.s,['R' char(13)]);
result = IOPort('Read',l.s,1,12);
rate = result(9);



