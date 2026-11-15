% RMTESTSTARTSERVER - attach a device server object to the simulated msocket
%
% rmtestStartServer(serverObject,port,framerate)
%
% serverObject is any child of socketserver (e.g. keyboardserver(3002,1000,0) or
% rmtestdeviceserver(...)). Instead of calling listen(serverObject), which blocks and
% needs a second MATLAB, the simulated msocket calls rmtestServerStep for every message
% that a client sends, which runs the same logic as @socketserver/listen.m.
% framerate (default 1000) should be the frame rate the server was created with.
function rmtestStartServer(serverObject,port,framerate)
if nargin<3 || isempty(framerate)
    framerate = 1000;
end
w = rmtestWorld;
st.port = port;
st.framerate = framerate;
st.server = serverObject;
st.queue = {};
st.connected = 0;
st.filename = '';
st.databuffer = [];
st.sampletime = [];
st.currentSample = 0;
st.lastframe = 0;
st.maximumframes = inf;
st.maximumtime = 0;
st.dataSummary = [];
st.marker = 0;
st.nummarkers = NaN;
st.closed = 0;
st.savedFiles = {};
% replace a server that is already on this port
for k=1:numel(w.servers)
    if w.servers{k}.port == port
        w.servers{k} = st;
        rmtestWorld(w);
        return;
    end
end
w.servers{end+1} = st;
rmtestWorld(w);
