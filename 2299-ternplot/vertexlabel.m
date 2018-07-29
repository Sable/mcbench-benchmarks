% VERTEXLABEL label ternary phase diagram at vertices
%   VERTEXLABEL('ALABEL', 'BLABEL', 'CLABEL') puts labels at vertices of ternary phase diagrams created using TERNPLOT
%   
%   VERTEXLABEL('ALABEL','BLABEL','CLABEL',OFFSET) sets the labels OFFSET units away from the vertices.
%   H = VERTEXLABEL('ALABEL', 'BLABEL', 'CLABEL') returns handles to the text objects created.
%   with the labels provided.  TeX escape codes are accepted.
%
%   See also TERNLABEL TERNPLOT TERNCONTOUR TERNCONTOURF

% Author: Peter Selkin 20030508 Modified from Carl Sandrock 20020827

% To Do

% Modifications

% Modifiers

function h = vertexlabel(A, B, C, offset)

if (nargin~=4)
	offset=0.03;
end

r(1) = text(-offset, -offset, A, 'horizontalalignment', 'right');
r(2) = text(1+offset, -offset, B, 'horizontalalignment', 'left');
r(3) = text(0.5, sin(deg2rad(60))+offset, C, 'horizontalalignment', 'center');

if nargout > 0
    h = r;
end;
