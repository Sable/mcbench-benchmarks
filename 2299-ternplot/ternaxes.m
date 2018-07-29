% TERNAXES create ternary axis
%   HOLD_STATE = TERNAXES(MAJORS) creates a ternary axis system using the system
%   defaults and with MAJORS major tickmarks.

% Author: Carl Sandrock 20050211

% To Do

% Modifications

% Modifiers
% (CS) Carl Sandrock


function [hold_state, cax, next] = ternaxes(majors)

%TODO: Get a better way of offsetting the labels
xoffset = 0.04;
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
    if ~isstr(get(cax,'color')),
       patch('xdata', [0 1 0.5 0], 'ydata', [0 0 sin(1/3*pi) 0], ...
             'edgecolor',tc,'facecolor',get(gca,'color'),...
             'handlevisibility','off');
    end
    
	% Generate labels
	majorticks = linspace(0, 1, majors + 1);
	majorticks = majorticks(1:end-1);
	labels = num2str(majorticks'*100);
	
    zerocomp = zeros(size(majorticks)); % represents zero composition
    
	% Plot right labels (no c - only b a)
	[lxc, lyc] = terncoords(1-majorticks, majorticks, zerocomp);
	text(lxc, lyc, [repmat('  ', length(labels), 1) labels]);
	
	% Plot bottom labels (no b - only a c)
	[lxb, lyb] = terncoords(majorticks, zerocomp, 1-majorticks); % fB = 1-fA
	text(lxb, lyb, labels, 'VerticalAlignment', 'Top');
	
	% Plot left labels (no a, only c b)
	[lxa, lya] = terncoords(zerocomp, 1-majorticks, majorticks);
	text(lxa-xoffset, lya, labels);
	
	nlabels = length(labels)-1;
	for i = 1:nlabels
        plot([lxa(i+1) lxb(nlabels - i + 2)], [lya(i+1) lyb(nlabels - i + 2)], ls, 'color', tc, 'linewidth',1,...
           'handlevisibility','off');
        plot([lxb(i+1) lxc(nlabels - i + 2)], [lyb(i+1) lyc(nlabels - i + 2)], ls, 'color', tc, 'linewidth',1,...
           'handlevisibility','off');
        plot([lxc(i+1) lxa(nlabels - i + 2)], [lyc(i+1) lya(nlabels - i + 2)], ls, 'color', tc, 'linewidth',1,...
           'handlevisibility','off');
	end;
end;

% Reset defaults
set(cax, 'DefaultTextFontAngle', fAngle , ...
    'DefaultTextFontName',   fName , ...
    'DefaultTextFontSize',   fSize, ...
    'DefaultTextFontWeight', fWeight, ...
    'DefaultTextUnits', fUnits );
