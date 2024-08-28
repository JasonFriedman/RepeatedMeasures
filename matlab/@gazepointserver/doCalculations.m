% DOCALCULATIONS - do some calculations on the data, which can be requested from the client
%
% dataSummary = doCalculations(gs,data)
%
% data is the last recorded data, it returns a struct with the new data added

function dataSummary = doCalculations(gs,data)

dataSummary.lastlocation = data(end,1:2);

% check if they were fixating the whole trial, if relevant
if ~isempty(gs.fixationbox) && ~isnan(gs.fixationratio)
    good = ~isnan(data(:,1));
    x = data(good,1);
    y = data(good,2);
    left = gs.fixationbox(1);
    top = gs.fixationbox(2);
    right = left + gs.fixationbox(3);
    bottom = top + gs.fixationbox(4);

    infixationbox = numel(find(x>=left & x<=right & y>=top & y<=bottom));
    infixationratio = infixationbox ./ numel(x);
    dataSummary.fixationok = (infixationratio >= gs.fixationratio);
    fprintf('in fixation box: %d, total samples: %d, ratio: %.3f, fixationok: %d\n',infixationbox, numel(x), infixationratio, dataSummary.fixationok);
end

dataSummary.toSave = data;
