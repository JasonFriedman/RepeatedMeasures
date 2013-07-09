% GETSAMPLE - return the same data every frame

function data = getsample(gc)

data = [GetSecs gc.position gc.orientation];