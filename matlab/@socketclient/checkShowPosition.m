% CHECKSHOWPOSITION - check that the showPosition settings fit the values of the device
%
% checkShowPosition(sc,numValues,deviceName,perSensor)
%
% Used by validate when a trial uses showPosition = 3, 4 or 5, so that a wrong size is
% reported when the protocol is checked rather than when the position is first shown.
% numValues is the number of values the device reports (numPositionValues). perSensor
% (optional) is the number of values of one sensor, for devices that repeat a one-row
% range for each sensor (e.g. Liberty).
%
% For each cell of displayRangeX / displayRangeY (see calculateLastPosition):
%  - the number of rows R is 1, or a number that divides numValues (e.g. one per sensor)
%  - with V = numValues / R values per row, the width is a multiple of 2*V+1
%    (a [min max] pair for each value, then the time value), once for each dot
%  - displayRangeY is the same size as displayRangeX
%  - offsetX / offsetY have a column for each dot, showPositionColor 3 columns for each dot
function checkShowPosition(sc,numValues,deviceName,perSensor)

if nargin<4 || isempty(perSensor)
    perSensor = NaN;
end

if isnan(numValues)
    return;
end
where = ['setup.' deviceName];
for k=1:max(numel(sc.displayRangeX),numel(sc.displayRangeY))
    X = sc.displayRangeX{min(k,numel(sc.displayRangeX))};
    Y = sc.displayRangeY{min(k,numel(sc.displayRangeY))};
    if numel(sc.displayRangeX)>1 || numel(sc.displayRangeY)>1
        cellText = sprintf(' (cell %d)',k);
    else
        cellText = '';
    end
    if isempty(X)
        continue;
    end
    rows = size(X,1);
    if mod(numValues,rows)~=0
        error(['%s.displayRangeX%s has %d rows, but %s gives %d values. Use one row, or one row ' ...
            'for each sensor (a number of rows that divides %d).'],where,cellText,rows,deviceName,numValues,numValues);
    end
    perRow = numValues/rows;
    block = 2*perRow + 1;
    if (mod(size(X,2),block)~=0 || size(X,2)==0) && rows==1 && ~isnan(perSensor) && perSensor<numValues
        error(['%s.displayRangeX%s has %d columns. %s gives %d values for each sensor, so use %d columns ' ...
            '(a [min max] pair for each value, then the time value), which are used for every sensor, ' ...
            'or one row for each sensor. For example %s'],where,cellText,size(X,2),deviceName,perSensor,...
            2*perSensor+1,exampleText(perSensor));
    end
    if mod(size(X,2),block)~=0 || size(X,2)==0
        error(['%s.displayRangeX%s has %d columns, but %s gives %d value(s) per row, so it needs %d columns ' ...
            '(a [min max] pair for each value, then the time value), or a multiple of %d to show several dots. ' ...
            'For example %s'],where,cellText,size(X,2),deviceName,perRow,block,block,exampleText(perRow));
    end
    if ~isempty(Y) && ~isequal(size(Y),size(X))
        error('%s.displayRangeY%s is %dx%d, but it must be the same size as displayRangeX (%dx%d)',...
            where,cellText,size(Y,1),size(Y,2),size(X,1),size(X,2));
    end
    dots = size(X,2)/block;
    if size(sc.offsetX,2)<dots || size(sc.offsetY,2)<dots
        error('%s: displayRangeX shows %d dots, so offsetX and offsetY need %d columns (one per dot)',where,dots,dots);
    end
    colors = sc.showPositionColor;
    if ~iscell(colors)
        colors = {colors};
    end
    for c=1:numel(colors)
        if isnumeric(colors{c}) && ~isempty(colors{c}) && ~strcmp(sc.showPositionType,'image') && size(colors{c},2)<3*dots
            error('%s: displayRangeX shows %d dots, so showPositionColor needs %d columns (an RGB color for each dot)',where,dots,3*dots);
        end
    end
end

function s = exampleText(perRow)
pairs = repmat({'0 0'},1,perRow);
pairs{1} = '-1 1';
s = sprintf('[%s 0] moves the dot with the first value from -1 to 1 (use 0 0 for values that should not move it).',strjoin(pairs,' '));
