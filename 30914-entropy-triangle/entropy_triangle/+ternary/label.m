function h = label(A, B, C)
% TERNARY.LABEL label ternary phase diagram
%   TERNARY.LABEL('ALABEL', 'BLABEL', 'CLABEL') labels a ternary phase diagram created using TERNARY.PLOT
%   
%   H = TERNARY.LABEL('ALABEL', 'BLABEL', 'CLABEL') returns handles to the
%   text objects created with the labels provided.  LaTeX escape codes are accepted.
%
%   See also TERNARY.PLOT

% Author: Carl Sandrock 20020827
% Modifications: FVA

% To Do

% Modifications

% Modifiers

% r(1) = text(0.5, -0.05, A, 'horizontalalignment', 'center');
% r(2) = text(1-0.45*sin(deg2rad(30)), 0.5, B, 'rotation', -60, 'horizontalalignment', 'center');
% r(3) = text(0.45*sin(deg2rad(30)), 0.5, C, 'rotation', 60, 'horizontalalignment', 'center');
r(1) = text(0.5, -0.07, A, 'horizontalalignment', 'center','Interpreter','latex');
r(2) = text(1-0.42*sin(deg2rad(30)), 0.5, B, 'rotation', -60, 'horizontalalignment', 'center','Interpreter','latex');
r(3) = text(0.40*sin(deg2rad(30)), 0.5, C, 'rotation', 60, 'horizontalalignment', 'center','Interpreter','latex');
if nargout > 0
    h = r;
end;
