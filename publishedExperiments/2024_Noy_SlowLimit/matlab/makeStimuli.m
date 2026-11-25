% MAKESTIMULI - load Assi's stimuli and save to a .csv file

load stim_x;

% convert [-1 to 1] to [0 1]
minval = -1.2; maxval = 1.2;
yval = 0.55; %0.4;
for k=1:12
    thisstim = [repmat(stim_x{k}(1),1,120) stim_x{k}];
    thesevals = ((thisstim - minval) ./ (maxval - minval))';
    thesevals(:,2) = yval;
    csvwrite(['stimuli/dot' num2str(k) '.csv'],thesevals);
end