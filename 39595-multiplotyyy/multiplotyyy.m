function [ax,hlines] = multiplotyyy(set1,set2,set3,ylabels)
% MULTIPLOTYYY - Extends plotyy to include a third y-axis and allows the
% user to plot multiple lines on each set of axes.
%
% Syntax:  [ax,hlines] = plotyyy(set1,set2,set3,ylabels)
%
% Inputs: set1 is a cell array with the xdata and ydata for the first axes
%         set2 is a cell array with the xdata and ydata for the second axes
%         set3 is a cell array with the xdata and ydata for the third axes
%         ylabels is a 3x1 cell array containing the ylabel strings
%
% Outputs: ax -     3x1 double array containing the axes' handles
%          hlines - 3x1 cell array containing the lines' handles
%
% Example:
% x1 = (0:0.01:1)'; 
% x2 = (0:0.1:1)';
% x3 = (0:0.05:1)';
% y1 = x1;
% y2 = x2.^2;
% y3 = x3.^3;
% y4 = sin(x1);
% y5 = fliplr(2*x1.^2);
% y6 = 7*cos(x1);
% y7 = 7*log(x1+1.2);
% ylabels{1}='First y-label';
% ylabels{2}='Second y-label';
% ylabels{3}='Third y-label';
% [ax,hlines] = multiplotyyy({x1,y1,x2,y2,x3,y3,x1,y4},{x1,y5},{x1,[y6,y7]},ylabels);
% legend(cat(1,hlines{:}),'a','b','c','d','e','f','g','location','w')
% 
% Based on plotyyy.m (available at www.matlabcentral.com) by :
% Denis Gilbert, Ph.D.
% 
% Author: Laura L. Proctor
% December 23, 2012
% 

narginchk(3,4)

if nargin==3
   % Use empty strings for the ylabels
   ylabels{1}=' '; ylabels{2}=' '; ylabels{3}=' ';
end

validateattributes(set1,{'cell'},{})
validateattributes(set2,{'cell'},{})
validateattributes(set3,{'cell'},{})

fh = figure('units','normalized');
cfig = get(fh,'Color');

% Preallocate the outputs
ax = zeros(3,1);
hlines = cell(3,1);

% Plot the first set of lines
ax(1) = axes('Parent',fh);
hlines{1} = plot(set1{:},'Color','b');

set(ax(1),'YColor','b')

lines = set(hlines{1}(1),'LineStyle');
lines(end) = [];
nlines = numel(lines);
markers = set(hlines{1}(1),'Marker');
markers(end) = [];
nmarkers = numel(markers);

if numel(hlines{1}) > 1
    for idx = 1:numel(hlines{1})
        set(hlines{1}(idx),'LineStyle',lines{rem(idx,nlines)+1})
        if numel(hlines{1}) > 4
            set(hlines{1}(idx),'Marker',markers{rem(idx,nmarkers)+1});
        end
    end
end

% Plot the second set of lines
ax(2) = axes('Parent',fh);
hlines{2} = plot(set2{:},'Color',[0 0.5 0]);
set(ax(2),'YAxisLocation','right','Color','none','YColor',[0 0.5 0],...
    'xlim',get(ax(1),'xlim'),'xtick',[],'box','off','XColor','k');

if numel(hlines{2}) > 1
    for idx = 1:numel(hlines{2})
        set(hlines{2}(idx),'LineStyle',lines{rem(idx,nlines)+1})
        if numel(hlines{2}) > 4
            set(hlines{2}(idx),'Marker',markers{rem(idx,nmarkers)+1});
        end
    end
end

% Set the axes position and size
pos = [0.1  0.1  0.7  0.8];
offset = pos(3)/5.5;
pos(3) = pos(3) - offset/2;
set(ax(1),'Position',pos);  
set(ax(2),'Position',pos);  

% Determine the position of the third axes
pos3=[pos(1) pos(2) pos(3)+offset pos(4)];

% Determine the proper x-limits for the third axes
limx1=get(ax(1),'xlim');
limx3=[limx1(1)   limx1(1) + 1.2*(limx1(2)-limx1(1))];

ax(3) = axes('Parent',fh);
hlines{3} = plot(set3{:},'Color','r');
set(ax(3),'Position',pos3,'box','off',...
   'Color','none','XColor','k','YColor','r',...   
   'xtick',[],'xlim',limx3,'yaxislocation','right');

if numel(hlines{3}) > 1
    for idx = 1:numel(hlines{3})
        set(hlines{3}(idx),'LineStyle',lines{rem(idx,nlines)+1})
        if numel(hlines{3}) > 4
            set(hlines{3}(idx),'Marker',markers{rem(idx,nmarkers)+1});
        end
    end
end

limy3=get(ax(3),'YLim');

% Hide unwanted portion of the x-axis line that lies between the end of the
% second and third axes
line([limx1(2) limx3(2)],[limy3(1) limy3(1)],...
   'Color',cfig,'Parent',ax(3),'Clipping','off');
axes(ax(2))

% Label all three y-axes
set(get(ax(1),'ylabel'),'string',ylabels{1})
set(get(ax(2),'ylabel'),'string',ylabels{2})
set(get(ax(3),'ylabel'),'string',ylabels{3})
