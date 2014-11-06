% GETSTAIRCASEVALUE - get the next value of the staircase
%
% tTest = getStaircaseValue(s)

function tTest = getStaircaseValue(s)

tTest=QuestQuantile(s.q);
