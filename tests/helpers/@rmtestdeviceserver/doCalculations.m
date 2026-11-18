% DOCALCULATIONS - summarize the simulated data at the end of the trial
function dataSummary = doCalculations(d,data)
if isempty(d.summaryFcn)
    dataSummary.toSave = data;
else
    dataSummary = d.summaryFcn(data);
end
