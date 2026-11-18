% PROTOCOLNEW - start building a protocol
%
% p = protocolNew
% p = protocolNew('monitorWidth',43.2,'viewingDistance',40,...)   with setup options
%
% Typical use (see protocolBuilderExample.m, and protocolOptions for what is available):
%
%   p = protocolNew('monitorWidth',43.2,'viewingDistance',40);
%   p = protocolDevice(p,'tablet','maxx',48767,'maxy',30479);
%   p = protocolSetup(p,'images',{'instructions.png'},'beeps',{[1000 0.1]});
%   p = protocolCommon(p,'starttrial','keyboard');
%   p = protocolInstruction(p,'Press space to start');
%   conditions = protocolDesign('side',{'left','right'},'soa',[0 50 150]);
%   p = protocolBlock(p,conditions,@myTrial,'repetitions',12,'name','block1');
%   protocolSave(p,'protocols/subject1.xml');
%
% p.description is the same struct that the generateProtocol.m files build by hand
% (experimentDescription), so anything the builder does not cover can still be set
% directly, e.g. p.description.trial{3}.dontclear = 1;
function p = protocolNew(varargin)
p.description.setup = struct;
p.description.trial = {};
p.blocks = {};       % name of the block each trial belongs to (for the summary)
if nargin>0
    p = protocolSetup(p,varargin{:});
end
