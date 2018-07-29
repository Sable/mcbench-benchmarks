function C=sphereneigh(X,radius)
%Syntax: C=sphereneigh(X,radius)
%_______________________________
%
% Neighborhood selection on a tesselated sphere. 
%
% C is a cell array with the neighbors. The {i,j} cell represents the
%   neighbors of radius i of the j-th sphere point. If no neighbors are
%   found, the cell {i,j} reamains empty.
% X is the N-by-3 matrix whith the cartesian coordinates of the points on 
%   the sphere.
% radius is the neighborhood range parameter, with radius>=1.
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


if isempty(X)==1
    error('Input the cartesian coordinates of the points on the sphere.');
else
    % X must be an M-by-3 matrix
    if size(X,2)~=3 | ndims(X)~=2
        error('X must be an N-by-3 matrix.');
    end
end

if nargin<2 | isempty(radius)==1
    radius=1;
else
    % radius must be a scalar
    if sum(size(radius))>2
        error('radius must be a scalar.');
    end
    % radius must be an integer
    if radius~=round(radius)
        error('radius must be an integer.');
    end
    % radius must be positive
    if radius<1
        error('radius must be positive.');
    end
end


% Add a center to the sphere, which is [0 0 0]
X=[X;zeros(1,3)];

% 3-dimensional Delaunay tessellation
tri=delaunay3(X(:,1),X(:,2),X(:,3));

% Sort the results
tri=sort(tri')';

% Remove the last column
tri(:,end)=[];

% For each point on the shpere
for i=1:length(X)-1
    % For each neighborhood radious
    for j=1:radius
        % Locate the search point(s)
        z=[];
        if j==1
            m=i;
        else
            m=C{i,j-1};
        end
        % Track the tetrahedra that start form the search point(s)
        for k=1:3
            for l=1:length(m)
                z=[z;find(tri(:,k)==m(l))];
            end
        end
        % Find the neighbors of the search point(s) + the search point(s)
        z=unique(tri(z,:));
        % Track the neighbors found so far + the search point(s)
        m=[];
        if j==1
            m=i;
        elseif j==2
            m=[i;C{i,j-1}];
        else
            m=[C{i,j-2};C{i,j-1}];
        end
        % Remove the neighbors found so far + the search point(s)
        for k=1:length(m)
            z(find(z==m(k)))=[];
        end
        % Now z represents the radius j nearest neighbors of X(i,:)
        C{i,j}=z;
    end
end