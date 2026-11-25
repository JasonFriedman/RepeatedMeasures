% GENERATERECTANGLES

function generateRectangles

baseline = 0.2;
amplitude = 0.15;
cycles = 5;
theta = 0:0.02:cycles*2*pi;
height = baseline + amplitude * sin(theta);

x = repmat(0.3,numel(height),1);
y = 0.9 - height;
width = repmat(0.15,numel(height),1);
tofill = ones(numel(height),1);

csvwrite('stimuli/rectangles.csv',[x y' width height' tofill]);