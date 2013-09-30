% DRAW_PREPARED_DOTS_FRAME - draw a single frame of random dots
%
% dotInfo = draw_prepared_dots(screenInfo, dotInfo,frame)
% 
% Based on the VCRDM code written by Maria Mckinley, available from
% http://www.shadlenlab.columbia.edu/Code/VCRDM

function dotInfo = draw_prepared_dots_frame(screenInfo, dotInfo,frame,thistrial)

for df = 1 : dotInfo.numDotField,
    % ss is the matrix with the 3 sets of dot positions, dots from the last 2 positions + current
    % Ls picks out the set (for ex., with 5 dots on the screen at a time, 1:5, 6:10, or 11:15)

    Lthis{df}  = dotInfo.Ls{df}(:,dotInfo.loopi(df));  % Lthis now has the dot positions from 3  ago, which is what is then
    % moved in the current loop
    this_s{df} = dotInfo.ss{df}(Lthis{df},:); % this is a matrix of random #s - starting positions for dots not moving coherently
    % update the loop pointer
    dotInfo.loopi(df) = dotInfo.loopi(df)+1;
    if dotInfo.loopi(df) == 4,
        dotInfo.loopi(df) = 1;
    end
    % compute new locations, how many dots move coherently
    L = rand(dotInfo.ndots(df),1) < (dotInfo.coh(df)/1000);
    this_s{df}(L,:) = this_s{df}(L,:) + dotInfo.dxdy{df}(L,:);	% offset the selected dots
    if sum(~L) > 0
        this_s{df}(~L,:) = rand(sum(~L),2);	    % get new random locations for the rest
    end
    % wrap around - check to see if any positions are greater than one or less than zero
    % which is out of the square aperture, and then replace with a dot along one
    % of the edges opposite from direction of motion.
    N = sum((this_s{df} > 1 | this_s{df} < 0)')' ~= 0;
    if sum(N) > 0
        xdir = cos(pi*dotInfo.dir(df)/180.0); %sin(pi*dotInfo.dir(df)/180.0);
        ydir = sin(pi*dotInfo.dir(df)/180.0); %cos(pi*dotInfo.dir(df)/180.0);
        % flip a weighted coin to see which edge to put the replaced
        % dots
        if rand < abs(xdir)/(abs(xdir) + abs(ydir))
            this_s{df}(find(N==1),:) = [rand(sum(N),1) (xdir > 0)*ones(sum(N),1)];
        else
            this_s{df}(find(N==1),:) = [(ydir < 0)*ones(sum(N),1) rand(sum(N),1)];
        end
    end
    % convert to stuff we can actually plot
    this_x{df} = floor(dotInfo.d_ppd(df) * this_s{df});	% pix/ApUnit

    % this assumes that zero is at the top left, but we want it to be
    % in the center, so shift the dots up and left, which just means
    % adding half of the aperture size to both the x and y direction.
    dot_show{df} = (this_x{df} - dotInfo.d_ppd(df)/2)';
end;
% setup the mask - we will only be able to see a circular aperture,
% although dots moving in a square aperture. Minimizes the edge
% effects.
Screen('BlendFunction', screenInfo.curWindow, GL_ONE, GL_ZERO);

%    % want targets to still show up
%    Screen('FillRect', screenInfo.curWindow, [0 0 0 255]);

for df = 1 : dotInfo.numDotField,
    % square that dots do not show up in
    Screen('FillRect', screenInfo.curWindow, [0 0 0 0], dotInfo.apRect(df,:));
    % circle that dots do show up in
    Screen('FillOval', screenInfo.curWindow, [0 0 0 255], dotInfo.apRect(df,:));
end

Screen('BlendFunction', screenInfo.curWindow, GL_DST_ALPHA, GL_ONE_MINUS_DST_ALPHA);

% now do actual drawing commands, although nothing drawn until end of function

% dots
for df = 1:dotInfo.numDotField
    Screen('DrawDots', screenInfo.curWindow, dot_show{df}, dotInfo.dotSize, dotInfo.dotColor, dotInfo.center(df,:));
end;

% record the dot positions for future reference
dotInfo.dot_show{frame} = dot_show;
dotInfo.ss_saved{frame} = this_s;

% tell ptb to get ready while doing computations for next dots
% presentation
Screen('DrawingFinished',screenInfo.curWindow,thistrial.dontclear);
Screen('BlendFunction', screenInfo.curWindow, GL_ONE, GL_ZERO);

for df = 1 : dotInfo.numDotField,
    % update the dot position array for the next loop
    dotInfo.ss{df}(Lthis{df}, :) = this_s{df};
end
