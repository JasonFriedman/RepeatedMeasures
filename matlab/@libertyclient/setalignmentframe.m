% SETALIGNMENTFRAME - set the alignment frame (which way is x,y,z)
% 
% setalignmentframe(l,sensor,coords)
%
% coords should be a 1 x 9 matrix, with the position of the origin (3
% numbers), the direction of the x axis (3 numbers) and the direction of
% the y axis (3 numbers). It is set as a  member of the class
% e.g. [0 0 0 0 1 0 0 0 -1]

function setalignmentframe(lc,sensor)

if numel(lc.alignmentframe)~=9
    error('The alignment frame must be a vector of length 9');
end

codes = messagecodes;

m.command = codes.LIBERTY_AlignmentReferenceFrame;
m.parameters{1} = sensor;
m.parameters{2} = lc.alignmentframe;

sendmessage(lc,m,'AlignmentReferenceFrame');
