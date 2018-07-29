% Clear extra lines from plot for ZNLDetect.m
%
% Matt Allen, July 2005-Aug 2006

global ZNLD

chs = get(102,'Children');
ax_h = find(strcmp(get(chs,'Type'),'axes') & ~strcmp(get(chs,'Tag'),'legend'))

all_lhs =  get(chs(ax_h),'Children');
clear_lhs = setdiff(all_lhs,ZNLD.lhands.hands);

% Delete all the lines that you're not using.
delete(clear_lhs);
% Create Legend
legend(ZNLD.lhands.hands, ZNLD.lhands.legend);