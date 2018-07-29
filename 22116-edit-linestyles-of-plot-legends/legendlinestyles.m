function legendlinestyles(h,markers,linestyles,linecolors)
% legendlinestyles(h,markers,linestyles,linecolors)
%==========================================================================
% Change the linestyles in an existing plot legend.
%
% Input: Handle to an existing legend object, h
%        (optional) Cell array with the new markers, markers
%        (optional) Cell array with the new linestyles, linestyles
%        (optional) Cell array with the new line and marker colors
% 
% If you do not want to change a markerstyle or linestyle, supply an empty
% array {}. See examples below.
%
% If the 'linestyles' arument is ommitted, the original lines are left
% unchanged. Note, that no lines in the actual plot are affected. If emtpy,
% {}, the styles are left unchanged but the colors are changed according to
% the fourth argument.
%
% Output: None
%
%
% Examples on how to use (see also accompanying file 
% legendlinestyles_test.m):
%
%  legendlinestyles(h, markers);
%  legendlinestyles(h, markers,linestyles);
%  legendlinestyles(h, markers,linestyles,linecolors);
%  legendlinestyles(h, markers,{},linecolors);
%  legendlinestyles(h, {},linestyles,linecolors);
%  legendlinestyles(h, {},{},linecolors);
%
%==========================================================================
% Version: 1.0
% Created: October 3, 2008, by Johan E. Carlson
% Last modified: May 12, 2009, by Johan E. Carlson
%==========================================================================


lines = findobj(get(h,'children'),'type','line');
m = 1;
for k = length(lines):-2:1,
    if ~isempty(markers),
        set(lines(k-1),'marker',char(markers{m}));
    end
    if (nargin >= 3) && (~isempty(linestyles)),
        set(lines(k),'linestyle',char(linestyles{m}));
    end
    if nargin == 4,
        if ischar(linecolors{m})==1,
            set(lines(k),'color',char(linecolors{m}));
            if ~isempty(markers),
                set(lines(k-1),'MarkerEdgeColor',char(linecolors{m})); 
            end
        else
            set(lines(k),'color',linecolors{m});
            if ~isempty(markers),
                set(lines(k-1),'MarkerEdgeColor',linecolors{m});
            end
        end
    end
    m = m+1;
end
