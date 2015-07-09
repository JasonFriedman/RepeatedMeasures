% LOGFILEGENERATOR - simple class to write to a log file

function l = logfilegenerator

l.log_fp = [];

l.log_fp = fopen('logfile.txt','w');

l.devices = struct;

l = class(l,'logfilegenerator');
