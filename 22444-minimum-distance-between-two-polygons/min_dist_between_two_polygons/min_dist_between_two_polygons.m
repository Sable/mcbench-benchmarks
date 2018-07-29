function min_d = min_dist_between_two_polygons(P1,P2,Display_solution)
%
% This function computes the minimum euclidean distance between two
% polygons P1 & P2.
% 
% This function takes two arguments, a third one is optional.
% min_d = min_dist_between_two_polygons(P1,P2,Display_solution);
%   P1 & P2 contain the geometry of polygons.
%   P1 & P2 are structures containing two fields: x & y
%   For example:
% 	P1.x = rand(1,5)+2;
% 	P1.y = rand(1,5);
% 	P2.x = rand(1,3);
% 	P2.y = rand(1,3);
%   Display_solution is a binary variable that enables or not the 
%   plot of the solution.
%
% The function starts by checking if polygons are intersecting. 
% In this case, the minimum distance is 0.
% Otherwise, distances between all vertices and edges of the two
% polygons are computed. The function returns the minimum distance found.
% Further details of the implementation can be found in the code.
% 
% 2008 12 15
% Guillaume Jacquenot
% guillaume dot jacquenot at gmail dot com
%
if nargin == 0
    % rand('state',1);
    P1.x = rand(1,5)+2;
    P1.y = rand(1,5);
    P2.x = rand(1,3);
    P2.y = rand(1,3);
    Display_solution = 1;
elseif nargin == 2
    Display_solution = 0;
elseif nargin > 3
    error('min_dist_between_two_polygons:e0',...
         'Function Compute_closest_distance needs at least two arguments');
end

if ~(isstruct(P1) && isstruct(P2))
    error('min_dist_between_two_polygons:e1',...
         'P1 & P2 should be structures, containing two fields x & y');
end

Npts_P1 = numel(P1.x);
Npts_P2 = numel(P2.x);
if Npts_P1==0 || Npts_P2==0
    error('min_dist_between_two_polygons:e2',...
         'P1 & P2 should be non-empty structures');    
elseif Npts_P1==1 && Npts_P2==1
    min_d = sqrt((P1.x-P2.x)^2+(P1.y-P2.y)^2);
    return;
end
if Npts_P1~=numel(P1.y)
    error('min_dist_between_two_polygons:e3',...
         'Numbers of points of P1.x and P1.y must be equal ');
end
if Npts_P2~=numel(P2.y)
    error('min_dist_between_two_polygons:e4',...
         'Numbers of points of P2.x and P2.y must be equal ');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Checking if polygons are closed
if ~((P1.x(1) == P1.x(end)) && (P1.y(1) == P1.y(end)))
    P1.x(end+1) = P1.x(1);
    P1.y(end+1) = P1.y(1);
    Npts_P1 = Npts_P1 + 1;
end
if ~((P2.x(1) == P2.x(end)) && (P2.y(1) == P2.y(end)))
    P2.x(end+1) = P2.x(1);
    P2.y(end+1) = P2.y(1);
    Npts_P2 = Npts_P2 + 1;    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check whether or not polygons are intersecting
if Npts_P1>1 && Npts_P2>1
    % Bounding box test
    minP1x = min(P1.x);
    maxP1x = max(P1.x);
    minP1y = min(P1.y);
    maxP1y = max(P1.y);
    minP2x = min(P2.x);
    maxP2x = max(P2.x);
    minP2y = min(P2.y);
    maxP2y = max(P2.y);

    if ((minP1x < maxP2x) && (maxP1x > minP2x) && ...
            (minP1y < maxP2y) && (maxP1y > minP2y))
        % Checking if any of the segments of the 2 polygons are crossing
        % S. Hölz function    
        [x,y] = curveintersect(P1.x,P1.y,P2.x,P2.y);
        if ~isempty(x)
            min_d = 0;
            if Display_solution
                figure
                hold on
                box on
                axis equal
                plot(P1.x,P1.y,P2.x,P2.y);
                plot(x,y,'ro');   
            end            
            return;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To compute the minimum distance between two polygons, we compute the
% minimum distance between all vertices and all edges.
% To compute this distance, one needs to compute the minimum distance
% between a vertex I (xi,yi) and an edge [A B] of
% coordinates (xa,ya) and (xb,yb)
% To compute this distance, one computes the projected point of the vertex
% I on the line passing through the vertices of the edge [A B].
% The projected point P corresponds to the minimum distance between the
% vertex and the line.
% The coordiantes of point P are computed in a parametric way with the line
% created by points A and B:
% Each line is represented with a parametric representation
% x = (xb-xa)*k + xa;
% y = (yb-ya)*k + ya;
% To find the parametric coordinate of point P, we search for the minimum
% of the parabola ruling the distance between point P and line (AB).
% d = a*k^2+b*k
% a =   (xa-xb)^2+(ya-yb)^2
% b = 2((xa-xb)(xa-xi)+(ya-yb)(ya-yi));
% The minimum of a parabola occurs for k = -b/(2a);
% Three different cases are possible
%   if k < 0, the point is located before point A.
%   if k > 1, the point is located below point B.
%   if 0 <= k <= 1, the point is located on segment [A B]. 
% The minimal distance dmin between vertex I and segment [A B] depends
% on the value of k
%   if k < 0, dmin = distance(I,A);
%   if k > 1, dmin = distance(I,B);
%   if 0 <= k <= 1, dmin = distance(I,P); 
% To find the minimum distances between 2 polygons, we compute the minimum
% distance between all vertices of P1 and all edges of P2, and vice versa
%
% I have tried to minimise the number of for loop.
%%%%%%%%%%%%%%%%%%%%%%%%
% All points of polygon P2 are projected along every line created from
% every segment of P1
% A loop is used to sweep along segments of P1.
if Npts_P1 >= 3
     dP1x = diff(P1.x);
     dP1y = diff(P1.y);
    sdP12 = dP1x.^2 + dP1y.^2;
    if any(sdP12 == 0)
        warning('min_dist_between_two_polygons:w1',...
            'Two successive points of P1 are indentical.')
    end
    K1 = zeros(Npts_P1-1,Npts_P2);
    D1 = zeros(Npts_P1-1,Npts_P2);
    for i = 1:numel(P1.x)-1
        % Compute the closest distance between a point and a segment
        % Computation of the parameter k
        k = -(dP1x(i) * (P1.x(i) - P2.x) +...
              dP1y(i) * (P1.y(i) - P2.y)) / sdP12(i);
        I1 = k < 0;    
        I2 = k > 1;
        I  =~(I1|I2);
        % Computation of the minimum squared distances between all points of 
        % P2 and the i-th segment of P1.
        D1(i,I1) = (P2.x(I1)- P1.x(i  )).^2+(P2.y(I1)-P1.y(i  )).^2;
        D1(i,I2) = (P2.x(I2)- P1.x(i+1)).^2+(P2.y(I2)-P1.y(i+1)).^2;
        D1(i,I ) = (P2.x(I )-(P1.x(i)+k(I)*dP1x(i))).^2+...
                       (P2.y(I )-(P1.y(i)+k(I)*dP1y(i))).^2;
        K1(i,:) = k;
    end
    % One computes the minimum distance for polygon 1
    [min_d1,ind_seg1] = min(D1);
    [min_D1,ind_pt1 ] = min(min_d1);
end

%%%%%%%%%%%%%%%%%%%%%%%%
% The same operations are performed for all segments of P2.
if Npts_P2 >= 3
     dP2x = diff(P2.x);
     dP2y = diff(P2.y);
    sdP22 = dP2x.^2 + dP2y.^2;
    if any(sdP22 == 0)
        warning('min_dist_between_two_polygons:w2',...
            'Two successive points of P1 are indentical.')
    end
    K2 = zeros(Npts_P2-1,Npts_P1);
    D2 = zeros(Npts_P2-1,Npts_P1);
    for i = 1:Npts_P2-1
        k = -(dP2x(i) * (P2.x(i) - P1.x) + ...
              dP2y(i) * (P2.y(i) - P1.y))/sdP22(i);
        I1 = k < 0;
        I2 = k > 1;
        I  =~(I1|I2);
        D2(i,I1) = (P1.x(I1)-P2.x(i  )).^2+(P1.y(I1)-P2.y(i  )).^2;
        D2(i,I2) = (P1.x(I2)-P2.x(i+1)).^2+(P1.y(I2)-P2.y(i+1)).^2;
        D2(i,I ) = (P1.x(I )-(P2.x(i)+k(I)*dP2x(i))).^2+...
                        (P1.y(I )-(P2.y(i)+k(I)*dP2y(i))).^2;
        K2(i,:) = k;
    end
    [min_d2,ind_seg2] = min(D2);
    [min_D2,ind_pt2 ] = min(min_d2);
end

if (Npts_P1 >= 3) && (Npts_P2 >= 3)
    [min_d,ind_tot] = min([min_D1,min_D2]);
    min_d = sqrt(min_d);
elseif Npts_P1 < 3
    ind_tot = 2;
    min_d = sqrt(min_D2);    
elseif Npts_P2 < 3
    ind_tot = 1;
    min_d = sqrt(min_D1);    
end

if Display_solution
    if ind_tot == 1
        k = K1(ind_seg1(ind_pt1),ind_pt1);
        if k > 1
            p1x= P1.x(ind_seg1(ind_pt1)+1);
            p1y= P1.y(ind_seg1(ind_pt1)+1);
        elseif k < 0
            p1x= P1.x(ind_seg1(ind_pt1));
            p1y= P1.y(ind_seg1(ind_pt1));
        else
            p1x = P1.x(ind_seg1(ind_pt1))+k*dP1x(ind_seg1(ind_pt1));
            p1y = P1.y(ind_seg1(ind_pt1))+k*dP1y(ind_seg1(ind_pt1));
        end
        p2x = P2.x(ind_pt1);
        p2y = P2.y(ind_pt1);
    else
        k = K2(ind_seg2(ind_pt2),ind_pt2);
        if k > 1
            p2x= P2.x(ind_seg2(ind_pt2)+1);
            p2y= P2.y(ind_seg2(ind_pt2)+1);
        elseif k < 0
            p2x= P2.x(ind_seg2(ind_pt2));
            p2y= P2.y(ind_seg2(ind_pt2));
        else
            p2x = P2.x(ind_seg2(ind_pt2))+k*dP2x(ind_seg2(ind_pt2));
            p2y = P2.y(ind_seg2(ind_pt2))+k*dP2y(ind_seg2(ind_pt2));
        end
        p1x = P1.x(ind_pt2);
        p1y = P1.y(ind_pt2);  
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    figure
    hold on
    box on
    axis equal
    plot(P1.x,P1.y,P2.x,P2.y);
    plot([p1x p2x],[p1y p2y],'ro-');
    title('Computation of the minimum distance between two polygons P1 and P2')
    hleg = legend('P1','P2','min_dist(P1,P2)');
    set(hleg,'Interpreter','none');
end