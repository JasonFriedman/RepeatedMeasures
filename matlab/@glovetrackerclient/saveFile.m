% SAVEFILE - instruct the server to save the file, wait for a response
% (after file has been saved)
% 
% success = saveFile(gfc)

function success = saveFile(gfc)

success1 = saveFile(gfc.glove);
success2 = saveFile(gfc.tracker);

success = success1 && success2;
