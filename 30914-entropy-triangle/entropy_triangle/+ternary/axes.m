function [hold_state, cax, next] = axes(majors,ticks)
% TERNARY.AXES create ternary axis
%   [hold_state, cax, next]  = TERNARY.AXES(MAJORS) creates a ternary axis system using the system
%   defaults and with MAJORS major tickmarks with percentage labels at tick
%   marks. Returns the hold state of the plot.
%
% [hold_state, cax, next]  = TERNARY.AXES(MAJORS,'fractions')  returns the
% axes with fraction of unit at tick marks.

% Author: Carl Sandrock 20050211
% Modifications: FVA: 

% To Do

% Modifications

% Modifiers
% (CS) Carl Sandrock

percentage = 1;
if nargin > 1
    switch ticks
        case 'fraction'
            percentage = 0;
        otherwise
            percentage = 1;
    end
end

%TODO: Get a better way of offsetting the labels
xoffset = 0.01;
yoffset = 0.02;

% get hold state
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;

% get x-axis text color so grid is in same color
tc = get(cax,'xcolor');
ls = get(cax,'gridlinestyle');

% Hold on to current Text defaults, reset them to the
% Axes' font attributes so tick marks use them.
fAngle  = get(cax, 'DefaultTextFontAngle');
fName   = get(cax, 'DefaultTextFontName');
fSize   = get(cax, 'DefaultTextFontSize');
fWeight = get(cax, 'DefaultTextFontWeight');
fUnits  = get(cax, 'DefaultTextUnits');

set(cax, 'DefaultTextFontAngle',  get(cax, 'FontAngle'), ...
    'DefaultTextFontName',   get(cax, 'FontName'), ...
    'DefaultTextFontSize',   get(cax, 'FontSize'), ...
    'DefaultTextFontWeight', get(cax, 'FontWeight'), ...
    'DefaultTextUnits','data')

% only do grids if hold is off
if ~hold_state
	%plot axis lines
	hold on;
	plot ([0 1 0.5 0],[0 0 sin(1/3*pi) 0], 'color', tc, 'linewidth',1,...
                   'handlevisibility','off');
	set(gca, 'visible', 'off');

    % plot background if necessary
    if ~ischar(get(cax,'color')),
       patch('xdata', [0 1 0.5 0], 'ydata', [0 0 sin(1/3*pi) 0], ...
             'edgecolor',tc,'facecolor',get(gca,'color'),...
             'handlevisibility','off');
    end
    
	% Generate labels
	majorticks = linspace(0, 1, majors + 1);
	majorticks = majorticks(1:end-1);
    if percentage 
        labels = num2str(majorticks'*100);
    else
        labels = num2str(majorticks','%1.1g');%Doesn't work! I don't want it to put a leading zero, that's all!
    end
	
    zerocomp = zeros(size(majorticks)); % represents zero composition
    
	% Plot right labels (no c - only b a)
	[lxc, lyc] = ternary.coords(1-majorticks, majorticks, zerocomp);
	text(lxc, lyc, [repmat('  ', length(labels), 1) labels]);
	
	% Plot bottom labels (no b - only a c)
	[lxb, lyb] = ternary.coords(majorticks, zerocomp, 1-majorticks); % fB = 1-fA
	text(lxb, lyb, labels, 'VerticalAlignment', 'Top');
	
	% Plot left labels (no a, only c b)
	[lxa, lya] = ternary.coords(zerocomp, 1-majorticks, majorticks);
	%text(lxa-xoffset, lya, labels, 'HorizontalAlignment','right');
	text(lxa-xoffset, lya, labels, 'HorizontalAlignment','right');
	
	nlabels = length(labels)-1;
	for i = 1:nlabels
        plot([lxa(i+1) lxb(nlabels - i + 2)], [lya(i+1) lyb(nlabels - i + 2)], ls, 'color', tc, 'linewidth',1,...
           'handlevisibility','off');
        plot([lxb(i+1) lxc(nlabels - i + 2)], [lyb(i+1) lyc(nlabels - i + 2)], ls, 'color', tc, 'linewidth',1,...
           'handlevisibility','off');
        plot([lxc(i+1) lxa(nlabels - i + 2)], [lyc(i+1) lya(nlabels - i + 2)], ls, 'color', tc, 'linewidth',1,...
           'handlevisibility','off');
    end
end%if ~hold_state

% Reset defaults
set(cax, 'DefaultTextFontAngle', fAngle , ...
    'DefaultTextFontName',   fName , ...
    'DefaultTextFontSize',   fSize, ...
    'DefaultTextFontWeight', fWeight, ...
    'DefaultTextUnits', fUnits );
return%[hold_state, cax, next]
