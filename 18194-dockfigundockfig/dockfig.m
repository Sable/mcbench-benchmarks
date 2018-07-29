function dockfig(fig)
% Copyright 2008 The MathWorks, Inc.
% Programmatically dock one or all open figures.
% 
% SYNTAX:
% dockfig
%    Docks the current figure.
%
% dockfig(fig)
%    Docks figure with handle FIG, and brings it to the front.
%
% dockfig('all')
%    Docks all open figures
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
    set(fig(ii),'windowstyle','docked');
end
if numel(fig) == 1
    figure(fig);
end