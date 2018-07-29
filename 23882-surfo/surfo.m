function h = surfo(varargin)

% surfo surface plot with workaround surface normals for OpenGL renderer
%
% Syntax: 
%     surfo(Z)
%     surfo(Z,C)
%     surfo(X,Y,Z)
%     surfo(X,Y,Z,C)
%     surfo(...,'PropertyName',PropertyValue)
%     surfo(axes_handles,...)
%
% Only use surfo as a subsitute for surf if you need both transparency and
% flat lighting and the OpenGL renderer produces wrong results (see
% Example). 
%
% surfo replaces the surface's standard 'VertexNormals' data with the face
% normal data computed by facenorm.
% surfo always switches the figure's renderer to OpenGL as the new normal
% data is not suited for lighting with the zbuffer renderer.
%
% Example:
% 
%   % generate some demo data
%   [Y,Z,X] = cylinder([0.8 1 1 0.8],144);
%   idxShift = mod(1:size(X,2),4)>1;
%   X(2,idxShift) = X(2,idxShift)-0.2;
%   X(3,idxShift) = X(3,idxShift)+0.2;
%  
%   % standard surf plot
%   figure(1)
%   surf(X,Y,Z,'EdgeAlpha',0.2,'FaceColor','c')
%   axis equal
%   light('Position',[0 0 1],'Style','infinite')
%   
%   % same plot with surfo 
%   % (giving symmetrical lighting, as it should)
%   figure(10)
%   surfo(X,Y,Z,'EdgeAlpha',0.2,'FaceColor','c')
%   axis equal
%   light('Position',[0 0 1],'Style','infinite')
%
% See also surf, facenorm

% Andres, 2009-07-08

args = varargin;

% plot with surf
hs = surf(args{:});

% switch to OpenGL renderer
fig = ancestor(hs,'figure');
set(fig,'Renderer','OpenGL')

% extract surface coordinate data
X = get(hs,'XData');
Y = get(hs,'YData');
Z = get(hs,'ZData');

% use workaround normals
set(hs,'VertexNormals',facenorm(X,Y,Z));

if nargout > 0
    h = hs;
end