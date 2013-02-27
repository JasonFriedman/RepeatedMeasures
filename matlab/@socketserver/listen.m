% LISTEN - listen for connections, and act on them
% 
% listen(s)

function listen(s)

fp = 0;
sock = -1;
codes = messagecodes;
filename = '';
databuffer = [];
currentSample = 0;
lastframe = 0;
dataSummary = []; % This can record a "summary" of the data,
                  % e.g. final position, average position, etc
                  % (it is calculated by the subclass) 

% Keep listening until a connection is received
while sock == -1
  sock = msaccept(s.socket,0.1);
  %WaitSecs(0.000001);
  drawnow;
end
fprintf('Accepted a connection\n');


% Send an acknowledgement
m.accepted = 1;
mssend(sock,m);
marker = 0;
if isdebug(s)
    fprintf('Sent acknowledgement\n');
end
 
while 1
  % If currentsample is > 0, we are recording, so take a sample if the
  % frame number has changed.
 
  if currentSample>0
    if currentSample > maximumframes
        error('Buffer overflow!');
    end
    %currenttime = GetSecs;
    %if (currenttime - lastsampletime) < 0.5*(1 / s.framerate)
    %    WaitSecs(0.9*((1/s.framerate) - (currenttime - lastsampletime) ));
    %end
    [data,framenumber] = getsample(s,nummarkers);
    if (framenumber-lastframe) > 0.0001 % account for rounding errors
      sampletime(currentSample) = GetSecs;
      databuffer(currentSample,1:end-1) = data;
      databuffer(currentSample,end) = marker;
      marker=0;
      lastframe = framenumber;
      % increment sample number if recording
      if maximumframes < inf
          currentSample = currentSample + 1;
      end
    % else
    % fprintf('Ignoring new frame because framenumber is not greater (difference=%.2f)\n',framenumber - lastframe);
    end
  end
  
  success = -1;
  while success<0
    %[received,success] = msrecv(sock,0.0000001);
    [received,success] = msrecv(sock,0.00001);
    %WaitSecs(0.000001);
    drawnow;
    if currentSample>0 && success<0
      success=0;
      received.command = codes.dummy;
    end
  end
  switch received.command
   case {codes.dummy}
    % do nothing
   case {codes.getsample}
      if isempty(received.parameters) || isempty(received.parameters{1})
          nummarkers = NaN;
      else
          nummarkers = received.parameters{1};
      end
    % return the last sample - already done above
    % use currentSample because the last sample may have been
    % empty
    %[data,framenumber] = getsample(s,nummarkers);
    if currentSample>1
        data = databuffer(currentSample-1,:);
    elseif currentSample==1
        data = databuffer(currentSample,:);
    else
        data = [];
    end
    success = mssend(sock,data);
    %Get previous sample from the databuffer
    case {codes.getprevioussample}
       
    if isempty(received.parameters) || isempty(received.parameters{1})
          timelag = NaN;
      else
          timelag = received.parameters{1};
    end
       if currentSample>0 && ~isnan(timelag)
           
           if timelag==0
                previoussample = currentSample-1;
           else
               previoussample = find(sampletime(1:currentSample-1) <= sampletime(currentSample-1)-timelag,1,'last');
           end
           if ~isempty(previoussample)
               data = databuffer(previoussample,:);
           else
              data = []; 
           end
       else
           data = [];
       end
      %numel(previoussample) % chekcing returned data
     %data(2:numel(data))
    success = mssend(sock,data);
   case {codes.closesocket}
    msclose(sock);
    if isdebug(s)
      fprintf('Closed socket\n');
    end
    if fp>0
        fclose(fp);
    end	
    break;
    case {codes.initializeDevice}
        s = initializeDevice(s);
        
    case {codes.closeDevice}
        closedevice(s);
        break;
    case {codes.setuprecording}
      if isempty(received.parameters{1})
          filename = NaN;
      else
          [pathstr,name] = fileparts(received.parameters{1});
          filename = [pathstr '/' getprefix(s) name '.csv'];
          % If the directory does not exist, create it
          if ~exist(pathstr,'dir')
              mkdir(pathstr);
          end
          % Open the file for writing
          fp = fopen(filename,'wt');
          if fp==-1
              error(['Cannot open file ' filename ' for writing']);
          end
      end
    
      nummarkers = received.parameters{2};
      maximumtime = received.parameters{3};
      maximumframes = max([1 ceil(maximumtime * s.framerate)]);
      if isempty(maximumframes) || isempty(nummarkers)
          error('Something is wrong - can''t allocate an empty array');
      end
      
      datalength = getdatalength(s,nummarkers);
      databuffer = zeros(maximumframes,datalength);
      sampletime = zeros(maximumframes,1);
      
      if isdebug(s)
        fprintf('Set filename to %s, preallocated array of size %d x %d \n',...
                filename,maximumframes,datalength);
      end
      setupRecording(s,nummarkers);
      
    case {codes.startrecording}
      % reset maximumframe, in case startwithoutrecord was run in the meantime
     maximumframes = max([1 ceil(maximumtime * s.framerate)]);
    lastframe = 0;
    if isempty(filename)
      error('Must first set filename before starting to record');
    end
    if isdebug(s)
      fprintf('Starting recording\n');
    end
   currentSample = 1;
   s = startRecording(s); 
   
   case {codes.startwithoutrecord}
     lastframe = 0;
     if isdebug(s)
         fprintf('Starting sampling without recording\n');
     end
     nummarkers = received.parameters;
     if isempty(databuffer)
         % create a databuffer for one record
         datalength = getdatalength(s,nummarkers);
         databuffer = zeros(1,datalength);
         sampletime = 0;
    end

     currentSample = 1;
     s = startRecording(s);
     maximumframes = inf;
    case {codes.stoprecording}
      if isdebug(s)
          fprintf('Stopping recording\n');
      end
      s = stopRecording(s);
      
      if maximumframes < inf
          % Cut data to actual recorded size
          databuffer = databuffer(1:currentSample-1,:);
          % Do some calculations on the data
          dataSummary = doCalculations(s,databuffer);
      end
      currentSample = 0;
    case {codes.savefile}
        if ~isempty(dataSummary) && isstruct(dataSummary) && isfield(dataSummary,'toSave')
            thisdata = dataSummary.toSave;
        else
            thisdata = databuffer;
        end
    if ~isnan(filename(1))
        % Write to disk
        for i=1:size(thisdata,1)
            fprintf(fp,'%.8f',thisdata(i,1));
            for j=2:size(thisdata,2)
                fprintf(fp,',%.8f',thisdata(i,j));
            end
            fprintf(fp,'\n');
        end
        fclose(fp);
        fp = -1;
        success = mssend(sock,1);
        if isdebug(s)
            fprintf('Return a value to indicate end of savefile, result %d\n',success);
        end
    end
    if isdebug(s)
        fprintf('Finished saving to disk\n');
     end
    filename = '';
   case {codes.getDataSummary}
    success = mssend(sock,dataSummary);
    if isdebug(s)
      fprintf('Sent data summary\n');
    end
   case {codes.markEvent}
    marker = received.parameters;
    if isdebug(s)
	fprintf('Received request to mark event (marker %d)\n',marker);
    end
      otherwise
    returnValue = runcommand(s,received.command,received.parameters);
    % If something has been returned, send it back
    if isstruct(returnValue) || isempty(returnValue) || ~isnan(returnValue(1))
      success = mssend(sock,returnValue);
%      if isdebug(s)
%        fprintf('Return a value, result %d\n',success);
%      end
    end
  end
end
