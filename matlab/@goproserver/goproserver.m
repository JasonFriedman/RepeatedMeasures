% GOPROSERVER - create a gopro server to listen for connections and tell
% the camera to start / stop recording
% 
% gs = goproserver(port,debug,downloadfiles,resolution,fps,view)
%
% if downloadfiles=1 (default), then after each recording, the file will be
% downloaded to the computer. Note that this is via wifi, and may slow
% down the program (especially if the file sizes are large). The benefit
% is that the files will be named according to the protocol, otherwise
% they will need to be manually following the experiment (via wifi, copying
% off the SD card, or connecting the USB cable). If the files are not
% saved during the experiment, a text file will be generated in the same
% locaton with the address of where to download the relevant file
%
% resolution is one of: '4K','4K 4:3','2.7K','2.7K 4:3','1440p','1080p','960p','720p' (default '1080p')
% fps (frames per second) is one of
% '240fps','120fps','100fps','90fps','80fps','60fps','50fps','48fps','30fps','24fps' (default '24fps')
% view is one of 'Wide','SuperView','Linear' (default 'Linear')
%
% Note that not all combinations are available, so you should test first on
% the gopro whether it is supported
%
% e.g. 
% gs = goproserver(3030,1);
% listen(ts);
%
% OR 
%
% gs = goproserver(3030,1,1,'4K','240fps','Wide');
% listen(ts);
%

function gs = goproserver(port,debug,downloadfiles,resolution,fps,view,direction)

% Valid values
resolutions = {'4K','4K 4:3','2.7K','2.7K 4:3','1440p','1080p','960p','720p'};
fpss = {'240fps','120fps','100fps','90fps','80fps','60fps','50fps','48fps','30fps','24fps'};
views = {'Wide','SuperView','Linear'};
directions = {'Up','Down','GyroBased'};
    
if nargin<3 || isempty(downloadfiles)
    downloadfiles = 1;
end

if nargin<4 || isempty(resolution)
    resolution = '1080p';
end

if nargin<5 || isempty(fps)
    fps = '24fps';
end

if nargin<6 || isempty(view)
    view = 'Linear';
end

if nargin<7 || isempty(direction)
    direction = 'GyroBased';
end

% Make sure the values are valid
if ~any(strcmp(resolution,resolutions))
    resolutions
    error(['Gopro resolution ' resolution ' must be one of the listed resolutions']);
end

if ~any(strcmp(fps,fpss))
    fpss
    error(['Gopro fps ' fps ' must be one of the listed fps values']);
end

if ~any(strcmp(view,views))
    views
    error(['Gopro view ' view 'must be one of the listed views']);
end

if ~any(strcmp(direction,directions))
    directions
    error(['Gopro direction ' direction ' must be one of the listed directions']);
end

gs.codes = messagecodes;
gs.downloadfiles = downloadfiles;
gs.resolution = resolution;
gs.fps = fps;
gs.view = view;
gs.direction = direction;
gs.lastFilename = []; % for later use
gs.recording = 0; % for later use - only stop recording if it has started

if nargin<2 || isempty(debug)
    debug = 0;
end

gs = class(gs,'goproserver',socketserver(port,1,debug));

% Try to connect to the gopro (so that if it fails, it will cause an error)
gopro('VideoMode');
fprintf('Gopro set to video mode\n');