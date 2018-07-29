function [X,h]=trig(n)
%Syntax: [X,h]=trig(n)
%_____________________
%
% 3D sphere visualization. The sphere is a convex deltahedron where each
% node is connected to its 6 nearest nodes.
%
% X is the N-by-3 matrix whith the cartesian coordinates of the points on 
%   the sphere.
% h returns a vector of tetrahedra handles. Each element of h is a handle
%   to the set of patches forming one tetrahedron. Type "help tetramesh"
%   for more info.
% n is the precision parameter, n>=0.
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
% If no output is desired, the function plots the shpere.
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


if nargin<1 | isempty(n)==1
    n=1;
else
    % n must be a scalar
    if sum(size(n))>2
        error('n must be a scalar.');
    end
    % n must be non-negative
    if n<0
        error('n must be non-negative.');
    end
    % n must be an integer
    if n~=round(n)
        error('n must be an integer.');
    end
end


% Part 1: Initialization. Construct the nodes in sherical coordinates
phi=[1;-1;1/3*ones(5,1);-1/3*ones(5,1)]*pi/2;
theta=[zeros(2,1);(0:4)'/5;((0:4)'+0.5)/5]*2*pi;

% The ranges are set equal to 1
r=ones(size(theta));


% Part 2: Divide the achmes by 2
for i=1:n
    % Compute the cartesian coordinates
    [x,y,z] = sph2cart(theta,phi,r);
    X=[x,y,z];
    % Add a center to the sphere, which is [0 0 0]
    X=[X;zeros(1,3)];
    % 3-dimensional Delaunay tessellation
    tri=delaunay3(X(:,1),X(:,2),X(:,3));
    % Sort the vertices
    tri=sort(tri')';
    
    % Compute the divisions
    for j=1:length(tri)
        x=[x;(x(tri(j,1))+x(tri(j,2)))/2];
        x=[x;(x(tri(j,2))+x(tri(j,3)))/2];
        x=[x;(x(tri(j,3))+x(tri(j,1)))/2];
        y=[y;(y(tri(j,1))+y(tri(j,2)))/2];
        y=[y;(y(tri(j,2))+y(tri(j,3)))/2];
        y=[y;(y(tri(j,3))+y(tri(j,1)))/2];
        z=[z;(z(tri(j,1))+z(tri(j,2)))/2];
        z=[z;(z(tri(j,2))+z(tri(j,3)))/2];
        z=[z;(z(tri(j,3))+z(tri(j,1)))/2];
    end
    
    % Remove the redundant points
    X=[x,y,z];
    X=[X;zeros(1,3)];
    tri=delaunay3(X(:,1),X(:,2),X(:,3));
    z=unique(tri);
    X=X(z,:);
    x=X(1:end-1,1);
    y=X(1:end-1,2);
    z=X(1:end-1,3);
    
    % Go to spherical coordinates, ...
    [theta,phi,r]=cart2sph(x,y,z);
    % ... and make the ranges equal to 1
    r=ones(size(theta));
end


% Part 3: The final coordinates (without the center of the sphere)
[x,y,z] = sph2cart(theta,phi,r);
X=[x,y,z];

% If no output is desired, plot the shpere
if nargout==0
    % Add a center to the sphere, which is [0 0 0]
    X=[X;zeros(1,3)];
    % 3-dimensional Delaunay tessellation
    tri = delaunay3(X(:,1),X(:,2),X(:,3));
    % Sort the vertices
    tri=sort(tri')';
    % The color is propotional to the z coordinate
    i=1:length(tri);
    c(i)=mean(z(tri(i,1:end-1))');
    % Plot the sphere
    tetramesh(tri,X,c,'FaceAlpha',1,'LineStyle','-');
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
    % Add a center to the sphere, which is [0 0 0]
    X=[X;zeros(1,3)];
    % 3-dimensional Delaunay tessellation
    tri = delaunay3(X(:,1),X(:,2),X(:,3));
    % The color is propotional to the z coordinate
    i=1:length(tri);
    c(i)=mean(z(tri(i,1:end-1))');
    % Retrieve the handle
    h=tetramesh(tri,X,c,'FaceAlpha',1,'LineStyle','none');
end
