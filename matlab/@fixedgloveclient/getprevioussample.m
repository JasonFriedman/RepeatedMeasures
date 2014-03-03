% GETSAMPLE - return the same data every frame

function data = getprevioussample(gc,timelag)

data = [GetSecs gc.jointangles];