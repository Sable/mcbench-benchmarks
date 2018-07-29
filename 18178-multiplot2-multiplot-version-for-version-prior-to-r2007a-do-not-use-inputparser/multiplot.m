function varargout = multiplot(xdata,ydata,varargin)
% multiplot - 2D-line plots on several axes with common x-axis
%   multiplot(XDATA,YDATA,'PropertyName',PropertyValue,...) plots the data
%   stored in the cell arrays XDATA and YDATA in several subplots with a common
%   x-axis. multiplot also links all generated axes in order to synchronize the
%   zoom along the x-axis. See below for a description of each argument.
%
%   LINES = multiplot(XDATA,YDATA,'PropertyName',PropertyValue,...) performs the
%   actions as above and returns the handles of all the plotted lines in a cell
%   array which has the same length as XDATA.
%
%   [LINES,AXES] = multiplot(XDATA,YDATA,'PropertyName',PropertyValue,...)
%   performs the actions as the first syntax and returns the handles of all the
%   plotted lines in a cell array which has the same length as XDATA and all the
%   axes handles in a double array.
%
%
%   Required inputs and descriptions:
%       XData    -  Cell array. Contains the X data of the lines. Each cell
%       content is similar to to the X variable when you execute plot(X,Y).
%
%       YData    -  Cell array. Contains the Y data of the lines. Each cell
%       content is similar to to the Y variable when you execute plot(X,Y).
%       Note that YData must be the same length as XData.
%
%   Property/Value pairs and descriptions:
%
%       LineSpec - Cell array or char array. If LineSpec is a char array then it
%       specifies this line spec will be used for all lines. If LineSpec is a
%       cell array it must contain only char arrays and each cell will specify
%       the line spec of the corresponding cell in XData and YData.
%       Note that if LineSpec cell array has less elements than XData and YData
%       then line spec will be periodically reused.
%
%       XLabel   - Char array. x-axis label displayed below the bottom axes.
%
%       YLabel   - Cell array. Labels that will be displayed next to the y-axis
%       for each data.
%       Note that YLabel must be the same length as XData and YData.
%
%       Title    - Char array. Label deisplayed on top of all axes.
%
%       XLim     - Two elements double array. The lower and upper limits for the
%       common x-axis of all axes.
%
%
%   Example:
%      xdata = {1:20, linspace(-10,25,100), linspace(0,30,25)};
%      ydata = {2000 * rand(1,20) , rand(1,100) , 500 * rand(1,25)};
%      ylabel = {'1st Data','2nd Data','3rd Data'};
%      linespec = {'b-*','r:+','g'};
%      multiplot(xdata, ydata, 'YLabel', ylabel, ...
%         'LineSpec', linespec, 'Title', 'Graph Title', 'XLabel', 'time');
%

%% Check number of output arguments
error(nargoutchk(0,2,nargout));


%% Parse inputs

% Init input parser
p = inputParser;

% Define input parameters/values
p.addRequired('XData'   , @(l) all(cellfun(@isnumeric,l)));
p.addRequired('YData'   , @(l) all(cellfun(@isnumeric,l)));

p.addOptional('LineSpec', {}, @(l) all(cellfun(@ischar,l)));
p.addOptional('YLabel'  , {}, @(l) all(cellfun(@ischar,l)));
p.addOptional('XLim'    , [], @(v) isnumeric(v) && numel(v)==2);
p.addOptional('Title'   , '', @ischar);
p.addOptional('XLabel'  , '', @ischar);

% Parse all input arguments
p.parse(xdata,ydata,varargin{:});


%% Define default values

% Compute X axis limits based on input or data
if isempty(p.Results.XLim)
  xLim = [min(cellfun(@min,p.Results.XData)) , max(cellfun(@max,p.Results.XData))];
else
  xLim = p.Results.XLim;
end

% Define line spec based on inputs
if isempty(p.Results.LineSpec)
  lineSpec = repmat({''},1,length(p.Results.XData));
elseif ischar(p.Results.LineSpec)
  lineSpec = p.Results.LineSpec;
else
  lineSpec = p.Results.LineSpec;
end


%% Init local variables

% Number of axis to create
axesNb = length(p.Results.XData);

% Default Height for axes (uses normalized coordinates)
axH = (1 - .2) / axesNb;

% Initialize the arrays of axes handles and line handles
axesHdl = zeros(axesNb,1);
lineHdl = cell(axesNb,1);


%% Create figure and plot data

% Create a new figure
f1 = figure;

% Create all axes and plots
for indSP = 1:axesNb
  mysubplot(indSP);
end


%% Update axes properties

% Remove XTick labels for all axes except the 1 at the bottom of the figure
set(axesHdl(1:end-1),'XTickLabel',{});

% Alternate Y axis position for axes
set(axesHdl(2:2:end),'YAxisLocation','right');

% Add Title on top of the first axes
title(axesHdl(1),p.Results.Title);

% Add X axis label below the bottom axes
xlabel(axesHdl(end),p.Results.XLabel);

% Link all X-axis in order to synchronize the Zoom 
linkaxes(axesHdl,'x');

% Activate the zoom
zoom('on');


%% Assign output arguments
switch nargout
  case 1
    varargout{1} = lineHdl;
  case 2
    varargout = {lineHdl , axesHdl};
end

% Clear function workspace
clear('-regexp','^(?!(varargout)$).');


%% Subplot creation function
  function mysubplot(ind)
    
    % Index of the axes to create
    indA = 1 + axesNb - ind;
    
    % Index in LineSpec cell array
    indLS = ind - numel(lineSpec) * ( fix( (ind - 1 ) / numel(lineSpec) ) );
    
    % Create the axes
    figure(f1);
    axPos = [.1  ,  .1 + .003 + axH * (indA-1)  ,  .8  ,  axH-0.003];
    axesHdl(ind) = axes('Parent',f1,'Units','normalized','Position',axPos);
    
    % Draw the line(s)
    lineHdl{indA} = plot(axesHdl(ind), p.Results.XData{ind}, p.Results.YData{ind}, lineSpec{indLS});
    
    % Change X limits
    xlim(axesHdl(ind),xLim);
    
    % Add grid to the axes
    grid('on');
    
    % Add ylabel if needed
    if ~isempty(p.Results.YLabel) && numel(p.Results.YLabel) >= ind
      ylabel(p.Results.YLabel{ind});
    end
    
  end

end