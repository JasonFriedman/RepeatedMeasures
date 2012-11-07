%This function will set the jointangles of the cyberglove
%It will set the tracker positions and orientation as well
%and draw the hand offscreen

function render_hand( jointangles, positions, orientations, translation ,scale, cameraRotation, winptr,isflipped,stereo,eye_distance)

ALL_AT_ONCE = 0;

if nargin<9
    stereo = 0; % i.e. just render in mono
end

positions(1) = positions(1) * scale(1)  +  translation(1);
positions(2) = positions(2) * scale(2)  +  translation(2);
positions(3) = positions(3) * scale(3)  +  translation(3);

global GL;
Screen('BeginOpenGL', winptr);
% We only want lighting for drawing the glove
glEnable( GL.LIGHTING );
if ~ALL_AT_ONCE
    % pass the glove joint angles
    Glove_Rendering(1, jointangles);
    % pass the position and orientation of the fastrak
    %orientations
    Glove_Rendering(3, positions, orientations);
end

if stereo==0
    glClear();
    if ALL_AT_ONCE
        Glove_Rendering(10,jointangles,positions,orientations,[0 0 0],[1 1 1],cameraRotation);
    else
        Glove_Rendering(4, [0 0 0],[1 1 1],cameraRotation);
    end
else
    for k=[0 1]
        if (k==1 && isflipped) || (k==0 && ~isflipped)
            ed = eye_distance/2;
        else
            ed = -eye_distance/2;
        end
        Screen('EndOpenGL', winptr);
        Screen('SelectStereoDrawBuffer', winptr, k);
        Screen('BeginOpenGL', winptr);
        glClear();
        if ALL_AT_ONCE
            Glove_Rendering(10,jointangles,positions,orientations,[ed 0 0],[1 1 1],cameraRotation);
        else
            Glove_Rendering(4, [ed 0 0],[1 1 1],cameraRotation);
        end
    end
end
glDisable( GL.LIGHTING );
Screen('EndOpenGL', winptr );