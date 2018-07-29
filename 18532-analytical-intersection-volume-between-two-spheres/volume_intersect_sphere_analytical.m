function M = volume_intersect_sphere_analytical(varargin)
% Compute the overlap volume between 2 spheres defined in an array.
% Computation is vectorized, and intersection volume are computed an
% analytical way.
%
% Input: spheres data presented in an array G of four columns.
%        G contains parameters of the n spheres
%           . G(1:n,1) - x-coordinate of the center of spheres,
%           . G(1:n,2) - y-coordinate of the center of spheres,
%           . G(1:n,3) - z-coordinate of the center of spheres,
%           . G(1:n,4) - radii of the spheres
%        Each row of the array contains the information for one sphere.
%
%        Input can also be provided in three different vectors. These
%        vectors can be row or column vectors. The 1st one corresponds to
%        x-coordinate of the center of spheres, the 2nd one to the
%        y-coordinate, the 3rd one to the z-coordinate and the 4th one to
%        the radii of the spheres.
%        An optional binary argument can be provided to display or not the
%        result.
%
% Output: Square matrix M(n,n) containing intersection volumes between
% spheres
%         M(i,j) contains the intersection volume between spheres i & j
%         By definition, M(i,i) corresponds to the volume of sphere i.
%
%
% Examples
%
%         x = [0,1,5,3,-5];
%         y = [0,4,3,7,0];
%         z = [0,4,3,7,0];
%         r = [1,5,3,2,2];
%         Display_solution = true;
%         disp('First call')
%         M = volume_intersect_sphere_analytical(x,y,z,r,Display_solution);
%         disp('Second call')
%         M = volume_intersect_sphere_analytical([x',y',z',r'],false);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For 2 spheres i & j, three cases are possible depending on the distance
% d(i,j) of the centers of the spheres i and j.
%   Case 1: spheres i & j do not overlap, there is no overlap volume
%           M(i,j)=0;
%             Condition: d(i,j)>= ri+rj
%             M(i,j) = 0;
%   Case 2: spheres i & j fully overlap, the overlap volume has to be
%           computed.
%             Condition: d(i,j)<= abs(ri-rj)
%             M(i,j) = 4/3*pi*min(ri,rj).^3
%   Case 3: spheres i & j partially overlap, the overlap volume has to be
%           computed decomposing the overlap volume.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Guillaume JACQUENOT
% guillaume dot jacquenot at gmail dot com
% 2008 01 31
% 2009 09 10
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==0
    % Performs an example
    % Creation of 5 spheres
    x = [0,1,5,3,-5];
    y = [0,4,3,7,0];
    z = [0,4,3,7,0];
    r = [1,5,3,2,2];
    Display_solution = true;
elseif nargin==1 || nargin==2
    temp = varargin{1};
    x = temp(:,1);
    y = temp(:,2);
    z = temp(:,3);
    r = temp(:,4);
    if nargin == 2
        Display_solution = varargin{2};
    else
        Display_solution = false;
    end
elseif nargin==4 || nargin==5
    x = varargin{1};
    y = varargin{2};
    z = varargin{3};
    r = varargin{4};
    if nargin == 5
        Display_solution = varargin{5};
    else
        Display_solution = false;
    end
else
    help volume_intersect_sphere_analytical
    error('volume_intersect_sphere_analytical:e0',...
          'The number of arguments must 0, 1, 2, 4 or 5');
end

% Checking input argument
if ~islogical(Display_solution)
    error('volume_intersect_sphere_analytical:e1',...
          'Display_solution should be logical variable')
end

% Inputs are reshaped
size_x = numel(x);
size_y = numel(y);
size_z = numel(z);
size_r = numel(r);

x = reshape(x,size_x,1);
y = reshape(y,size_y,1);
z = reshape(z,size_z,1);
r = reshape(r,size_r,1);

% Checking if the three input vectors have the same length
if (size_x~=size_y)||(size_x~=size_z)||(size_x~=size_r)
    error('volume_intersect_sphere_analytical:e2',...
          'Input of function must be the same length');
end

% Checking if there is any negative or null radius
if any(r<=0)
    disp(['spheres with null or negative radius'...
          ' won''t be taken into account in the computation.'])
    temp = (r>0);
    x = x(temp);
    y = y(temp);
    z = z(temp);
    r = r(temp);
end

% Checking the size of the input argument
if size_x==1
    M = 4/3*pi*r.^3;
    return
end

% Computation of distance between all spheres, which will allow to
% determine which cases to use.
X = meshgrid(x);
Y = meshgrid(y);
Z = meshgrid(z);
D = sqrt((X-X').^2+(Y-Y').^2+(Z-Z').^2);


% Since the resulting matrix M is symmetric M(i,j)=M(j,i), computations are
% performed only on the upper part of the matrix
D = triu(D,1);

[R1,R2] = meshgrid(r);
sumR    = triu(R1+R2,1);
difR    = triu(abs(R1-R2),1);

% Creating the resulting vector
M = zeros(size_x*size_x,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% C2: Case 2: spheres i & j fully overlap
% One of the spheres is inside the other one.
C2    = triu(D<=difR);
M(C2) = 4/3*pi*min(R1(C2),R2(C2)).^3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Case 3: spheres i & j partially overlap
% Partial intersection between spheres i & j
C3 = (D>difR)&(D<sumR);
% Computation of the coordinates of one of the intersection points of the
% spheres i & j
Xi(C3,1) = (R1(C3).^2-R2(C3).^2+D(C3).^2)./(2*D(C3));

H1(C3,1) = R1(C3)-Xi(C3,1);
H2(C3,1) = R2(C3)+Xi(C3,1)-D(C3);

% Computation of the partial intersection volume between spheres i & j
M(C3,1) = pi/3*(H1(C3,1).^2.*(3*R1(C3)-H1(C3,1))+...
                H2(C3,1).^2.*(3*R2(C3)-H2(C3,1)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Compute the volume of each sphere.
% Assign the results to the diagonal of M
M(1:size_x+1:size_x*size_x) = 4/3*pi.*r.^3;

% Conversion of vector M to matrix M
M = reshape(M,size_x,size_x);

% Creating the lower part of the matrix
M = M + tril(M',-1);

% Display results if no argument is provided
if Display_solution
    f = figure;
    hAxs = axes('Parent',f);
    hold on, box on, axis equal
    xlabel('x')
    ylabel('y','Rotation',0)
    zlabel('z','Rotation',0)
    title(['Compute the intersection volume between 2 '...
           ' spheres a vectorized way for several spheres'])
    colour = rand(size_x,3);
    [X,Y,Z]=sphere(20);
    for t = 1: size_x
        surf(x(t)+r(t)*X,y(t)+r(t)*Y,z(t)+r(t)*Z,...
            'FaceColor',colour(t,:),'EdgeColor','none','parent',hAxs)

%         surf(x(t)+r(t)*X,y(t)+r(t)*Y,z(t)+r(t)*Z,...
%             'FaceColor','none','parent',hAxs)
        for u = t+1:size_x
            if M(t,u)~=0
              plot3([x(t),x(u)],[y(t),y(u)],[z(t),z(u)],'k-','parent',hAxs)
              text((x(t)+x(u))/2,(y(t)+y(u))/2,(z(t)+z(u))/2,...
                    num2str(M(t,u)),...
                    'HorizontalAlignment','center',...
                    'BackgroundColor',[1 1 1],'parent',hAxs)
            end
        end
    end
    axis tight
    view([  0.8765    0.7660   -0.0000   -0.8213
           -0.6140    0.3778    0.8090   -0.2864
           -0.8451    0.5200   -0.5878   10.2792
                 0         0         0    1.0000])
end
