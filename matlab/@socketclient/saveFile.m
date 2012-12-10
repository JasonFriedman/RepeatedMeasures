% SAVEFILE - instruct the server to save the file, wait for a response
% (after file has been saved)
% 
% success = saveFile(sc)

function success = saveFile(sc)

codes = messagecodes;

m.parameters = [];
m.command = codes.savefile;
sendmessage(sc,m,'savefile');
success = receivemessage(sc);
