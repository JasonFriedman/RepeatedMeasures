% GETSTAIRCASEVALUE - get the next value of the staircase
%
% tTest = getStaircaseValue(s)

function tTest = getStaircaseValue(s)

tTest=QuestQuantile(s.q);

if tTest<s.min
    tTest = s.min;
end
if tTest>s.max
    tTest = s.max;
end
