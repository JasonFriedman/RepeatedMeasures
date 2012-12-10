% SETHEMISPHERE - set the active hemisphere
% 
% sethemisphere(l,hemisphere)
%
% e.g. sethemisphere(l,[0 0 1]) % +Z is active hemisphere
% e.g. sethemisphere(l,[0 -1 0]); % =Y is the active hemipshere

function sethemisphere(lc,sensor)

if numel(lc.hemisphere)~=3
    error('The hemisphere must be a vector of length 3');
end

codes = messagecodes;

m.command = codes.LIBERTY_SetHemisphere;
m.parameters{1} = sensor;
m.parameters{2} = lc.hemisphere(1);
m.parameters{3} = lc.hemisphere(2);
m.parameters{4} = lc.hemisphere(3);

sendmessage(lc,m,'SetHemisphere');
