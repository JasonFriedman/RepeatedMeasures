% usingUSB - is the liberty server using USB

function result = usingUSB(l)

if l.COMport==-1
    result = 1;
else
    result = 0;
end