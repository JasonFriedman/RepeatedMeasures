% SETHEMISPHERE - set the active hemisphere
% 
% sethemisphere(tc)

function sethemisphere(tc)

codes = messagecodes;

hemisphere = find(strcmp(tc.hemisphere,{'FRONT','BACK','TOP','BOTTOM','LEFT','RIGHT'}));
if isempty(hemisphere)
    error('Hemisphere must be a string, one of FRONT, BACK, TOP, BOTTOM, LEFT, RIGHT');
end
        
m.parameters = hemisphere;
m.command = codes.TRAKSTAR_SetHemisphere;

sendmessage(tc,m,'SetHemisphere');
