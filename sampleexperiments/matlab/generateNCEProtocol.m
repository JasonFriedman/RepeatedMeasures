% GENERATENCEPROTOCOL - generate a protocol file for the NCE experiment
%
% generateNCEProtocol(inputDevice)
% inputDevice = 1 -> button box connected to a DAQ card (default)
% inputDevice = 2 -> keyboard (z and m keys)

function generateNCEProtocol(inputDevice)

if nargin<1 || isempty(inputDevice)
    inputDevice = 1;
end

filename = 'protocols/NCE.xml';

if inputDevice==1
    experimentDescription.setup.DAQ.server = 'localhost';
    experimentDescription.setup.DAQ.port = 3015;
    experimentDescription.setup.DAQ.numchannels = 2;
else
    experimentDescription.setup.keyboard.server = 'localhost';
    experimentDescription.setup.keyboard.port = 3002;
end

% Primes and targets are << and >>, the masks are WXXW or XWWX
experimentDescription.setup.symbols = {'<<','>>','WXXW','XWWX'};

% In the Klapp and Hinkley 2002 paper, the use:
%32ms prime
%96ms mask
%32ms delay
%16ms target

% On a 60 Hz monitor, we will have 16.666 Hz instead
% 2 frames - prime
% 6 frames - mask
% 2 frames - delay (nothing)
% 1 frame - target
% These should be changed for a different frequency monitor

n = 0;

% 2 blocks (for a real experiment, would use more!!!)
for blocks = 1:2
    % 2 targets
    for target = 1:2
        % half compatible, half not compatible
        for compatible = 0:1
            % 2 masks
            for mask = 1:2
                % 3 repetitons, so 2*2*2*3 = 24 trials per block
                for repetitions = 1:3
                    n = n+1;
                    if compatible
                        theprime = target;
                    else
                        theprime = mod(target,2)+1;
                    end
                    experimentDescription.trial{n}.stimulus.symbols.stimuli = [theprime 1 2;
                                                                                mask+2 3 8;
                                                                                target 11 11;];
                    experimentDescription.trial{n}.filename = sprintf('%d_%d_%d_%d',theprime,mask,target,repetitions');
                    if inputDevice==1                                                            
                        experimentDescription.trial{n}.starttrial.pedal.joystickType = 1;
                        experimentDescription.trial{n}.targetType = 'buttonPress';
                    else
                        experimentDescription.trial{n}.starttrial = 'keyboard';
                    end
                    experimentDescription.trial{n}.recordingTime = 3;
                end
            end
        end
    end
end

tree = struct2xml(experimentDescription);
save(tree,filename);

% load the protocol file and validate it
e = experiment(filename,'testData');
validate(e);