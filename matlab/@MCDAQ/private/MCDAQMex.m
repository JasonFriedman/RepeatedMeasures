% MCDAQMEX - mex file for reading analog inputs from a MC DAQ card
%
% MCDAQMex(0,numChannelsTotal) - setup the card for analog input. Must be run before any
% other commands. numChannelsTotal is the total number of input channels.
% This usually determines whether the board will be single-sided or differential
% MCDAQMex(0,numChannelsTotal,digitalChannels) - as above, but also setup
% for digital output. digitalChannels is a number, e.g. AUXPORT = 1 (see
% cbw.h for the full list)
%
% MCDAQMex(1,boardNum,channel,gain) % Read from a single analog channel
%
% MCDAQMex(2,boardNum,minChannel,maxChannel,gain) % Read from multiple analog channels
%
% MCDAQMex(3,boardNum,channels,value) % Write to digitial output
%
% boardNum is the board number (as defined in Instacal)
%
% channel is the channel to sample from (starts from 0)
% With the second options, all channels between minChannel and maxChannel will be sampled (inclusive)
%
% For digital output, the channels is a number describing the ports (e.g. 1
% = AUXPORT, see cbw.h for all options) and value specifies the channels to
% send. e.g. 1 = just DIO0, 5 = DIO0 and DIO2, 255 = all DIO0 -> DIO7
%
% gain is the measurement range (see cbw.h for the values, and check
% in the manual for your DAQ card to see which values are supported)
% e.g. 4 = -1 to +1 V
%      0 = -5 to +5 V
%      1 = -10 to +10 V
function MCDAQMex(nargin)

error('MCDAQMex is only supported on Windows (32 and 64 bit)');