% Generate the stimuli
function generateStimuli

if ~exist('stimuli','dir')
    mkdir('stimuli');
end

% Plot the graphs
toplot = 1;

for trial=1:3
    
    firststart = 2;
    if trial==1
        duration = [repmat(2,20,1);ones(18,1)];
        peak_vel = [repmat(300,20,1);repmat(200,18,1)];
    elseif trial==2
        duration = [ones(18,1);repmat(2,16,1);repmat(0.5,16,1)];
        peak_vel = [repmat(150,18,1);repmat(300,16,1);repmat(200,16,1)];
    elseif trial==3
        duration = [repmat(3,10,1);ones(14,1);repmat(0.25,20,1);repmat(0.5,16,1)];
        peak_vel = [repmat(200,10,1);repmat(150,14,1);repmat(250,20,1);repmat(400,20,1)];
    end
    starttime = [firststart; cumsum(duration)+firststart];
    endtime = starttime(2:end);
    starttime = starttime(1:end-1);
    duration = endtime - starttime;
    freq = 1 ./ (2*duration);
    
    % freq should be 1 / (2*duration)
    
    tf = 60;
    samplerate = 60; %Hz
    
    result = zeros(1,tf*samplerate);
    result_integrated = zeros(1,tf*samplerate);
    t = 1/samplerate:1/samplerate:tf;
    for k=1:numel(starttime)
        if k==1
            thisstarttime = starttime(k);
        else
            thisstarttime = thisendtime;
        end
        thisendtime = endtime(k)-starttime(k) + thisstarttime;
        
        thist = thisstarttime:1/samplerate:thisendtime;
        thissine = (mod(k,2)*2-1) * peak_vel(k) * sin(2*pi*freq(k)*(thist - thisstarttime));
        % should really be cos but then would need to shift it
        thisintegrated = -(mod(k,2)*2-1) * peak_vel(k) ./ (2*pi*freq(k)) .* sin(2*pi*freq(k) * (thist - thisstarttime));
        samplenums = round(thist * samplerate);
        result(samplenums) = thissine;
        result_integrated(samplenums) = thisintegrated;
    end
    
    % -400 is the bottom of the screen, 500 is the top of the screen
    
    % rectangle details
    height = result_integrated ./ 900 + 4/9;
    if toplot
        figure;
        plot(t,height);
    end
    
    x = repmat(0.3,numel(height),1);
    % reduce the height so that max value is 0.7 (to avoid hitting the
    % frame at the top of the screen)
    height = height * 0.7;
    
    y = 0.9 - height;
    width = repmat(0.15,numel(height),1);
    tofill = ones(numel(height),1);
    csvwrite(['stimuli/rectangles' num2str(trial) '.csv'],[x y' width height' tofill]);
end

