function M = area_intersect_circle_analytical(varargin)
% Compute the overlap area between 2 circles defined in an array.
% Computation is vectorized, and intersection area are computed an
% analytical way.
%   
% Input: Circles data presented in an array G of three columns.
%        G contains parameters of the n circles
%           . G(1:n,1) - x-coordinate of the center of circles,
%           . G(1:n,2) - y-coordinate of the center of circles,
%           . G(1:n,3) - radii of the circles 
%        Each row of the array contains the information for one circle.
% 
%        Input can also be provided in three different vectors. These
%        vectors can be row or column vectors. The 1st one corresponds to
%        x-coordinate of the center of circles, the 2nd one to the
%        y-cooridnate and the 3rd one to the radii of the circles.
% 
% 
% Output: Square matrix M(n,n) containing intersection areas between
% circles
%         M(i,j) contains the intersection area between circles i & j
%         By definition, M(i,i) corresponds to the area of circle i.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For 2 circles i & j, three cases are possible depending on the distance
% d(i,j) of the centers of the circles i and j.
%   Case 1: Circles i & j do not overlap, there is no overlap area M(i,j)=0;
%             Condition: d(i,j)>= ri+rj
%             M(i,j) = 0;
%   Case 2: Circles i & j fully overlap, the overlap area has to be computed.
%             Condition: d(i,j)<= abs(ri-rj)
%            M(i,j) = pi*min(ri,rj).^2
%   Case 3: Circles i & j partially overlap, the overlap area has to be computed
%            decomposing the overlap area.
%             Condition: (d(i,j)> abs(ri-rj)) & (d(i,j)<(ri+rj))
%            M(i,j) = f(xi,yi,ri,xj,yj,rj)
%                   = ri^2*arctan2(yk,xk)+ ...
%                     rj^2*arctan2(yk,d(i,j)-xk)-d(i,j)*yk
%             where xk = (ri^2-rj^2+d(i,j)^2)/(2*d(i,j))
%                   yk = sqrt(ri^2-xk^2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Guillaume JACQUENOT
% guillaume.jacquenot@gmail.com
% 2007_06_08

% Some explanations, comments were added. Input arguments are detailed.
% Verifications of input arguments are performed.
% The number of calculations has been divided by two.
 




if nargin==0
    % Performs an example
    % Creation of 5 circles
    x = [0,1,5,3,-5];    
    y = [0,4,3,7,0];    
    r = [1,5,3,2,2];   
elseif nargin==1
    temp = varargin{1};
    x = temp(:,1);
    y = temp(:,2);
    r = temp(:,3);    
elseif nargin==3
    x = varargin{1};
    y = varargin{2};
    r = varargin{3};    
else
    error('The number of arguments must 0, 1 or 3')
end

% Inputs are reshaped in 
size_x = numel(x);
size_y = numel(y);
size_r = numel(r);

x = reshape(x,size_x,1);
y = reshape(y,size_y,1);
r = reshape(r,size_r,1);

% Checking if the three input vectors have the same length
if (size_x~=size_y)||(size_x~=size_r)
    error('Input of function must be the same length')
end

% Checking if there is any negative or null radius
if any(r<=0)
    disp('Circles with null or negative radius won''t be taken into account in the computation.')
    temp = (r>0);
    x = x(temp);
    y = y(temp);
    r = r(temp);
end

% Checking the size of the input argument
if size_x==1
    M = pi*r.^2;
    return
end

% Computation of distance between all circles, which will allow to
% determine which cases to use.
[X,Y] = meshgrid(x,y);
D     = sqrt((X-X').^2+(Y-Y').^2);
% Since the resulting matrix M is symmetric M(i,j)=M(j,i), computations are
% performed only on the upper part of the matrix
D = triu(D,1);

[R1,R2] = meshgrid(r);
sumR    = triu(R1+R2,1);
difR    = triu(abs(R1-R2),1);


% Creating the resulting vector
M = zeros(size_x*size_x,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Case 2: Circles i & j fully overlap
% One of the circles is inside the other one.
C1    = triu(D<=difR);
M(C1) = pi*min(R1(C1),R2(C1)).^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Case 3: Circles i & j partially overlap
% Partial intersection between circles i & j
C2 = (D>difR)&(D<sumR);
% Computation of the coordinates of one of the intersection points of the
% circles i & j
Xi(C2,1) = (R1(C2).^2-R2(C2).^2+D(C2).^2)./(2*D(C2));
Yi(C2,1) = sqrt(R1(C2).^2-Xi(C2).^2);
% Computation of the partial intersection area between circles i & j
M(C2,1) = R1(C2).^2.*atan2(Yi(C2,1),Xi(C2,1))+...
          R2(C2).^2.*atan2(Yi(C2,1),(D(C2)-Xi(C2,1)))-...
          D(C2).*Yi(C2,1);
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
% Compute the area of each circle. Assign the results to the diagonal of M      
M(1:size_x+1:size_x*size_x) = pi.*r.^2; 

% Conversion of vector M to matrix M      
M = reshape(M,size_x,size_x);

% Creating the lower part of the matrix
M = M + tril(M',-1);


% Display results if no argument is provided
if nargin==0
    f = figure;
    hAxs = axes('Parent',f);
    hold on, box on, axis equal
    xlabel('x')
    ylabel('y','Rotation',0)
    title('Compute the intersection area between 2 circles a vectorized way for several cicles')
    text(-2,-2,'Numbers on lines represent the intersection')
    text(-2,-3,'area between 2 circles')
    axis([-8 9 -4 10])    
    colour = rand(size_x,3);    
    for t = 1: size_x
        plot(x(t)+r(t).*cos(0:2*pi/100:2*pi),...
             y(t)+r(t).*sin(0:2*pi/100:2*pi),'color',colour(t,:),'parent',hAxs)
        plot(x(t),y(t),'+','color',colour(t,:),'parent',hAxs)
        for u = t+1:size_x
            if M(t,u)~=0
                plot([x(t),x(u)],[y(t),y(u)],'k-','parent',hAxs)
                text((x(t)+x(u))/2,(y(t)+y(u))/2,num2str(M(t,u)),...
                    'HorizontalAlignment','center',...
                    'BackgroundColor',[1 1 1],'parent',hAxs)
            end
        end
        
    end
end

% function A=cercle_inter(G)
% % Guillaume JACQUENOT
% % guillaume.jacquenot@gmail.com
% % 2007_05_20
% % % Input: G - array, which contain parameters of the circles
% %          G(n,1) - x-coordinate,
% %          G(n,2) - y-coordinate,
% %          G(n,3) - radius of circle number n=1,2
% % Output:  A - area of the overlapping circles
% d=sqrt((G(1,1)-G(2,1))^2+(G(1,2)-G(2,2))^2);
% 
% if d>=(G(1,3)+G(2,3))
%     % No contact between circles.
%     A=0;
% elseif d<=abs(G(1,3)-G(2,3))
%     % The smaller circle is inside the big one.
%     A=pi*(min(G(1,3),G(2,3)))^2;
% else
%     xi=(G(1,3)^2-G(2,3)^2+d^2)/(2*d);
%     yi=sqrt(G(1,3)^2-xi^2);
%     A=G(1,3)^2*atan2(yi,   xi )+...
%       G(2,3)^2*atan2(yi,(d-xi))-d*yi;
% end