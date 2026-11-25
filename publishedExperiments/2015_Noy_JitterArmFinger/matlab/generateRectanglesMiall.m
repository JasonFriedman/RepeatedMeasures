% GENERATERECTANGLESMIALL

function generateRectanglesMiall

% From Miall et al., 1993

t = 0:1/60:30; % 30 seconds

f = [0.073 0.117 0.205 0.278];

v = sin((2*pi*f)'*t);
height = sum(v);

height2 = height / 8 + 0.5;

x = repmat(0.3,numel(height2),1);
y = 0.9 - height2;
width = repmat(0.15,numel(height2),1);
tofill = ones(numel(height2),1);

csvwrite('stimuli/rectanglesMiall.csv',[x y' width height2' tofill]);