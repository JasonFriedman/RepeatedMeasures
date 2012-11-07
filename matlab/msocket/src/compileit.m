% Note: this only works in UNIX like systems
% Run mex -setup first, and select the C compiler to
% be a compiler that includes C++ routines

files = {'msconnect.c',...
  'msaccept.c',...
  'mslisten.c',...
  'msclose.c',...
  'mssendraw.c',...
  'msrecvraw.c'};

% Create libraries for above files
for i1=1:length(files)
  cmd=sprintf('mex -I. %s ',...
              files{i1});
  cmd
  eval(cmd);
end

% Compile object code
mex -I. -c matvar.cpp
mex -I. -c msrecv.cpp
mex -I. -c mssend.cpp
mex -cxx msrecv.o matvar.o
mex -cxx mssend.o matvar.o

% This only works on x86_64 and x86 linux systems for now
if strcmp(computer,'GLNXA64')
  suffix='mexa64';
else
  suffix='mexglx';
end

system(sprintf('mv *.%s ..',suffix));
system('rm -rf *.o');

