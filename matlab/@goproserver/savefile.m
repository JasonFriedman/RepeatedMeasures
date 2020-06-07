% SAVEFILE - copy the 

function savefile(gs)

% pause for 2 seconds to make sure it has had time after stopping
pause(2);
% Copy the file via wifi from the gopro (if requested)
% Find the filename on the gopro (the latest files)
[~,dirname,filename] = readmedia(1);

if gs.downloadfiles
    % Download it (may be slow)
    
    [pathstr,~] = fileparts(gs.lastFilename);
    % If the directory does not exist, create it
    if ~exist(pathstr,'dir')
        mkdir(pathstr);
    end
    saved = downloadfile(dirname,filename,[gs.lastFilename '.mp4']);
else
    fprintf('Did not copy file over due to settings. To copy later, the file %s is at: %s/%s\n',[gs.lastFilename '.mp4'],dirname,filename);
    fp = fopen([gs.lastFilename '.txt'],'w');
    fprintf(fp,'curl ''http://10.5.5.9:8080/videos/DCIM/%s/%s'' -o %s.mp4',dirname,filename,gs.lastFilename);
    fclose(fp);
end
