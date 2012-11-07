% Note: this only works in windows
% Run mex -setup first, and select the C compiler to
% be the Microsoft compiler

% This needs to be changed to the approproate directory
libdir = ...
  'c:\\Program\ Files\\MATLAB\\R2006a\\extern\\lib\\win32\\microsoft'

files = {'msconnect.c',...
  'msaccept.c',...
  'mslisten.c',...
  'msclose.c',...
  'mssendraw.c',...
  'msrecvraw.c'};

% Create libraries for above files
for i1=1:length(files)
  cmd=sprintf('mex -I. -DWIN32 -L"%s" %s ws2_32.lib',...
    libdir,files{i1});
  cmd
  eval(cmd);
end

% Compile object code
mex -I. -DWIN32 -c matvar.cpp
mex -I. -DWIN32 -c msrecv.cpp
mex -I. -DWIN32 -c mssend.cpp

cmd = sprintf('mex -I. -DWIN32 msrecv.obj matvar.obj ws2_32.lib -L"%s"',libdir);
cmd
eval(cmd);


cmd = sprintf('mex -I. -DWIN32 mssend.obj matvar.obj ws2_32.lib -L"%s"',libdir);
cmd
eval(cmd);

system('del *.obj');
system('move *.mexw32 ..');


