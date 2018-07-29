function [ insetAxesHandle rectHandle rectHandleInset annHandles] = inset2DAbsolute(axesHandle, insetLoc, style, rectLoc, varargin)
%[ insetAxesHandle rectHandle rectHandleInset annHandles] = inset2DAbsolute(axesHandle, insetLoc, style, rectLoc, varargin)
%
% inset2DAbsolute creates a new axes located within the specified 
% axes (identified by axesHandle) along with corresponding 
% rectangle/lines/arrows as indicated by style.  
% 
% Handles are returned so that the insets, rectangles, and annotations 
% (lines/arrows) can be customized.
%
% If 'ZOOMN' or 'ARROW' are selected for the style variable, rectangles are
% added to both the inset and parent axes to identify the data and the 
% inset is automatically populated with the appropriate data.  If only an 
% inset is desired, simply leave style undefined or set to [].
%
% CAVEAT: Although the inset data is correctly mapped and appears to be
% correctly color-coded, the "RGB" values that are obtained from a data 
% cursor are incorrect.
%
% Inputs:  axesHandle  - [1x1] Axes Handle
%          insetLoc    - [2x2] Coordinate information for inset plot.
%                              Coordinates MUST BE WITHIN THE BOUNDS of
%                              axesHandle (otherwise the inset is placed
%                              outside of the bounds of the axes)
%                              [insetXStart  insetXStop]
%                              [insetYStart  insetYStop]
%          [style]     - [STR] [Optional] Determines whether or not a
%                              rectangle is added to identify the
%                              connection between inset data and the
%                              axesHandle
%                              ** If style is defined,          **
%                              ** rectLoc must ALSO be provided **
%                              []      - No rectangle (DEFAULT)
%                              'PLAIN' - Rectangle without connection between
%                                        axesHandle and insetAxesHandle 
%                              'ZOOMN' - Inset appears as zoomed in portion
%                                        of original plot
%                              'ARROW' - Arrow from rectangle to inset
%          [rectLoc]   - [2x2] [Optional] Rectangle location in terms of 
%                              axes identified by axesHandle:
%                              [rectXStart  rectXStop]
%                              [rectYStart  rectYStop]
%          [varargin]  - [OPT] Additional arguments used to define
%                              lineseries properties for the rectangles in
%                              both axesHandle and insetAxes.
%
% Outputs: insetAxesHandle - [1x1] Inset Axes Handle
%          rectHandle      - [1x1] Rectangle Handle (plot handle) 
%                                  corresponding to axesHandle if/when
%                                  style = 'ZOOMN' or 'ARROW'
%          rectHandleInset - [1x1] Rectangle Handle (plot handle) in *Inset*
%                                  if/when style = 'ZOOMN' or 'ARROW'
%          annHandles      - [VAR] Annotation handles
%
% Copyright (c) 2011, Hidden Solutions, LLC
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%
%   * Redistributions of source code must retain the above copyright
%      notice, this list of conditions and the following disclaimer.
%    * Redistributions in binary form must reproduce the above copyright
%      notice, this list of conditions and the following disclaimer in the
%      documentation and/or other materials provided with the distribution.
%    * Neither the name Hidden Solutions, LLC nor the names of any
%      contributors may be used to endorse or promote products derived from 
%      this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
% ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
% WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL HIDDEN SOLUTIONS, LLC BE LIABLE FOR ANY
% DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
% (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
% ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%
% Author:  James S. Hall, Ph.D., P.E. (Hidden Solutions, LLC)
% Date:    August 9, 2011
%

% Verify that axesHandle is valid
if ~ishandle(axesHandle)
  error('axesHandle is an invalid handle identifier!');
end

%Ensure insetLoc is appropriately defined
if any(size(insetLoc)~=[2 2]) || ...
   any(insetLoc(:,1) < [min(xlim(axesHandle)); min(ylim(axesHandle))]) || ...
   any(insetLoc(:,2) > [max(xlim(axesHandle)); max(ylim(axesHandle))])
  error('insetLoc must be a 2x2 double with VALID coordinate information located within the bounds of axesHandle.');
end

% Ensure style and rectLoc are appropriately defined
if nargin > 2
    
  % Verify style is something that is expected
  if ~(isempty(style) || strcmp(style,'PLAIN') || strcmp(style,'ZOOMN') || strcmp(style,'ARROW'))
    error('If defined, style must be either "PLAIN", "ZOOMN", or "ARROW".');
  end
  
  % Initialize rectLoc (if necessary) and/or verify rectLoc values
  if nargin == 3
    if isempty(style)
        
      % Initialize
      rectLoc = [];
      
    else
      
      % Style defined as SOMETHING, but rectLoc is not provided
      error('If style is defined as something other than [], rectLoc must be a VALID set of coordinates within the bounds of axesHandle.');
      
    end
  
  % Check bounds of rectLoc
  elseif ~isempty(style) && ( isempty(rectLoc) || any(size(insetLoc)~=[2 2]))
    error('If style is defined as something other than [], rectLoc must be a VALID set of coordinates within the bounds of axesHandle.');
  end 
  
end

% Initialize output arguments
rectHandle      = [];
rectHandleInset = [];

% Setup inset...
insetXStartLoc = insetLoc(1,1);
insetXStopLoc  = insetLoc(1,2);
insetYStartLoc = insetLoc(2,1);
insetYStopLoc  = insetLoc(2,2);

% Assign parent figHandle
figHandle   = get(axesHandle,'Parent');

% Compute normalized inset bounds by compensating for axes values
axesPos     = get(axesHandle,'Position');
axesXLim    = get(axesHandle,'XLim');
axesYLim    = get(axesHandle,'YLim');
insetdX     = diff(insetLoc(1,:))/diff(axesXLim)*axesPos(3);
insetdY     = diff(insetLoc(2,:))/diff(axesYLim)*axesPos(4);
if strcmp(get(axesHandle,'XDir'),'normal')
  insetXStart = axesPos(1) + (insetXStartLoc - axesXLim(1))/diff(axesXLim)*axesPos(3);
  insetXStop  = axesPos(1) + (insetXStopLoc  - axesXLim(1))/diff(axesXLim)*axesPos(3);
else
  insetXStop  = axesPos(1) + (axesXLim(2) - insetXStartLoc)/diff(axesXLim)*axesPos(3);
  insetXStart = axesPos(1) + (axesXLim(2) - insetXStopLoc)/diff(axesXLim)*axesPos(3);
end
if strcmp(get(axesHandle,'YDir'),'normal')
  insetYStart = axesPos(2) + (insetYStartLoc - axesYLim(1))/diff(axesYLim)*axesPos(4);
  insetYStop  = axesPos(2) + (insetYStopLoc  - axesYLim(1))/diff(axesYLim)*axesPos(4);
else  
  insetYStop  = axesPos(2) + (axesYLim(2) - insetYStartLoc)/diff(axesYLim)*axesPos(4);
  insetYStart = axesPos(2) + (axesYLim(2) - insetYStopLoc)/diff(axesYLim)*axesPos(4);
end

% Generate new axis at desired location
if nargin == 2 || isempty(rectLoc)
    
  % Create a blank axes at the specified location
  insetAxesHandle = axes('pos',[insetXStart insetYStart insetdX insetdY]);
  
else
  
  % Create a duplicate axes at the specified location
  insetAxesHandle = copyobj(axesHandle,figHandle);
  
  % Lock color-axis limits (if present)
  set(insetAxesHandle,'CLim',get(insetAxesHandle,'CLim'));

  % Move axes to correct location
  set(insetAxesHandle,'pos',[insetXStart insetYStart insetdX insetdY]);
  
  % Remove extraneous information
  plotHandles      = get(insetAxesHandle,'Children');

  % Reduce data volume by removing extraneous information
  for pp = 1:length(plotHandles)
    
    % Get information about each plot
    plotInfo = get(plotHandles(pp));
    
    if isfield(plotInfo,'CData') && ~isempty(plotInfo.CData)
      % Reduce data set size
      xVals          = min(plotInfo.XData):range(plotInfo.XData)/(size(plotInfo.CData,2)-1):max(plotInfo.XData);
      yVals          = min(plotInfo.YData):range(plotInfo.YData)/(size(plotInfo.CData,1)-1):max(plotInfo.YData);
      % Determine which data values to keep
      keepFlags_x    = xVals > rectLoc(1,1) & xVals < rectLoc(1,2);
      keepFlags_y    = yVals > rectLoc(2,1) & yVals < rectLoc(2,2);
      keepFlags      = boolean(double(keepFlags_y(:))*double(keepFlags_x(:)).');
      % Assign kept values to plot
      set(plotHandles(pp),'YData',yVals(keepFlags_y));
      set(plotHandles(pp),'XData',xVals(keepFlags_x));
      set(plotHandles(pp),'CData',reshape(plotInfo.CData(keepFlags),[sum(keepFlags_y) sum(keepFlags_x)]));
    else
      % Determine which data values to keep
      keepFlags      = plotInfo.XData > rectLoc(1,1) & plotInfo.XData < rectLoc(1,2);
      % Update plot with data within x-range
      set(plotHandles(pp),'YData',plotInfo.YData(keepFlags));
      set(plotHandles(pp),'XData',plotInfo.XData(keepFlags));
    end
    
  end
  
  % Assign rectangle information
  rectXStartLoc  = rectLoc(1,1)-eps;
  rectXStopLoc   = rectLoc(1,2)+eps;
  rectYStartLoc  = rectLoc(2,1)-eps;
  rectYStopLoc   = rectLoc(2,2)+eps;

  % Plot rectangle in main
  hold(axesHandle, 'on');
  rectHandle = plot(axesHandle, [rectXStartLoc rectXStopLoc  rectXStopLoc rectXStartLoc rectXStartLoc], ...
                                [rectYStartLoc rectYStartLoc rectYStopLoc rectYStopLoc  rectYStartLoc].', ...
                    varargin{:});
                             
  % Plot rectangle in new
  hold(insetAxesHandle, 'on');
  rectHandleInset = plot(insetAxesHandle, [rectXStartLoc rectXStopLoc  rectXStopLoc rectXStartLoc rectXStartLoc], ...
                                          [rectYStartLoc rectYStartLoc rectYStopLoc rectYStopLoc  rectYStartLoc].', ...
                    varargin{:});
  set(insetAxesHandle,'XLim',[rectXStartLoc-2*eps  rectXStopLoc+2*eps]);
  set(insetAxesHandle,'YLim',[rectYStartLoc-2*eps  rectYStopLoc+2*eps]);
  
  % Convert to normalized values for annotations
  if strcmp(get(axesHandle,'XDir'),'normal')
    rectXStart = axesPos(1) + (rectXStartLoc - axesXLim(1))/diff(axesXLim)*axesPos(3);
    rectXStop  = axesPos(1) + (rectXStopLoc  - axesXLim(1))/diff(axesXLim)*axesPos(3);
  else
    rectXStop  = axesPos(1) + (axesXLim(2) - rectXStartLoc)/diff(axesXLim)*axesPos(3);
    rectXStart = axesPos(1) + (axesXLim(2) - rectXStopLoc)/diff(axesXLim)*axesPos(3);
  end
  if strcmp(get(axesHandle,'YDir'),'normal')
    rectYStart = axesPos(2) + (rectYStartLoc - axesYLim(1))/diff(axesYLim)*axesPos(4);
    rectYStop  = axesPos(2) + (rectYStopLoc  - axesYLim(1))/diff(axesYLim)*axesPos(4);
  else  
    rectYStop  = axesPos(2) + (axesYLim(2) - rectYStartLoc)/diff(axesYLim)*axesPos(4);
    rectYStart = axesPos(2) + (axesYLim(2) - rectYStopLoc)/diff(axesYLim)*axesPos(4);
  end

  % Generate start/stops for each line of the rectangle and inset
  rectStartStops = [rectXStart rectYStart  rectXStart  rectYStop; ...
                    rectXStart rectYStop   rectXStop   rectYStop; ...
                    rectXStop  rectYStop   rectXStop   rectYStart; ...
                    rectXStop  rectYStart  rectXStart  rectYStart];
  insetStartStops = [insetXStart insetYStart  insetXStart  insetYStop; ...
                     insetXStart insetYStop   insetXStop   insetYStop; ...
                     insetXStop  insetYStop   insetXStop   insetYStart; ...
                     insetXStop  insetYStart  insetXStart  insetYStart];
  
  % Establish DEFAULT PATH start/stops and insert rectangle if appropriate
  switch style
      case 'ZOOMN'
        pathStartStops = [rectXStart rectYStart  insetXStart insetYStart; ...
                          rectXStart rectYStop   insetXStart insetYStop;  ...
                          rectXStop  rectYStop   insetXStop  insetYStop;  ...
                          rectXStop  rectYStart  insetXStop  insetYStart];
      case 'ARROW'
        pathStartStops = [rectXStart+rectXStop   rectYStart+rectYStop ...
                          insetXStart+insetXStop insetYStart+insetYStop]./2;
      otherwise
        pathStartStops = [];
  end
  
  % Adjust each path so that it does not overlap the rectangle/inset
  for pathIndex = 1:size(pathStartStops,1)
      
    % Characterize path
    pathStart = pathStartStops(pathIndex,1:2)';
    pathStop  = pathStartStops(pathIndex,3:4)';
    pathSpace = pathStop-pathStart;
    
    % Check for intersection with RECTANGLE/INSET
    for lineIndex = 1:size(rectStartStops,1)
        
      % Characterize RECTANGLE path
      lineStart = rectStartStops(lineIndex,1:2)';
      lineStop  = rectStartStops(lineIndex,3:4)';
      lineSpace = lineStop-lineStart;
      
      % Find parametric intersection with RECTANGLE
      tt = pinv([pathSpace -lineSpace])*(lineStart-pathStart);

      % Determine if segments are crossing
      if all(tt<1) && all(tt>0)
          
        % Update starting point for this path
        pathStartStops(pathIndex,1:2) = (pathStart + tt(1)*pathSpace)';
        
        % (Re-)Characterize path
        pathStart = pathStartStops(pathIndex,1:2)';
        pathStop  = pathStartStops(pathIndex,3:4)';
        pathSpace = pathStop-pathStart;
      end
      
      % Characterize INSET path
      lineStart = insetStartStops(lineIndex,1:2)';
      lineStop  = insetStartStops(lineIndex,3:4)';
      lineSpace = lineStop-lineStart;
      
      % Find parametric intersection with INSET
      tt = [pathSpace -lineSpace]\(lineStart-pathStart);

      % Determine if segments are crossing
      if all(tt<1) && all(tt>0)
          
        % Update starting point for this path
        pathStartStops(pathIndex,3:4) = (pathStart + tt(1)*pathSpace)';
        
        % (Re-)Characterize path
        pathStart = pathStartStops(pathIndex,1:2)';
        pathStop  = pathStartStops(pathIndex,3:4)';
        pathSpace = pathStop-pathStart;
      end
      
    end
    
    % Insert line/arrow as appropriate
    switch style
        case 'ZOOMN'
          annHandles = annotation(figHandle,'line', pathStartStops(pathIndex,1:2:3), pathStartStops(pathIndex,2:2:4));
        case 'ARROW'
          annHandles = annotation(figHandle,'arrow', pathStartStops(pathIndex,1:2:3), pathStartStops(pathIndex,2:2:4));
    end
  end
    
end

