function N = facenorm(X,Y,Z)

% facenorm compute alternate surface normals for OpenGL surface plots
%
% N = facenorm(X,Y,Z);
%
% X,Y,Z surface coordinates as used with surf
% N     3D array with normal coordinates to be used as value for
%       'VertexNormals' property in surface plots that use OpenGL renderer
%       and flat lighting
%
% EXAMPLE:
% 
% % generate some demo data
% [Y,Z,X] = cylinder([0.8 1 1 0.8],144);
% idxShift = mod(1:size(X,2),4)>1;
% X(2,idxShift) = X(2,idxShift)-0.2;
% X(3,idxShift) = X(3,idxShift)+0.2;
%
%
% % standard surf plot
% figure(1)
% surf(X,Y,Z,'EdgeAlpha',0.2,'FaceColor','c')
% axis equal
% light('Position',[0 0 1],'Style','infinite')
% view(0,60)
%
% 
% % same plot with alternate surface normals 
% % (giving symmetrical lighting, as it should)
% figure(10)
% surf(X,Y,Z,'EdgeAlpha',0.2,'FaceColor','c',...
% 'VertexNormals',facenorm(X,Y,Z))
% axis equal
% light('Position',[0 0 1],'Style','infinite')
% view(0,60)
%
% See also surfo

% Andres, 2009-07-09
% v1.01  with improved code efficiency as suggested by Jan Simon

% input checking left to surf et.al. ...

if numel(Z) > numel(X) || numel(Z) > numel(Y);
    [X,Y] = meshgrid(X,Y);
end

coord = cat(3,X,Y,Z);

% edge vectors
d1 = diff(coord,1,1);
d2 = diff(coord,1,2);

% normals of opposing pairs of edge vectors 
% (i.e. at the opposing corners of the quadrilaterals)
n1 = cross_plain(d2(1:end-1,:,:), d1(:,1:end-1,:));
n2 = cross_plain(d2(2:end, :, :), d1(:, 2:end, :));

% add the normals to get an average normal of the face
n = n1 + n2;

% normalize
mag = sqrt(sum(n.^2,3));
mag(mag==0)=eps;
n = n./repmat(mag,[1 1 3]);

% arrange data for surf's 'VertexNormals' property
N = NaN(size(n)+[1 1 0]);
N(2:end,2:end,:) = n;

function c = cross_plain(a,b)

% cross_plain vector cross product without overhead
%
% c = cross_plain(a,b) returns the cross product of the vectors a and b.
%
% Faster direct cross product calculation without input checking.

c = cat(3, ...
    a(:, :, 2) .* b(:, :, 3) - a(:, :, 3) .* b(:, :, 2), ...
    a(:, :, 3) .* b(:, :, 1) - a(:, :, 1) .* b(:, :, 3), ...
    a(:, :, 1) .* b(:, :, 2) - a(:, :, 2) .* b(:, :, 1));