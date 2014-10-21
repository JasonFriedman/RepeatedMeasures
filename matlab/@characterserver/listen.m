% LISTEN - listen for connections, and act on them
% 
% listen(s)

function listen(s)

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
  sock = msaccept(get(s.socketserver,'socket'),0.1);
  %WaitSecs(0.000001);
  drawnow;
end
fprintf('Accepted a socket character connection\n');

% Send an acknowledgement
mssendraw(sock,uint8(1));
if isdebug(s)
    fprintf('Sent acknowledgement (1)\n');
end

maximumframes = get(s.socketserver,'framerate');

databuffer = NaN * ones(maximumframes,2);
currentSample = 1;

while 1
  % If currentsample is > 0, we are recording, so take a sample if the
  % frame number has changed.
 
  success = -1;
  while success<0
    %[received,success] = msrecv(sock,0.0000001);
    [receivedraw,success] = msrecvraw(sock,2,0.00001); % receive 2 arguements over the "raw" socket
    %WaitSecs(0.000001);
    drawnow;
    if success>=0
        idle(s);
        received.command = receivedraw(1);
        received.parameters = receivedraw(2);
    end
  end
  switch received.command
   case {codes.dummy}
    % do nothing
   case {codes.getsample,codes.getprevioussample,codes.initializeDevice,codes.setuprecording,codes.startrecording,codes.startwithoutrecord,codes.stoprecording,codes.savefile,codes.getDataSummary}
       error('These are unsupported with a character server');
   case {codes.closesocket}
    msclose(sock);
    if isdebug(s)
      fprintf('Closed socket\n');
    end
    break;
    case {codes.closeDevice}
        closedevice(s);
        break;
   case {codes.markEvent}
    marker = received.parameters;
    databuffer(currentSample,:) = [GetSecs marker];
    currentSample = currentSample + 1;
    if currentSample > maximumframes
        fprintf('Not enough memory allocated - check that the sample rate is sufficient and the program is keeping up!!!!!!!\n');
    end

    if isdebug(s)
	fprintf('Received request to mark event (marker %d)\n',marker);
    end
      otherwise
    [returnValue,changedParameters,changedValues] = runcommand(s,received.command,received.parameters);
    % If something has been returned, send it back
    if isstruct(returnValue) || isempty(returnValue) || ~isnan(returnValue(1))
      success = mssendraw(sock,returnValue);
    end
    if ~isempty(changedParameters)
        for k=1:numel(changedParameters)
            s = set(s,changedParameters{k},changedValues{k});
        end
    end
  end
end
