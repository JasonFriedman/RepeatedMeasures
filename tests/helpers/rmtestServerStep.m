% RMTESTSERVERSTEP - process one message in a simulated device server
%
% rmtestServerStep(sock,received)
%
% This is an in-process version of the loop in @socketserver/listen.m: it takes one
% sample (if sampling is on) and then handles the message. It calls the real methods of
% the server class (getsample, getdatalength, getprefix, doCalculations, runcommand ...),
% so the server classes that do not need hardware (keyboardserver, mouseserver) are
% exercised by the tests as well.
function rmtestServerStep(sock,received)
w = rmtestWorld;
if sock<1 || sock>numel(w.servers)
    error('rmtest:msocket','Message sent to a socket that is not connected (%d)',sock);
end
st = w.servers{sock};
s = st.server;
codes = messagecodes;
framerate = st.framerate;

% --- sampling (same as the top of the loop in listen.m) ---
if st.currentSample>0
    [data,framenumber] = getsample(s,st.nummarkers);
    if (framenumber-st.lastframe) > 0.0001 || st.marker>0
        st.sampletime(st.currentSample) = GetSecs;
        st.databuffer(st.currentSample,1:end-1) = data;
        st.databuffer(st.currentSample,end) = st.marker;
        st.marker = 0;
        if ~isnan(framenumber)
            st.lastframe = framenumber;
        end
        if st.maximumframes < inf
            st.currentSample = st.currentSample + 1;
        end
    end
end

% --- message handling (same as the switch in listen.m) ---
switch received.command
    case {codes.dummy}
    case {codes.getsample}
        if ~(isempty(received.parameters) || ~iscell(received.parameters) || isempty(received.parameters{1}))
            st.nummarkers = received.parameters{1};
        end
        if st.currentSample>1
            data = st.databuffer(st.currentSample-1,:);
        elseif st.currentSample==1
            data = st.databuffer(st.currentSample,:);
        else
            data = [];
        end
        st.queue{end+1} = data;
    case {codes.getprevioussample}
        if isempty(received.parameters) || isempty(received.parameters{1})
            timelag = NaN;
        else
            timelag = received.parameters{1};
        end
        data = [];
        if st.currentSample>1 && ~isnan(timelag)
            if timelag==0
                previoussample = st.currentSample-1;
            else
                previoussample = find(st.sampletime(1:st.currentSample-1) <= st.sampletime(st.currentSample-1)-timelag,1,'last');
            end
            if ~isempty(previoussample)
                data = st.databuffer(previoussample,:);
            end
        end
        st.queue{end+1} = data;
    case {codes.closesocket}
        st.connected = 0;
    case {codes.initializeDevice}
        s = initializeDevice(s);
    case {codes.closeDevice}
        closedevice(s);
        st.closed = 1;
    case {codes.setuprecording}
        if isempty(received.parameters{1})
            st.filename = NaN;
        else
            [pathstr,name] = fileparts(received.parameters{1});
            st.filename = [pathstr '/' getprefix(s) name '.csv'];
            if ~exist(pathstr,'dir')
                mkdir(pathstr);
            end
            fp = fopen(st.filename,'wt');
            if fp==-1
                error(['Cannot open file ' st.filename ' for writing']);
            end
            fclose(fp);
        end
        st.nummarkers = received.parameters{2};
        st.maximumtime = received.parameters{3};
        st.maximumframes = max([1 ceil(st.maximumtime * framerate)]);
        % The simulated server takes one sample per message, so it never needs the
        % full preallocation (which is infinite for recordingTime=inf)
        datalength = getdatalength(s,st.nummarkers);
        st.databuffer = zeros(1,datalength);
        st.sampletime = 0;
        setupRecording(s,st.nummarkers);
    case {codes.startrecording}
        st.maximumframes = max([1 ceil(st.maximumtime * framerate)]);
        if isinf(st.maximumframes)
            st.maximumframes = 1e9;
        end
        st.lastframe = 0;
        if isempty(st.filename)
            error('Must first set filename before starting to record');
        end
        st.currentSample = 1;
        s = startRecording(s);
    case {codes.startwithoutrecord}
        st.lastframe = 0;
        st.nummarkers = received.parameters;
        if isempty(st.databuffer)
            datalength = getdatalength(s,st.nummarkers);
            st.databuffer = zeros(1,datalength);
            st.sampletime = 0;
        end
        st.currentSample = 1;
        s = startRecording(s);
        st.maximumframes = inf;
    case {codes.stoprecording}
        s = stopRecording(s);
        if st.maximumframes < inf
            st.databuffer = st.databuffer(1:st.currentSample-1,:);
            st.dataSummary = doCalculations(s,st.databuffer);
        end
        st.currentSample = 0;
    case {codes.savefile}
        if ~isempty(st.dataSummary) && isstruct(st.dataSummary) && isfield(st.dataSummary,'toSave')
            thisdata = st.dataSummary.toSave;
        else
            thisdata = st.databuffer;
        end
        if ~isnan(st.filename(1))
            dlmwrite(st.filename,thisdata,'precision',10);
            st.savedFiles{end+1} = st.filename;
            st.queue{end+1} = 1;
        end
        st.filename = '';
    case {codes.getDataSummary}
        st.queue{end+1} = st.dataSummary;
    case {codes.markEvent}
        st.marker = received.parameters;
    otherwise
        [returnValue,changedParameters,changedValues] = runcommand(s,received.command,received.parameters);
        if isstruct(returnValue) || isempty(returnValue) || ~isnan(returnValue(1))
            st.queue{end+1} = returnValue;
        end
        if ~isempty(changedParameters)
            for k=1:numel(changedParameters)
                s = set(s,changedParameters{k},changedValues{k});
            end
        end
end
st.server = s;
% Other stubs may have changed the world (e.g. the clock) while we were working
w = rmtestWorld;
w.servers{sock} = st;
rmtestWorld(w);
