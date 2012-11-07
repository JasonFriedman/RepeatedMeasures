% DRAWLABELS - draw the appropriate labels (strings) on the screen

function DrawLabels(labels,screenInfo)

% Draw the labels (in white)
for labelNum = 1:numel(labels)
    drawTextLocation(screenInfo,'Courier',labels{labelNum}.fontSize,0,labels{labelNum}.text,labels{labelNum}.location,1);
end
