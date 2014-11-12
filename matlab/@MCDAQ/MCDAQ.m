% MCDAQ - a class to read or write to a Measuremtn computing DAQ card on Windows 32/64 bit (via the "Univeral Library")
%
% t = MCDAQ(dllpath,in_or_out,channels,range,numChannelsTotal)
%
% dllpath is the path to the file cbw32.dll (ignored for analog input)
%
% in_or_out  = 1 -> digital output (default)
%            = 2 -> digial input
%            = 3 -> analog output (not yet implemented)
%            = 4 -> analog input
%
% channels   = which channels to read from / write to
%              for digital input or output, it should be a number from cbw.h (in the section "Types of digital I/O")
%              for digital output, default is AUXPORT (1)
%              for digital input, default is FIRSTPORTB  (11)
%              for analog input, default is channel 0, can also specify a 1x2 array ([minChannel maxChannel])
%                and all channels between minChannel and maxChannel inclusive will be sampled
%
% range      = data range (see manual for card for relevant ranges, then see file UniversalLibraryConstants to find the appropriate number to pass)
%              [this is ignored for digital input]
%
% numChannelsTotal = the total number of input channels.
%                    This usually determines whether the board will be
%                    single-sided or differential [this is ignored for
%                    digital input]

function t = MCDAQ(dllpath,in_or_out,channels,range,numChannelsTotal)

t.memoryPtr = [];
t.range = [];
t.boardNum = [];
t.bitNums = [];
t.memoryPtr = [];
t.numChannelsTotal = [];

ULconstants = UniversalLibraryConstants;

if nargin<2 || isempty(in_or_out)
    in_or_out = 1;
end

if nargin<3
    channels = [];
end

if nargin<4
    t.range = [];
end

if nargin<5
    numChannelsTotal = 8;
end

t.in_or_out = in_or_out;
t.channels = channels;
t.numChannelsTotal = numChannelsTotal;

fprintf('MC Mode = %d (1=digital output, 2 = digital input, 3 = analog output, 4 = analog input)\n',in_or_out);

if in_or_out == ULconstants.ANALOGIN
    t.range = range;
    if isempty(t.range)
        error('Range must be specified when using analog input');
    end
    if isempty(t.channels)
        t.channels = [0 0];
    elseif numel(t.channels)==1
        t.channels = [t.channels t.channels];
    elseif all(size(t.channels)~=[1 2])
        error('in MCDAQ when using analog input, channels must be a 1x2 vector (with the minimum and maximum channel numbers');
    end
elseif in_or_out == ULconstants.ANALOGOUT
    error('Not yet supported');
end

t.boardNum = 0;
t.DataValue = 3; % i.e., bit 0 and 1

% Load the dll, if it is not already loaded (only for digital IO, for
% analog use the mex file)

if in_or_out<=2
    if ~libisloaded('mccFuncLib')
        addpath(dllpath);
        if strcmp(mexext,'mexw64')
            loadlibrary('cbw64.dll','cbw.h','alias','mccFuncLib');
        elseif strcmp(mexext,'mexw32')
            loadlibrary('cbw32.dll','cbw.h','alias','mccFuncLib');
        else
            error('This only works with 32 or 64 bit Windows');
        end
    end
    % Must be first call to UL
    result = calllib('mccFuncLib','cbDeclareRevision',6.10);
    % Print errors to a window (otherwise it silently fails!)
    calllib('mccFuncLib','cbErrHandling',ULconstants.PRINTALL,ULconstants.DONTSTOP);
    % Setup the port
    if in_or_out == ULconstants.DIGITALOUT % 1
        if isempty(t.channels)
            t.channels = ULconstants.AUXPORT;
        end
        ptr = calllib('mccFuncLib','cbDConfigPort',t.boardNum,t.channels,ULconstants.DIGITALOUT);
    elseif in_or_out == ULconstants.DIGITALIN %2
        [~,r2] = calllib('mccFuncLib','cbGetConfig',ULconstants.DIGITALINFO,t.boardNum,0,ULconstants.DIDEVTYPE,0);
        if isempty(t.channels)
            if r2==1
                t.channels = ULconstants.AUXPORT;
            else
                t.channels = ULconstants.FIRSTPORTB;
            end
        end        
        ptr = calllib('mccFuncLib','cbDConfigPort',t.boardNum,t.channels,ULconstants.DIGITALIN);
        % Also allocate some memory
        t.memoryPtr = calllib('mccFuncLib','cbWinBufAlloc',2000*3+1000); % Allocate 3 seconds @ 2000 Hz + spare 1000
    end
    
elseif in_or_out == ULconstants.ANALOGIN
    % Call the mex file to initialize
    MCDAQMex(0,t.numChannelsTotal);
else
    error('Not yet supported');
end

t = class(t,'MCDAQ');