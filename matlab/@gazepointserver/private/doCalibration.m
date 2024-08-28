function doCalibration(s,delay)

if nargin<2
    delay = 20;
end

writeline(s, '<SET ID="CALIBRATE_SHOW" STATE="1" />');
writeline(s, '<SET ID="CALIBRATE_START" STATE="1" />');
pause(delay);
writeline(s, '<SET ID="CALIBRATE_SHOW" STATE="0" />');
writeline(s, '<SET ID="CALIBRATE_START" STATE="0" />');
writeline(s, '<GET ID="CALIBRATE_RESULT_SUMMARY" />');
