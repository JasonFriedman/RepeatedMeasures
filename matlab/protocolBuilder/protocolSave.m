% PROTOCOLSAVE - write a protocol to an XML file and validate it
%
% filename = protocolSave(p,filename)
% filename = protocolSave(p,filename,'validate',false)   only write the file
% filename = protocolSave(p,filename,'quiet',true)       do not print the summary
%
% The file is validated in the same way as in the generateProtocol.m files
% (e = experiment(filename,...); validate(e)), which also checks that the stimuli
% (images, sounds, ...) exist, so run it from the directory of the experiment.
% The log file of the validation is written to the directory testData.
function filename = protocolSave(p,filename,varargin)
opts = pbToStruct(varargin,'protocolSave');
if ~isfield(opts,'validate')
    opts.validate = true;
end
if ~isfield(opts,'quiet')
    opts.quiet = false;
end
if isempty(p.description.trial)
    error('protocolBuilder:missing','The protocol has no trials');
end
schema = protocolSchema;
if isempty(intersect(fieldnames(p.description.setup),fieldnames(schema.devices)))
    error('protocolBuilder:missing','The protocol has no recording device: add one with protocolDevice (e.g. protocolDevice(p,''keyboard''))');
end
folder = fileparts(filename);
if ~isempty(folder) && ~exist(folder,'dir')
    mkdir(folder);
end
description = p.description;
if isfield(description,'common') && isempty(fieldnames(description.common))
    description = rmfield(description,'common');
end
% struct2xml uses the name of the variable as the name of the root element
experimentDescription = description;
tree = struct2xml(experimentDescription);
save(tree,filename);
if opts.validate
    e = experiment(filename,'testData');
    try
        validate(e);
    catch err
        closelog(e);
        error('protocolBuilder:invalid','%s was written but is not valid: %s',filename,err.message);
    end
    closelog(e);
end
if ~opts.quiet
    fprintf('Wrote %s\n',filename);
    protocolSummary(p);
end
