% SETUPVR - do OpenGL setup required once per experiment for rendering the glove

function experimentdata = setupvr(e,experimentdata)

if isfield(e.devices,'glovetracker')
    Screen('BeginOpenGL', experimentdata.screenInfo.curWindow);
    createHand(e.devices.glovetracker); %create the virtual hand
    Screen('EndOpenGL', experimentdata.screenInfo.curWindow);
end
