function [Y,h]=glyph(X,r,c)
%Syntax: [Y,h]=glyph(X,r,c)
%__________________________
%
% 3D glyph visualization. The glyph is a convex deltahedron where each
% node is connected to its 6 nearest nodes.
%
% Y is the N-by-3 matrix whith the cartesian coordinates of the points on 
%   the glyph.
% h returns a vector of tetrahedra handles. Each element of h is a handle
%   to the set of patches forming one tetrahedron. Type "help tetramesh"
%   for more info.
% X is the N-by-3 matrix whith the cartesian coordinates of the points on 
%   the sphere.
% r is the range parameter.
% c is the color parameter.
%
%
% References:
%
% Sangole A., Knopf G. K. (2002): Representing high-dimensional data sets
% as close surfaces. Journal of Information Visualization 1: 111-119
%
% Sangole A., Knopf G. K. (2003): Geometric representations for
% high-dimensional data using a spherical SOFM. International Journal of
% Smart Engineering System Design 5: 11-20
%
% Sangole A., Knopf G. K. (2003): Visualization of random ordered numeric
% data sets using self-organized feature maps. Computers and Graphics 27:
% 963-976
%
% Sangole A. P. (2003): Data-driven Modeling using Spherical
% Self-organizing Feature Maps. Doctor of Philosophy (Ph.D.) Thesis. 
% Department of Mechanical and Materials Engineering. Faculty of
% Engineering. The University of Western Ontario, London, Ontario, Canada.
%
%
% Remark:
%
% If no output is desired, the function plots the glyph.
%
%
% Archana P. Sangole, PhD., P.E. (TX chapter)
% School of Physical & Occupational Therapy
% McGill University
% 3654 Promenade Sir-William-Osler
% Montreal, PQ, H3G 1Y5
% e-mail: archana.sangole@mail.mcgill.ca
%
% CRIR, Rehabilitation Institute of Montreal
% 6300 Ave Darlington
% Montreal, PQ, H3S 2J5
% Tel: 514.340.2111 x2188
% Fax: 514.340.2154
%
%
% Alexandros Leontitsis, PhD
% Department of Education
% University of Ioannina
% 45110- Dourouti
% Ioannina
% Greece
% 
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
% 
% 23-Mar-2006


% Add a center to the sphere, which is [0 0 0]
X=[X;zeros(1,3)];

% 3-dimensional Delaunay tessellation
tri=delaunay3(X(:,1),X(:,2),X(:,3));

% Remove the center
X(end,:)=[];

if nargin<2 | isempty(r)==1
    r=ones(length(X),1);
else
    % r must be a vector
    if min(size(r))>1
        error('r must be a vector.');
    end
    % The length of r should be equal to the length of X.
    if length(r)~=length(X)
        error('The length of r should be equal to the length of X.');
    end
    r=r(:);
end

if nargin<3 | isempty(c)==1
    c=r;
else
    % c must be a vector
    if min(size(c))>1
        error('c must be a vector.');
    end
    % The length of c should be equal to the length of X.
    if length(c)~=length(X)
        error('The length of c should be equal to the length of X.');
    end
    c=c(:);
end

% Go to spherical coordinates, ...
[theta,phi]=cart2sph(X(:,1),X(:,2),X(:,3));
% ... and compute the cartesian coordinates with the given r
[Y(:,1),Y(:,2),Y(:,3)]=sph2cart(theta,phi,r);

% Add a center to the glyph, which is [0 0 0]
Y=[Y;zeros(1,3)];
% Sort the vertices of each tereahedron ...
tri=sort(tri')';
% ... in order to calculate the color
i=1:length(tri);
cnew(i)=mean(c(tri(i,1:end-1))')';

% If no output is desired, plot the glyph
if nargout==0
    % Plot the glyph
    tetramesh(tri,Y,cnew,'FaceAlpha',1,'LineStyle','-');
    % Define the x axis
    xlim([-1.2 1.2])
    % Define the y axis
    ylim([-1.2 1.2])
    % Define the z axis
    zlim([-1.2 1.2])
    % Define the color axis
    caxis([1 1.2]);
    % Remove the axes
    axis off
    % Freeze aspect ratio properties to faciliate 3D rotation
    axis vis3d
% Else if the handle is desired
elseif nargout==2
    % Retrieve the handle
    h=tetramesh(tri,Y,cnew,'FaceAlpha',1,'LineStyle','none');
end