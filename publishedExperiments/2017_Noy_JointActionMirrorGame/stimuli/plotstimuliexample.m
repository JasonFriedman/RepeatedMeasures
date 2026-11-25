% EXAMPLE OF HOW TO LOAD THE STIMULI FILES
%
% These are the stimuli from the article:
% Synchrony in improvised joint action is directed by each participant’s motor control system
% Noy, Weiser & Friedman
% 
% Under review at Frontiers in Psychology, 2016
%
% Please contact Jason Friedman (jason@post.tau.ac.il) for further assistance
%
% Each row has 2 values:
% x location of the ellipse
% y location of the ellipse (in this experiment, it is fixed)
%
% These are relative values - with 0 corresponding the left / top of the
% screen, and 1 corresponding to the right / bottom of the screen
%
% These files are designed to be read with the program RepeatedMeasures,
% avialable at http://jasonfriedman.github.io/RepeatedMeasures/

% Here we will plot the horizontal location of the ellipse

figure;
for trialnumber=1:11
    stimuli{trialnumber} = load(sprintf('dot%d.csv',trialnumber));
    subplot(3,4,trialnumber);
    xpos = stimuli{trialnumber}(:,1);
    time = (1:numel(xpos)) ./ 60; % The stimuli data is at 60 Hz (to match the screen refresh)
    plot(time,xpos); 
    title(sprintf('Trial %d',trialnumber));
    xlabel('Time (s)');
    ylabel('Relative horizontal location');
    xlim([0 max(time)]);
end
