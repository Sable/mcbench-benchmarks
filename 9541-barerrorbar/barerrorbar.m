function varargout = barerrorbar(varargin)
% BARERRORBAR   Create a bar plot with error bars. BARERRORBAR() uses the
%   MATLAB functions BAR() and ERRORBAR() and changes the 'XData' property
%   of the errorbar plot so that the error bars are plotted at the center 
%   of each bar. This does not support "stack" bar plots.
%
% Syntax: varargout = barerrorbar(varargin)
%
% Inputs:
%   Method 1: Cell array method
%       varargin{1} - A cell array containing all of the inputs to be fed 
%           to bar().
%       varargin{2} - A cell array containing all of the inputs to be fed
%           to errorbar().
%   Method 2: Simple Method
%       varargin{1} - The data to be plotted by bar().
%       varargin{2} - The E input to errorbar().
%
% Outputs:
%   varargout{1} - The handle to the bar plot.
%   varargout{2} - The handle to the errorbar plot.
%
% Examples:
%   x = 0.2*randn(3,4,100) + 1;
%   xMeans = mean(x,3);
%   xMeansConf = repmat(2*0.2/10,3,4);
%   xMeansL = repmat(3*0.2/10,3,4);
%   xMeansU = repmat(4*0.2/10,3,4);
%   
%   figure
%   barerrorbar(xMeans,xMeansConf);
% 
%   figure
%   barerrorbar({3:5,xMeans,'m'}, {repmat((3:5)',1,4),xMeans, xMeansL,xMeansU,'bx'});
% 
%   figure
%   barerrorbar({3:5,xMeans,'k'}, {repmat((3:5)',1,4),xMeans, xMeansL,xMeansU,'bx'});
%   hold on
%   barerrorbar({7:9,xMeans}, {repmat((7:9)',1,4),xMeans, 2*xMeansL,4*xMeansU,'d','color',[0.7 0.7 0.7]});
%
% Other m-files required: none
% Subfunctions: interpretinputs
% MAT-files required: none
%
% See also: bar.m errorbar.m

% Author: Kenneth D. Morton Jr. and J. Simeon Stohl
% Revised by: Kenneth D. Morton Jr.
% Duke University, Department of Electrical and Computer Engineering
% Email Address: kennethmorton@ieee.org
% Created: 07-July-2005
% Last revision: 06-January-2006

% Check if hold is on
startedWithHoldOn = ishold;

[data, barInputs, errorbarInputs] = interpinputs(varargin);

% Create the bar plot and keep the handles for later use.
barHandles = bar(barInputs{:});
barHandlesStruct = get(barHandles);

if ~startedWithHoldOn
    hold on
else
    % Hold is already on so we need to check the XTick and save them.
    oldXTicks = get(gca,'XTick');
    oldXTickLabels = get(gca,'XTickLabel');
end

% Find out the bar width which is dependent on the number of bar sets and
% the number of bars in each set.
barWidth = barHandlesStruct(1).BarWidth; 

errorbarHandles = errorbar(errorbarInputs{:});

% The crazy stuff to find the bar centers. Some of it is how bar.m does it.
[nGroups, nBarsPerGroup] = size(data);
for iBpg = 1:nBarsPerGroup
   groupMembership(:,iBpg) = barHandlesStruct(iBpg).XData;
end
groupWidth = min(0.8, nBarsPerGroup/(nBarsPerGroup+1.5));
groupLocs = groupMembership(:,1);
distanceToNearestGroup = zeros(1,nGroups);
for iGroup = 1:nGroups
    distanceToNearestGroup(iGroup) = ...
        min(abs(groupLocs(iGroup)-...
        groupLocs(groupLocs~=groupLocs(iGroup))));
end
groupWidth = groupWidth*min(distanceToNearestGroup);
barGap = (nGroups - 1) * groupWidth / (nGroups-1) / nBarsPerGroup;
almostCenters  = (0:nBarsPerGroup-1)'.*barGap - 0.5*barGap*nBarsPerGroup;
relativeCenters = almostCenters + mean([(1-barWidth)/2.*barGap; (1+barWidth)/2.*barGap]);

centers = repmat(relativeCenters',nGroups,1) + groupMembership;
% Change the XData of the errorbars to be at our bar centers.
for iBpg = 1:nBarsPerGroup
    set(errorbarHandles(iBpg),'XData',centers(:,iBpg));
end

% Turn hold off if it wasn't on to begin with
if ~startedWithHoldOn
    hold off
else
    % Set the XTick and XTickLabels to inlcude the old and new information.
    newXTicks = groupMembership(:,1);
    newXTickLabels = num2str(newXTicks);
    set(gca,'XTick',sort(unique([oldXTicks newXTicks'])));
    if ischar(oldXTickLabels)
        % If this is a string then they are probably default so update with
        % the new additions.
        set(gca,'XTickLabel',[oldXTickLabels; newXTickLabels]);
    end
end

% Prepare both sets of handles as outputs, if requested.
if nargout > 0
    varargout{1} = barHandles;
end
if nargout > 1
    varargout{2} = errorbarHandles;
end

% End of barerrorbar()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [data, barInputs, errorbarInputs] = interpinputs(inCell)
% Interperate the inputs so that they can be used in barerrorbar(). Make
% two different possibilities based on the type of inputs.
%   Method 1: Cell array method.
%       varargin{1} - A cell array containing all of the inputs to be fed 
%           to bar().
%       varargin{2} - A cell array containing all of the inputs to be fed
%           to errorbar().
%   Method 2: Simple Method
%       varargin{1} - The data to be plotted by bar().
%       varargin{2} - The data to be plotted by errorbar().

if iscell(inCell{1})
    % We have entered Method 1
    barInputs = inCell{1};
    if length(barInputs) > 2
        data = barInputs{2};
    elseif length(barInputs) < 2
        data = barInputs{1};
    elseif length(barInputs) == 2
        if ischar(barInputs{2})
            data = barInputs{1};
        else
            data = barInputs{2};
        end
    end
else
    barInputs = {inCell{1}};
    data = inCell{1};
    nRows = size(barInputs{1},1);
    if nRows == 1
        barInputs{1} = barInputs{1}';
    end 
end

%Plot black dot errorbars for the default.
if iscell(inCell{2})
    errorbarInputs = inCell{2};
else 
    errorbarInputs = {inCell{1}, inCell{2}, 'k.',};
end

if length(inCell) > 2
    error(['Too many input arguments.' ...
        ' Try using the cell array input method.']);
end

% Search for the 'stack' option in the bar inputs
for iBI = 1:length(barInputs)
    if ischar(barInputs{iBI})
        if strcmpi(barInputs{iBI},'stack')
            error('barerrorbar() does not support "stack" bar plots.')
        end
    end
end
