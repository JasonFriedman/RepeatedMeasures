% SETUPVIEWINGTRANSFORM - setup the opengl viewing transform

function setupViewingTransform(s,experimentdata,eye)

if eye==0
    ed = 0;
elseif (eye==2 && s.showFlipped) || (eye==1 && ~s.showFlipped)
    ed = experimentdata.vr.eyedistance/2;
else
    ed = -experimentdata.vr.eyedistance/2;
end

global GL;
Screen('BeginOpenGL', experimentdata.screenInfo.curWindow);
glMatrixMode( GL.PROJECTION );
glLoadIdentity;

if ~isempty(s.frustum)
    frustum = s.frustum;
else
    frustum = experimentdata.vr.frustum;
end

if ~isempty(s.cameralocation)
    cameralocation = s.cameralocation;
else
    cameralocation = experimentdata.vr.cameralocation;
end

if ~isempty(s.center)
    center = s.center;
else
    center = experimentdata.vr.center;
end

if ~isempty(s.up)
    up = s.up;
else
    up = experimentdata.vr.up;
end

% glFrustum is left,right,bottom,top, nearVal, farVal
if s.showFlipped
    % note that we just flip the left and right to make the image flipped
    %glFrustum( 3, -3, -3, 3, 3, 500 );
    glFrustum( frustum.right,frustum.left,frustum.bottom,frustum.top,frustum.nearVal,frustum.farVal);
else
    %glFrustum( -3, 3, -3, 3, 3, 500 );
    glFrustum( frustum.left,frustum.right,frustum.bottom,frustum.top,frustum.nearVal,frustum.farVal);
end

% gluLookAt is the eye (xyz), the centre (xyz) and the up vector (xyz)
gluLookAt(cameralocation(1)+ed,cameralocation(2),cameralocation(3),center(1),center(2),center(3),up(1),up(2),up(3));

%if viewpoint==1
%    gluLookAt( 0, 2, 22, 5,5,5, 0,1,0 );
%else % When from above
%    gluLookAt(0, 22, 0, 0,0,0, 0,0,-1 );
%end
glMatrixMode( GL.MODELVIEW);
%Screen('EndOpenGL', experimentdata.screenInfo.curWindow);
