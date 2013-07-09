% MCDAQMEX - mex file for reading analog inputs from a MC DAQ card
%
% MCDAQMEX(0) - setup the card. Must be run before any other commands
% MCDAQMEX(1,boardNum,channel,gain)
% MCDAQMEX(2,boardNum,minChannel,maxChannel,gain)
%
% boardNum is the board number (as defined in Instacal)
%
% channel is the channel to sample from (starts from 0)
% With the second options, all channels between minChannel and maxChannel will be sampled (inclusive)
%
% gain is the measurement range (see cbw.h for the values, and check
% in the manual for your DAQ card to see which values are supported)
% e.g. 4 = -1 to +1 V
%      0 = -5 to +5 V
%      1 = -10 to +10 V
function MCDAQMex(nargin)

error('MCDAQMex is only supported on Windows (32 and 64 bit)');