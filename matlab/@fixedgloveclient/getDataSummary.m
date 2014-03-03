% GETDATASUMMARY - generate a fake data summary
%
% dataSummary = getDataSummary(sc)

function dataSummary = getDataSummary(sc)

dataSummary.dummy = 1;

dataSummary.meanjointangles = [0 sc.jointangles];
dataSummary.toSave = [0 sc.jointangles];