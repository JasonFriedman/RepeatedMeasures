% RUNDAQSERVER - run a DAQ server for digital input (RT) on port 3016 in another matlab process
function runDAQserver

! matlab -nojvm -r "d = DAQserver(3016,6000,1:3,'D:\cbw',2,[],[],0);listen(d)" &
