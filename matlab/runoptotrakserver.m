% RUNOPTOTRAKSERVER - run the optotrak server in a separate process with standard settings
% i.e., 200Hz, port 3000, debug mode

! matlab -nojvm -r "o = optotrakserver(3000,200,1);listen(o)" &
