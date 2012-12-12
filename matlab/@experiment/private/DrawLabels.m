% DRAWLABELS - draw the appropriate labels (strings) on the screen

function DrawLabels(thistrial,labels,screenInfo)

% Draw the labels (in white)
for labelNum = 1:numel(labels)
    drawTextLocation(thistrial,screenInfo,'Courier',labels{labelNum}.fontSize,0,labels{labelNum}.text,labels{labelNum}.location,1);
end
