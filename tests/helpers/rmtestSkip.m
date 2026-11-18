% RMTESTSKIP - skip the current test (reported as skipped, not failed)
function rmtestSkip(reason)
error('rmtest:skip','%s',reason);
