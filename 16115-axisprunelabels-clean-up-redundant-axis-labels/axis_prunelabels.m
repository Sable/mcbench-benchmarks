function axis_prunelabels(whichLabels, figHandle)
% AXIS_PRUNELABELS Minimizes redundant axis labels in a grid of subplots
%
%  AXIS_PRUNELABELS takes a figure with a grid of subplots (created
%  either using SUBPLOT or custom AXES commands), and (a) forces
%  all the subplots to have the same axis limits, and (b) turns
%  off axis labels on all the "interior" subplots, thereby
%  reducing the visual clutter. By default, it operates on
%  both the x- and y-axes, and on the current figure.
% 
%  AXIS_PRUNELABELS(whichlabels) operates on the x-axis
%  (if whichlabels='x'), on the y-axis (if whichlabels='y')
%  or on both (if whichlabels = 'xy'). 
%
%  AXIS_PRUNELABELS(whichlabels, figHandle) operates on the 
%  figure specified by figHandle.
%
%  Example:
%    figure;
%    for i=1:12, 
%         subplot(4,3,i); 
%         plot(randn(1,3+ceil(rand(1)*10))); axis tight; 
%    end
%    axis_prunelabels('xy');
%
%  This function works with MATLAB 6.5 (R13). Additionally, if 
%  LINKAXES is available (MATLAB 7.0), then all the subplot axes 
%  linked together.
% 
%  Gautam Vallabha, Aug-27-2007, Gautam.Vallabha@mathworks.com

if nargin < 2, figHandle = gcf; end
if nargin < 1, whichLabels = 'xy'; end

if ~all(whichLabels == 'x' | whichLabels == 'y')
   error('whichLabels must be x, y, or xy');
end

figHandle = figHandle(1); % in case of vector inputs
if ~ (ishandle(figHandle) && strcmp(get(figHandle,'type'), 'figure'))
   error('figHandle should be a valid figure handle');
end

% find the axes in the figure
h = findobj(figHandle,'type','axes');
hx = findobj(h,'flat','visible','on');
if length(hx) <= 1,
   return;
end

pos = cell2mat(get(hx,'position')); % [xloc yloc width height]
%  [xloc yloc] use the lower-left corner as the origin

% prune the x-labels, i.e. find the axes with the
% smallest --> y <-- location, and only keep its labels.
if any(whichLabels=='x')
   xu = axisunion(hx, 'xlim'); % union-ed limits
   set(hx,'xlim', xu);
   % now turn off the ticks for the rest of the axes
   minval= min(pos(:,2));
   ii = find(pos(:,2) > minval);
   set(hx(ii),'xticklabel',[]);
end

if any(whichLabels=='y')
   yu = axisunion(hx, 'ylim'); % union-ed limits
   set(hx,'ylim', yu);
   minval= min(pos(:,1));
   ii = find(pos(:,1) > minval);
   set(hx(ii),'yticklabel',[]);
end

if exist('linkaxes','file')
   % if this function is first called with whichLabels='x'
   % and then with whichLabels='y', the second invocation
   % to LINKAXES will override the first. 
   linkaxes(hx, whichLabels);
end

%------------------------
function limits = axisunion(h, limtype)

axislims = get(h,limtype);
axislims = cat(1, axislims{:}); % convert to matrix
limits = [min(axislims(:,1)) max(axislims(:,2))]; % union-ed values

