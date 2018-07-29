function undockfig(fig)
% Copyright 2008 The MathWorks, Inc.
% Programmatically undock one or all open figures.
% 
% SYNTAX:
% undockfig
%    Undocks the current figure
%
% undockfig(fig)
%    Undocks figure with handle FIG, and brings it to the front.
%
% undockfig('all')
%    Undocks all open figures
%
% Written by Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% 01/01/08

% Revision 1
% 01/03/08: Providing default behavior when no input argument is provided
% (operates on current figure).

if nargin == 0
    fig = gcf;
end
if ischar(fig) && strcmpi(fig,'all')
    fig = findall(0,'type','figure');
end
for ii = 1:numel(fig)
    set(fig(ii),'windowstyle','modal');
    set(fig(ii),'windowstyle','normal');
end
if numel(fig) == 1
    figure(fig);
end