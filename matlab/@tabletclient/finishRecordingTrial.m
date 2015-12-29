% FINISHRECORDINGTRIAL - tell the device to do whatever it needs at the end of a trial
% In this case, disconnect the tablet
%
% finishRecordingTrial(tc)

function finishRecordingTrial(tc)

codes = messagecodes;

m.parameters = [];
m.command = codes.TABLET_closeInterface;
sendmessage(tc,m,'closeTabletInterface');