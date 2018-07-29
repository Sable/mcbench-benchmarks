function [ PH CH colorScale] = plotSeries(varargin)
%
% [ PH CH colorList ] = plotSeries(AH,x,y,s,colormap,OPTIONS)
%
% Plots x and y data with each column of y color-coded according to scalar 
% values defined in s.  plotSeries is particularly useful to illustrate how
% a x-y dataset *changes* in response to some value, s.
%
% Colormap can be defined by a string or a four-column matrix.  When a string
% is used or the argument is left empty, the colormap spans all values of
% s, linearly.  When a four-column matrix is provided, the first column 
% corresponds to potential values of s, the other three define the corresponding 
% RGB values.  The RGB values used for each column of y are interpolated
% from the rows of colormap, so there is no requirement for the number of
% rows of colormap to match up w/ the length of s.
%
% If length(s) > 1, then a colorbar will be included as a legend for the 
% line coloring.
%
% Optional lineseries specifications (OPTIONS) will be applied to all
% plots.
%
% plotSeries outputs a list of plotHandles (PH), a colorbar handle, (CH),
% and the colorList used for the plot.  The colorList output can be used
% directly as the colormap argument for other calls to plotSeries,
% providing a mechanism to easily produce multiple plots using similar 
% coloring schemes.
%
%  Example (cut and paste into the command-line):
%
%  % Show how sinc function changes as a function of s
%  s = 1:10;
%  x = (-1:1e-3:1).';
%  y = sinc(x*s);
%  figure; plotSeries(x,y,s,'jet','LineWidth',2);
%  xlabel('x-values');ylabel('y-values');
%
%  Inputs:  AH         - [1x1]       [OPTIONAL]  Axes handle
%           x          - [NxS / Nx1] X-coordinate data
%           y          - [NxS]       Y-coordinate data
%           s          - [1xS]       Scalar value associated with each data series
%                                    (length(s) = size(y,2))
%           colormap   - [Cx4]       Colormap to use for dataset coloring.
%                                    Can be colormap string OR four-column
%                                    colormap with 1st column corresponding to 
%                                    potential s values and 3 remaining columns 
%                                    corresponding to color.  Note that the
%                                    colormap will be interpolated to find
%                                    the appropriate color for each
%                                    dataset. ([] for 'default' colormap)
%           OPTIONS    -             Optional arguments for plot command
%
%  Outputs: PH         - [Sx1] Plot handle
%           CH         - [1x1] Colorbar handle
%           colorScale - [Sx4] Colormap w/ 1st column corresponding to 
%                              s values and 3 remaining columns corresponding to color
% 
%  N - Number of x-y coordinates to plot for each dataset
%  S - Number of datasets
%  C - Number of colors provided in colormap
%  
% Copyright (c) 2011, Hidden Solutions, LLC
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%
%    * Redistributions of source code must retain the above copyright
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
% Author: James S. Hall (Hidden Solutions, LLC)
% Date:   17 October 2011
%

% Determine axes handle
if numel(varargin{1}) == 1 && ishandle(varargin{1})
  % If provided, pop AH from list of arguments
  AH       = varargin{1};
  varargin = varargin(2:end);
else
  % Assign current axes
  AH = gca;
end

% Assign x,y,z arguments
x = varargin{1};
y = varargin{2};
z = varargin{3};

% Force to column vectors (if appropriate)
if size(y,1) == 1
  y = y(:);
end
if size(z,1) == 1
  z = z(:);
end

% Generate colorList for plots
if length(varargin)>3 && ~isempty(varargin{4})
  if ischar(varargin{4})
    % If string provided, use as name of colormap
    cmap       = colormap(varargin{4});
    colorScale = [((0:1/(size(cmap,1)-1):1).'*range(z))+min(z) cmap];
  elseif size(varargin{4},2) == 4
    % Assign colormap to axes
    colorScale = varargin{4};
  end
  % Assign colormap to axes
  colormap(AH,colorScale(:,2:4));
else
  % Use default colormap
  cmap       = colormap();
  colorScale = [((0:1/(size(cmap,1)-1):1).'*range(z))+min(z) cmap];
end

% Determine colors to use for each plot
if length(z) > 1
  % Sort colors for interp1
  [cSort cInd] = sort(colorScale(:,1));
  colorScale   = colorScale(cInd,:);
  colorList    = interp1(colorScale(:,1),colorScale(:,2:4),z,'linear',nan);
  % Force s values outside of colorScale(:,1) range to max/min colorScale
  colorList(isnan(colorList(:,1))&z<min(colorScale(:,1)),:) = repmat(colorScale(1,:),sum(isnan(colorList(:,1))&z<min(colorScale(:,1))),1);
  colorList(isnan(colorList(:,1))&z>max(colorScale(:,1)),:) = repmat(colorScale(end,:),sum(isnan(colorList(:,1))&z<min(colorScale(:,1))),1);
else
  % Only one s value provided, use for all plots
  colorList = repmat(colorScale(1,2:4),size(y,2),1);
end

% Plot data
PH = plot(AH,x,y,varargin{5:end});

% Color-code data
for pp = 1:length(PH)
  set(PH(pp),'Color',colorList(pp,:));
end

if length(z) > 1
  % Add colorbar
  caxis([min(z) max(z)]);
  CH = colorbar;
end

end

