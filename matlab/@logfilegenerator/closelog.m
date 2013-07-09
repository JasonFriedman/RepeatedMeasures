% CLOSELOG - close the log file
%
% closelog(e)
%

function closelog(e)

fclose(e.log_fp);
