% PREPAREDOTS - prepare the dots for later display
%
% Based on the VCRDM code written by Maria Mckinley, available from
% http://www.shadlenlab.columbia.edu/Code/VCRDM


function dotInfo = preparedots(screenInfo, dotInfo)
% dotInfo = preparedots(screenInfo, dotInfo, targets)
%
% arguments - minimum fields for dotInfo and screenInfo - see createDotInfo
% and openExperiment
%
%   most everything is in visual degrees * 10, since rex only likes integers
%
%       dotInfo.numDotField     number of dot patches that will be shown on the screen
%		dotInfo.coh             vertical vectors, dots coherence (0...999) for each dot patch
%		dotInfo.speed           vertical vectors, dots speed (10th deg/sec) for each dot patch
%		dotInfo.dir             vertical vectors, dots direction (degrees) for each dot patch
%       dotInfo.dotSize         size of dots in pixels, same for all patches
%       dotInfo.maxDotsPerFrame determined by testing video card
%       dotInfo.apXYD           x, y coordinates, and diameter of aperture(s) in visual degrees
%       screenInfo.center       center of the screen in pixels
%       screenInfo.ppd          pixels per visual degree
%       screenInfo.monRefresh   monitor refresh value
%       screenInfo.dontclear    If set to 1, flip will not clear the framebuffer after Flip - this allows incremental
%                               drawing of stimuli. Needs to be zero for dots to be erased.
%		screenInfo.rseed        random # seed, can be empty set[]
%
% algorithm:
%		All calculations take place within a square aperture
% in which the dots are shown. The dots are constructed in 3 sets that are
% plotted in sequence.  For each set, the probability that a dot is
% replotted in motion -- as opposed to randomly replaced -- is given by the
% dotInfo.coh value.  This routine generates a set of dots as an ndots_ by
% 2 matrix of locations, and then plots them.  In plotting the next set of
% dots (e.g., set 2) it prepends the preceding set (e.g., set 1).
%
% created by MKMK July 2006, based on ShadlenDots by MNS, JIG and others

% structures are not altered in this function, so should not have memory
% problems from matlab creating new structures...

rseed = screenInfo.rseed;

% SEED THE RANDOM NUMBER GENERATOR ... if "[]" is given, reset
% the seed "randomly"... this is for VAR/NOVAR conditions
if ~isempty(rseed) && length(rseed) == 1
    rand('state', rseed);
elseif ~isempty(rseed) && length(rseed) == 2
    rand('state', rseed(1)*rseed(2));
else
    rseed = sum(100*clock);
    rand('state', rseed);
end

% create the square for the aperture
dotInfo.apRect = floor(createTRect(dotInfo.apXYD, screenInfo));
% USEFUL LOCAL VARS
% variables that are sent to rex have been multiplied by a factor of 10 to
% make sure they are integers. Now we have to convert them back so that
% they are correct for plotting.
apD = dotInfo.apXYD(:,3); % diameter of aperture
% dotInfo.apXYD(:,1:2)
% screenInfo.center;
% disp('dotInfo.apXYD')
% dotInfo.apXYD(:,1:2)/10*screenInfo.ppd
%size(screenInfo.center);
center = repmat(screenInfo.center,size(dotInfo.apXYD(:,1)));
%size(dotInfo.apXYD(:,1:2));
% change the xy coordinates to pixels (y is inverted - pos on bottom, neg.
% on top
dotInfo.center = [center(:,1) + dotInfo.apXYD(:,1)/10*screenInfo.ppd center(:,2) - dotInfo.apXYD(:,2)/10*screenInfo.ppd]; % where you want the center of the aperture
dotInfo.d_ppd 	= floor(apD/10 * screenInfo.ppd);	% size of aperture in pixels

% ndots is the number of dots shown per video frame
% we will place dots in a square the size of the aperture
% - Size of aperture = Apd*Apd/100  sq deg
% - Number of dots per video frame = 16.7 dots per sq.deg/sec,
%        Round up, do not exceed the number of dots that can be
%		 plotted in a video frame (dotInfo.maxDotsPerFrame)
% maxDotsPerFrame was originally in setupScreen as a field in screenInfo,
% but makes more sense in createDotInfo as a field in dotInfo
dotInfo.ndots 	= min(dotInfo.maxDotsPerFrame, ceil(16.7 * apD .* apD * 0.01 / screenInfo.monRefresh));
% i.e. for this one typically 16.7 * 50 * 50 * 0.01 / 60 = 7

if numel(dotInfo.speed==1)
    dotInfo.speed = repmat(dotInfo.speed,dotInfo.numDotField,1);
end
if numel(apD==1)
    apD = repmat(apD,dotInfo.numDotField,1);
end
if numel(dotInfo.ndots==1)
    dotInfo.ndots = repmat(dotInfo.ndots,dotInfo.numDotField,1);
end
if numel(dotInfo.dir==1)
    dotInfo.dir = repmat(dotInfo.dir,dotInfo.numDotField,1);
end
if numel(dotInfo.coh==1)
    dotInfo.coh = repmat(dotInfo.coh,dotInfo.numDotField,1);
end
if numel(dotInfo.d_ppd==1)
    dotInfo.d_ppd = repmat(dotInfo.d_ppd,dotInfo.numDotField,1);
end
if size(dotInfo.apRect,1)==1
    dotInfo.apRect = repmat(dotInfo.apRect,dotInfo.numDotField,1);
end
if size(dotInfo.center,1)==1
    dotInfo.center = repmat(dotInfo.center,dotInfo.numDotField,1);
end

% don't worry about pre-allocating, the number of dot fields should never
% be large enough to cause memory problems
for df = 1 : dotInfo.numDotField,
    % dxdy is an N x 2 matrix that gives jumpsize in units on 0..1
    %    	 deg/sec     * Ap-unit/deg  * sec/jump   =   unit/jump
    dotInfo.dxdy{df} 	= repmat((dotInfo.speed(df)/10) * (10/apD(df)) * (3/screenInfo.monRefresh) ...
        * [cos(pi*dotInfo.dir(df)/180.0) -sin(pi*dotInfo.dir(df)/180.0)], dotInfo.ndots(df),1);
    %dotInfo.dxdy{df} 	= repmat((dotInfo.speed/10) * (10/apD) * (3/screenInfo.monRefresh) ...
    %    * [cos(pi*dotInfo.dir/180.0) -sin(pi*dotInfo.dir/180.0)], dotInfo.ndots,1);
    % ARRAYS, INDICES for loop
    %dotInfo.ss{df}		= rand(dotInfo.ndots*3, 2); % array of dot positions raw [xposition yposition]
    dotInfo.ss{df}		= rand(dotInfo.ndots(df)*3, 2); % array of dot positions raw [xposition yposition]
    % divide dots into three sets...
    dotInfo.Ls{df}      = cumsum(ones(dotInfo.ndots(df),3))+repmat([0 dotInfo.ndots(df) dotInfo.ndots(df)*2], dotInfo.ndots(df), 1);
    %dotInfo.Ls{df}      = cumsum(ones(dotInfo.ndots,3))+repmat([0 dotInfo.ndots dotInfo.ndots*2], dotInfo.ndots, 1);
    dotInfo.loopi(df)   = 1; 	% loops through the three sets of dots
end

function tarRects = createTRect(target_array, screenInfo)
% function tarRects = getTRect(target_array, screenInfo)
%	Gets the display rect for the list of targets
%	Argument target_array is nx3, where the columns are
%		x_position y_position diameter

% 1/17/06  RK modified it for Windows operating system
% July 2006 MKMK modified it for OSX
% do no error checking -- assume it's been done already

xy = target_array(:,1:2);
diameter = target_array(:,3);

center = repmat(screenInfo.center, size(xy(:,1)));

% ppd is off by a factor of 10 so that we don't send any fractions to rex
ppd = screenInfo.ppd/10;

% change the xy coordinates to pixels (y is inverted - pos on bottom, neg.
% on top
tar_xy = [center(:,1)+xy(:,1)*ppd center(:,2)-xy(:,2)*ppd];

% change the diameter to pixels, make it same size as tar_xy so we can add
% them
diam = repmat(diameter, size(tar_xy(1,:))) * ppd;

% now need to change from center and diameter to the corners of a box that
% would enclose the circle for use with Screen('FillOval')
tarRects = [tar_xy-diam/2 tar_xy+diam/2];

