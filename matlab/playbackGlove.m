function varargout = playbackGlove(varargin)
% PLAYBACKGLOVE MATLAB code for playbackGlove.fig
%      PLAYBACKGLOVE, by itself, creates a new PLAYBACKGLOVE or raises the existing
%      singleton*.
%
%      H = PLAYBACKGLOVE returns the handle to a new PLAYBACKGLOVE or the handle to
%      the existing singleton*.
%
%      PLAYBACKGLOVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLAYBACKGLOVE.M with the given input arguments.
%
%      PLAYBACKGLOVE('Property','Value',...) creates a new PLAYBACKGLOVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before playbackGlove_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to playbackGlove_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help playbackGlove

% Last Modified by GUIDE v2.5 09-Jul-2015 10:17:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @playbackGlove_OpeningFcn, ...
    'gui_OutputFcn',  @playbackGlove_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before playbackGlove is made visible.
function playbackGlove_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to playbackGlove (see VARARGIN)

% Choose default command line output for playbackGlove
handles.output = hObject;

for k=1:23
    handles.names{k} = get(handles.(['ja' num2str(k)]),'String');
end

handles.currenttime = 0;
handles.playstate = 0;
handles.xrot = 90;
handles.yrot = 0;
handles.zrot = 0;


% Update handles structure
guidata(hObject, handles);
xrotSlider_Callback(handles.xrotSlider,[],handles);
yrotSlider_Callback(handles.yrotSlider,[],handles);
zrotSlider_Callback(handles.zrotSlider,[],handles);


% UIWAIT makes playbackGlove wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function plotgraph(handles)

if ~isfield(handles,'ja')
    return;
end

for k=23:-1:1
    ja_to_plot(k) = get(handles.(['ja' num2str(k)]),'Value');
end

showMarkers = get(handles.showMarkers,'Value');
plotTangVel = get(handles.tangVelBox,'Value') & get(handles.angularVelocityButton,'Value');

ja_to_plot = find(ja_to_plot);

if numel(ja_to_plot)==0
    delete(findobj(0,'type','axes'));
end

for k=1:(numel(ja_to_plot)+plotTangVel)
    n = subplot(numel(ja_to_plot)+plotTangVel,1,k,'Parent',handles.uipanel1);
    hold(n,'off');
    if plotTangVel && k==numel(ja_to_plot)+1
        tangvel = sqrt(sum(combinedvel.^2));
        plot(n,handles.time,tangvel);
        ylabel(n,'Tang vel');
    else
        if get(handles.angleButton,'Value')
            plot(n,handles.time,handles.ja(:,ja_to_plot(k)));
        else
            plot(n,handles.time,handles.vel(:,ja_to_plot(k)));
            if plotTangVel
                combinedvel(k,:) = handles.vel(:,ja_to_plot(k));
            end
        end
        ylabel(n,handles.names{ja_to_plot(k)});
    end
    if k==numel(ja_to_plot)
        xlabel(n,'time (s)');
    end
    hold(n,'on');
    a = axis(n);
    if handles.currenttime>0
        plot(n,[handles.currenttime handles.currenttime],[a(3) a(4)],'r');
    end
    if showMarkers
        m = find(handles.markers);
        for z=1:numel(m)
            plot(n,[handles.time(m(z)) handles.time(m(z))],[a(3) a(4)],'k');
        end
    end
    axis(n,a);
end

renderFrame(handles,handles.currenttime);

% --- Outputs from this function are returned to the command line.
function varargout = playbackGlove_OutputFcn(~,~,handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in one of the joint angles
function ja_Callback(~,~, handles,~)
% hObject    handle to ja1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ja1
plotgraph(handles);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject,~, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,pathname] = uigetfile('cg_*.csv');
if filename(1)==0
    return;
end
data = load([pathname filename]);

% Start at time zero
handles.time = data(:,1) - data(1,1);
handles.ja = data(:,2:24);

% Calculate velocities
samplerate = 1/mean(diff(data(:,1)));
cutoff = 5; % Hz
[B,A] = butter(2,cutoff/(samplerate*0.5));
for k=1:23
    vel(:,k) = [0;diff(filtfilt(B,A,data(:,k)))./(1/samplerate)];
end
handles.vel = vel;
handles.markers = data(:,25);

guidata(hObject, handles);
handles = openRenderWindow(handles);
plotgraph(handles);
guidata(hObject, handles);

% --- Executes on button press in showMarkers.
function showMarkers_Callback(~,~,handles)
% hObject    handle to showMarkers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plotgraph(handles);


% --- Executes on button press in playPauseButton.
function playPauseButton_Callback(hObject, ~, handles)
% hObject    handle to playPauseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.playstate = get(hObject,'value');

if handles.playstate
    play(handles,hObject);
end

% Play until the end of the movement, or the pause button is pressed
function handles = play(handles,hObject)
thetime = GetSecs;
handles.starttime = thetime - handles.currenttime;

% Set a timer to draw the graph
handles.timer = timer(...
    'ExecutionMode', 'fixedRate', ...  % Run timer repeatedly
    'Period', 0.02, ...                % 50 fps
    'TimerFcn', {@keepPlaying,handles.figure1}); % Specify callback
guidata(hObject, handles);
start(handles.timer);


function keepPlaying(timerObject,~,fignum)


handles = guidata(fignum);
handles.playstate = get(handles.playPauseButton,'value');
handles.currenttime = GetSecs - handles.starttime;

if handles.playstate==0
    stop(handles.timer);
    delete(handles.timer);
elseif handles.currenttime >= handles.time(end)
    handles.currenttime = 0;
    handles.playstate = 0;
    stop(handles.timer);
    delete(handles.timer);
end

if(handles.currenttime<=handles.time(end))
    plotgraph(handles);
    set(handles.timeText,'String',sprintf('Time: %.2f',handles.currenttime));
end
guidata(fignum, handles);
drawnow;

function timeshift_Callback(hObject,~,handles,shiftAmount)
handles.currenttime = handles.currenttime + shiftAmount;
plotgraph(handles);
set(handles.timeText,'String',sprintf('Time: %.2f',handles.currenttime));
guidata(hObject, handles);
drawnow;


% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(~, ~, handles)
% hObject    handle to the selected object in uipanel2
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if get(handles.angleButton,'Value')
    set(handles.tangVelBox,'visible','off');
else
    set(handles.tangVelBox,'visible','on');
end

plotgraph(handles);
drawnow;


% --- Executes on button press in tangVelBox.
function tangVelBox_Callback(~, ~, handles)
% hObject    handle to tangVelBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

plotgraph(handles);

function handles = openRenderWindow(handles)

l = logfilegenerator();
inputparams.glove.gloveemulator = struct();
inputparams.tracker.fixedtracker = struct();

debug = 1;
handles.gtc = glovetrackerclient(inputparams,l,debug);

handles.gc = get(handles.gtc,'glove');
handles.gc = set(handles.gc,'data',[handles.time handles.ja]);
handles.gtc = set(handles.gtc,'glove',handles.gc);
InitializeMatlabOpenGL;

curScreen = 0;
cameralocation = [0 15 30]; % third is front / back ,second is up/down %[0 20 0];
center = [0 0 0];
up = [0 0 -1];

m = 2;
frustum.left = -m;
frustum.right = m;
frustum.bottom = -m;
frustum.top = m;
frustum.nearVal = 2;
frustum.farVal = 500;
ed = 0;

if isfield(handles,'winptr')
    sca;
end

handles.winptr=Screen('OpenWindow',curScreen,[255 255 255],[100 100 500 500]);

Screen('BeginOpenGL', handles.winptr);
global GL;

glMatrixMode( GL.PROJECTION );
glLoadIdentity;
glFrustum( frustum.left,frustum.right,frustum.bottom,frustum.top,frustum.nearVal,frustum.farVal);

% gluLookAt is the eye (xyz), the centre (xyz) and the up vector (xyz)
gluLookAt(cameralocation(1)+ed,cameralocation(2),cameralocation(3),center(1),center(2),center(3),up(1),up(2),up(3));

glMatrixMode( GL.MODELVIEW);
glClear(); % clear the buffer

% setup the lighting
lightPosition0 = [ 10.0 20.0 50.0 0.0 ];
lightPosition1 = [ 10.0 40.0 50.0 0.0 ];
glLightfv( GL.LIGHT0, GL.POSITION, lightPosition0 );
glLightfv( GL.LIGHT1, GL.POSITION, lightPosition1 );
glEnable( GL.LIGHT0 );
glEnable( GL.LIGHT1 );
% set shading
glShadeModel( GL.SMOOTH );
glEnable(GL.DEPTH_TEST);
glDepthFunc( GL.LEQUAL );

createHand(handles.gtc); %create the virtual hand
Screen('EndOpenGL', handles.winptr);

function renderFrame(handles,time)
positions = [0 0 0];
isflipped = 0;

vr.scale = [0.5 0.5 0.5];
vr.rotate = [0 0 0];
vr.translation = [-1.2 -8.1 21.6];
vr.translation = [-10.2 -8.1 21.6];
vr.stereomode = 0;
vr.eyedistance = 0.6;

vr.cameralocation = [0 20 0];
vr.center = [0 0 0];
vr.up = [0 0 -1];

[thissample,samplenum] = getsample(handles.gc,time);
jointangles = thissample(2:24);
Screen('BeginOpenGL', handles.winptr );
glClearColor(255,255,255,0.0);
glClear();
Screen('EndOpenGL', handles.winptr );
render_hand(handles.gtc, jointangles, positions, handles.orientations, vr, handles.winptr, isflipped)
%showPosition(gtc,thistrial,[],l,1);
Screen('Flip', handles.winptr);


% --- Executes on slider movement.
function xrotSlider_Callback(hObject, ~, handles)
% hObject    handle to xrotSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.xrot = round(get(hObject,'Value'));
set(handles.xrotText,'String',sprintf('xrot: %d',handles.xrot));
handles.orientations = [handles.xrot handles.yrot handles.zrot];
guidata(hObject, handles);
plotgraph(handles);

% --- Executes during object creation, after setting all properties.
function xrotSlider_CreateFcn(hObject, ~, ~)
% hObject    handle to xrotSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function yrotSlider_Callback(hObject, ~, handles)
% hObject    handle to yrotSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.yrot = round(get(hObject,'Value'));
set(handles.yrotText,'String',sprintf('yrot: %d',handles.yrot));
handles.orientations = [handles.xrot handles.yrot handles.zrot];
guidata(hObject, handles);
plotgraph(handles);


% --- Executes during object creation, after setting all properties.
function yrotSlider_CreateFcn(hObject, ~, ~)
% hObject    handle to yrotSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function zrotSlider_Callback(hObject, ~, handles)
% hObject    handle to zrotSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.zrot = round(get(hObject,'Value'));
set(handles.zrotText,'String',sprintf('zrot: %d',handles.zrot));
handles.orientations = [handles.xrot handles.yrot handles.zrot];
guidata(hObject, handles);
plotgraph(handles);


% --- Executes during object creation, after setting all properties.
function zrotSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zrotSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
