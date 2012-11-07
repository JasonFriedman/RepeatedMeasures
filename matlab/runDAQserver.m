% RUNDAQSERVER - run a DAQ server on port 3000 in another matlab process
function runDAQserver

! matlab -nojvm -r "d = DAQserver(3015,6000,1:3,'D:\ExpPC_Files\Jason\MatlabExperiments\cbw');listen(d)" &
