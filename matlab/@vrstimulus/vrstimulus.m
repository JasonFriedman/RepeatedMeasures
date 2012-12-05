% vrstimulus - class representing "vr" stimulus (rendered glove)

function [v,params] = vrstimulus(inputParams,experimentdata)

% calibrate parameters
calibrateparams.name = {'translatedelta','scaledelta','rotatedelta'};
calibrateparams.type = {'number','number','number'};
calibrateparams.description = {'Amount to shift hand when the arrow keys are pressed',...
    'Amount to change scale each time the key is pressed',...
    'Amount to rotate each time the key is pressed (in degrees)'};
calibrateparams.required = [0 0 0];
calibrateparams.default = {0.25,0.1,5};
calibrateparams.classdescription = 'Virtual reality calibrate';
calibrateparams.classname = 'calibrate';

% arrow parameters
arrowparams.name = {'direction','radius','height'}; arrowparams.type = {'number','number','number'};
arrowparams.description = {'Direction of the arrow (1=up, 2=down)','radius of the cone (the cylinder has a radius 1/4 of the cone radius)',...
    'length of the arrow'};
arrowparams.required = [0 0 0]; arrowparams.default = {1,2,10}; arrowparams.classdescription = 'Virtual reality arrow target';
arrowparams.classname = 'arrow';

% sphere parameters
sphereparams.name = {'radius'}; sphereparams.type = {'number'}; sphereparams.description = {'Radius of the sphere'};
sphereparams.required = 0; sphereparams.default = {5}; sphereparams.classdescription = 'Virtual reality sphere target';
sphereparams.classname = 'sphere';

% cube parameters
cubeparams.name = {'size'}; cubeparams.type = {'number'}; cubeparams.description = {'Side length of the cube'};
cubeparams.required = 0; cubeparams.default = {5}; cubeparams.classdescription = 'Virtual reality cube target';
wireframeCubeparams = cubeparams;
wireframeCubeparams.classname = 'wireframeCube';
solidCubeparams = cubeparams;
solidCubeparams.classname = 'solidCube';

% prism parameters
prismparams.name = {'size'}; prismparams.type = {'matrix_1_3'}; prismparams.description = {'Side lengths of the prism (1x3 matrix)'};
prismparams.required = 0; prismparams.default = {[5 5 2]}; prismparams.classdescription = 'Virtual reality prism target';
wireframeRectangularPrismparams = prismparams;
wireframeRectangularPrismparams.classname = 'wireframeRectangularPrism';
solidRectangularPrismparams = prismparams;
solidRectangularPrismparams.classname = 'solidRectangularPrism';

% target parameters
targetparams.name = {'onTime','offTime','position','color','type'};
targetparams.type = {'number','number','matrix_1_3','matrix_1_3',{arrowparams,sphereparams,wireframeCubeparams,solidCubeparams,wireframeRectangularPrismparams,solidRectangularPrismparams}};
targetparams.description = {'Time for the target to appear (-inf or 0 = from the start)','Time for the target to disappear (inf = never)',...
    'center position of the target (1x3 vector)','color of the target (1x3 vector, RGB)',...
    'The type of target (one of sphere, wireframeCube, solidCube, wireframeRectangularPrism, solidRectangularPrism or arrow)' };
targetparams.required = [0 0 0 0 1];
targetparams.default = {-inf,inf,[0 0 0],[1 0 0],[]};
targetparams.classdescription = 'Virtual reality targets';
targetparams.classname = 'target';

frustumparams.name = {'left','right','bottom','top','nearVal','farVal'};
frustumparams.type = {'number','number','number','number','number','number'};
frustumparams.description = {'left side','right side','bottom','top','near plane location','far plane location'};
frustumparams.default = {-5,5,-5,5,2,500};
frustumparams.required = [0 0 0 0 0 0];
frustumparams.classname = 'frustum';
frustumparams.classdescription = 'Frustum parameters for viewing transformation';

params.name = {'stimuliOnTime','stimuliOffTime','showFlipped','basejointangles','target','calibrate',...
    'angleshift','positionshift','orientationshift','timeshift',...
    'cameralocation','center','up','frustum','showPositionType'};
params.type = {'number','number','number','number',targetparams,calibrateparams,...
    'loadArray','loadArray','loadArray','loadArray',...
    'matrix_1_3','matrix_1_3','matrix_1_3',frustumparams,'string'};
params.description = {'Time for the hand to appear (0 = from the start)','Time for the hand to disappear (inf = never)',...
    'whether to flip the screen horizontally (for viewing in a mirror','whether this trial defines base joint angles (for a later angleshift)',...
    'details of the targets to display','initial parameters for the calibration',...
    'filename of the angleshift','filename of the positionshift','filename of the orientationshift','filename of the timeshift',...
    'camera location (x,y,z), if not specified the value from setup.vr is used',...
    'center of scene (x,y,z), if not specified the value from setup.vr is used',...
    'up direction (x,y,z), if not specified the value from setup.vr is used',...
    'Viewing transformation, if not specified the value from setup.vr is used',...
    'If showPosition is being used (must be set for this trial separately), what type of position to show. Can be either ''hand'' to show the hand, or ''fingertips'' to show only the fingertips'};
params.required = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
params.default = {0,inf,0,0,[],[],[],[],[],[],[],[],[],[],'hand'};
params.classdescription = 'Virtual reality (rendered glove)';
params.classname = 'vrstimulus';
params.parentclassname = 'stimulus';

if nargout>1
    v = [];
    return;
end

if isempty(experimentdata.vr)
    error('Need to set setup.vr = 1 to use vrstimulus');
end

[v,parent] = readParameters(params,inputParams);

if ~isempty(v.target) && ~iscell(v.target)
    tmp = v.target;
    v.target = [];
    v.target{1} = tmp;
end

if ~isempty(v.angleshift)
    angleshift_raw = v.angleshift;
    v.angleshift = [];
    if mod(size(angleshift_raw,1),23) ~= 0
        error('There must be a multiple of 23 rows for angleshift');
    end
    numframesdata = size(angleshift_raw,1)/23;
    v.angleshift.transform = shiftdim(reshape(angleshift_raw(:,1:23),23,numframesdata,23),1);
    v.angleshift.offset = reshape(angleshift_raw(:,24),numframesdata,23);
end

% If a shift has been specified (time, position or orientation), fill the
% other ones with zeros if they have not been specified

if ~isempty(v.positionshift)
    if isempty(v.orientationshift)
        v.orientationshift = zeros(size(v.positionshift));
    end
    if isempty(v.timeshift)
        v.timeshift = zeros(size(v.positionshift,1),1);
    end
end
if ~isempty(v.orientationshift)
    if isempty(v.positionshift)
        v.positionshift = zeros(size(v.orientationshift));
    end
    if isempty(v.timeshift)
        v.timeshift = zeros(size(v.orientationshift,1),1);
    end
end
if ~isempty(v.timeshift)
    if isempty(v.positionshift)
        v.positionshift = zeros(size(v.timeshift,1),3);
    end
    if isempty(v.orientationshift)
        v.orientationshift = zeros(size(v.timeshift,1),3);
    end
end
if ~isempty(v.angleshift) && ~isempty(v.angleshift.transform)
    if isempty(v.positionshift)
        v.positionshift = zeros(size(v.angleshift.transform,1),3);
    end
    if isempty(v.orientationshift)
        v.orientationshift = zeros(size(v.angleshift.transform,1),3);
    end
    if isempty(v.timeshift)
        v.timeshift = zeros(size(v.angleshift.transform,1),1);
    end
end
if ~strcmp(v.showPositionType,'hand') && ~strcmp(v.showPositionType,'fingertips')
    error('showPositionType in vr stimulus must be either ''hand'' or ''fingertips''');
end
v = class(v,'vrstimulus',stimulus(parent));
