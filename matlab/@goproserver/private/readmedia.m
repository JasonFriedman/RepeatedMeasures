% Read all the media off the sd card of the go pro

function files = readmedia(latest)

data = webread('http://10.5.5.9:8080/gp/gpMediaList');

count = 0;
for m=1:numel(data.media)
    for k=1:numel(data.media(m).fs)
        count = count+1;
        files.dirnames{count,1} = data.media(m).d;
        files.filenames{count,1} = data.media(m).fs{k}.n;
        files.created(count,1) = str2double(data.media(m).fs{k}.cre);
        files.modified(count,1) = str2double(data.media(m).fs{k}.mod);
        if isfield(data.media(m).fs{k},'glrv')
            files.glrv(count,1) = str2double(data.media(m).fs{k}.glrv);
        else
            files.glrv(count,1) = NaN;
        end
        if isfield(data.media(m).fs{k},'ls')
            files.ls(count,1) = str2double(data.media(m).fs{k}.ls);
        else
            files.ls(count,1) = NaN;
        end
        files.s(count,1) = str2double(data.media(m).fs{k}.s);
    end
end

files.createdTime = datetime(files.created,'ConvertFrom','posixtime');
files.modifiedTime = datetime(files.modified,'ConvertFrom','posixtime');

if nargin==1 && latest==1
    % just return the filename of the latest
    [~,ind] = max(files.created);
    fn = [files.dirnames{ind} '/' files.filenames{ind}];
    files = fn;
end



