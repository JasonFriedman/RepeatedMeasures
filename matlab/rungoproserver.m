% RUNGOPROSERVER - run a gopro server on port 3030 in another matlab
%
% rungoroserver(downloadfiles,resolution,fps,view)
%
% Leave values empty to use the default
%
% if downloadfiles=1 (default), then after each recording, the file will be
% downloaded to the computer. Note that this is via wifi, and may slow
% down the program (especially if the file sizes are large). The benefit
% is that the files will be named according to the protocol, otherwise
% they will need to be manually following the experiment (via wifi, copying
% off the SD card, or connecting the USB cable). Note that in either case
% the filenames on the gopro (which can't be controlled) will be written
% in the logfile
%
% resolution is one of: '4K','4K 4:3','2.7K','2.7K 4:3','1440p','1080p','960p','720p' (default '1080p')
% fps (frames per second) is one of
% '240fps','120fps','100fps','90fps','80fps','60fps','50fps','48fps','30fps','24fps' (default 24 fps)
% view is one of 'Wide','SuperView','Linear' (default 'Linear')
% direction is one of 'Up','Down' or 'GyroBased' (default GyroBased)
%
% Note that not all combinations are available, so you should test first on
% the gopro whether it is supported


function rungoproserver(downloadfiles,resolution,fps,view,direction)

if nargin<1 || isempty(downloadfiles)
    downloadfiles = 1;
end
if nargin<2 || isempty(resolution)
    resolution = '';
end
if nargin<3 || isempty(fps)
    fps = '';
end
if nargin<4 || isempty(view)
    view = '';
end
if nargin<5 || isempty(direction)
    direction= '';
end

port = 3030;
todebug = 1;

system(sprintf('matlab -nojvm -nosplash -r "gs = goproserver(%d,%d,%d,''%s'',''%s'',''%s'',''%s'');listen(gs);" &',port,todebug,downloadfiles,resolution,fps,view,direction));