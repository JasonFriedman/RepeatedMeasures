% CALCULATEMVC
%
% [MVCs,MVCs_per_trial] = calculateMVC(subject,toplot)
%
% MVCtype = 1 -> sensors 1-4

function [MVCs,MVCs_per_trial] = calculateMVC(subject,toplot,parent)

MVCtype = 1;

if nargin<2
    toplot = 0;
end

% Load the force data
basedir = ['results/MVC/' num2str(subject) '/'];
files = dir([basedir 'DAQ_trial*.csv']);

if numel(files)==0
    error(['No files to calculate MVC from in the directory ' basedir]);
end

if toplot && nargin<3 || nargin>2 && isempty(parent)
    figure;
end

minval = inf; maxval = -inf;

for k=1:numel(files)
    data{k} = load([basedir files(k).name]);
    time = data{k}(:,1) - data{k}(1,1);
    if MVCtype==1
        MVCs_per_trial(k,:) = max(sum(data{k}(:,2:5),2));
    else
        error('Unknown MVC type');
    end
    if toplot
        if nargin>2 && ~isempty(parent)
            subplot(1,numel(files),k,'Parent',parent);
        else
            subplot(1,numel(files),k);
        end
        plot(time,data{k}(:,2),'b');
        hold on;
        plot(time,data{k}(:,3),'r');
        plot(time,data{k}(:,4),'g');
        plot(time,data{k}(:,5),'c');
                
        plot(time,sum(data{k}(:,2:5),2),'k');
        title(sprintf('MVC = %.1f N',MVCs_per_trial(k)));   
        axis tight;
        ylims = ylim;
        if ylims(1) < minval
            minval = ylims(1);
        end
        if ylims(2) > maxval
            maxval = ylims(2);
        end
        xlabel('time (s)');
        if k==1
            ylabel('Force (N)');
            legend({'Index','Middle','Ring','Little','Sum'},'Location','NorthWest');
        end
    end
end

MVCs = max(MVCs_per_trial);

if toplot
    maxval = maxval * 1.05;
    for k=1:numel(files)
        if nargin>2 && ~isempty(parent)
            subplot(1,numel(files),k,'Parent',parent);
        else
            subplot(1,numel(files),k);
        end
        ylim([minval maxval]);
        xlims = xlim;
        plot(xlims,[MVCs MVCs],'k--');
    end
end
  
    
