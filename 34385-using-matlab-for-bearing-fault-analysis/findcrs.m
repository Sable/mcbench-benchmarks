function [No, H] = findcrs(fig, ax)
%[No, h] = findcursor(fig)
% find all cursor within a window
%
%[No, h] = findcursor(fig,ax)
% find all cursor within axes

No=[]; H=[];
if (nargin<1)
    h = findobj('type', 'line');
elseif (nargin == 2)	% ax => axes
    h = findobj('type', 'line', 'parent', ax);
elseif (nargin==1)	% fig
    ax = findobj('parent', fig, 'type', 'axes');
    h = [];
    for q = 1:length(ax) %#ok<FORPF>
        h = [h ; findobj('type','line','parent',ax)];
    end
end
for q = 1:length(h)
    S = get(h(q),'tag');
    if (length(S) > 6)
        if strcmp(S(1:6),'cursor')
            H = [H h(q)] ;
            Cno = eval(S(7)) ;
            No = [No Cno];
        end
    end
end
