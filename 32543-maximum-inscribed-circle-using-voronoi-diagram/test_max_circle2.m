
% by Tolga Birdal
% A sample application and a function for solving the maximum inscribed
% circle problem. 
% Unlike my other submission "Maximum Inscribed Circle using Distance 
% Transform", this algorithm is subpixel accurate. It operates only on the
% polygon and not the image points. Therefore, if the polygon is given in
% sub-pixels, the result will be accurate. 
% I use an O(n log(n)) algorithm as follows:
% Construct the Voronoi Diagram of the polygon.
% For Voronoi nodes which are inside the polygon:
%       Find the node with the maximum distance to edges in P. This node is
%       the centre of the maximum inscribed circle.
% 
% For more details on the problem itself please checkout my previous 
% submission as mentioned above.
% 
% To speed things up:
% Replace "inpolygon" function by Bruno Lunog's faster implementation:
% "2D polygon interior detection" :
% http://www.mathworks.com/matlabcentral/fileexchange/27840-2d-polygon-inte
% rior-detection
% Copyright (c) 2011, Tolga Birdal <http://www.tbirdal.me>

function []=test_max_circle2()
close all;
figure,

% Read the boundary segmented and the original image. Original image is
% only needed for visualization
Iorg=imread('hand.jpg');
I=imread('hand_contour.png');
imshow(Iorg);

% obtain the boundary
[y,x]=find(I>0);
contour = bwtraceboundary(logical(I), [y(1),x(1)], 'E', 8);

% get the circle
[cx,cy,r]=find_inner_circle(contour(:,2),contour(:,1));

% plot
theta = [linspace(0,2*pi) 0];
hold on, plot(x, y,'g.', 'MarkerSize',1);
hold on, plot(cos(theta)*r+cx,sin(theta)*r+cy,'r', 'LineWidth', 1);

end

% given a polygon [x,y] find the inner circle [cx,cy,r]
function [cx,cy,r]=find_inner_circle(x,y)

% make a voronoi diagram
[vx,vy]=voronoi(x,y);

% find voronoi nodes inside the polygon [x,y]
Vx=vx(:);
Vy=vy(:);
% Here, you could also use a faster version of inpolygon
IN=inpolygon(Vx,Vy, x,y);
ind=find(IN==1);
Vx=Vx(ind);
Vy=Vy(ind);

% maximize the distance of each voronoi node to the closest node on the
% polygon.
minDist=0;
minDistInd=-1;
for i=1:length(Vx)
    dx=(Vx(i)-x);
    dy=(Vy(i)-y);
    r=min(dx.*dx+dy.*dy);
    if (r>minDist)
        minDist=r;
        minDistInd=i;
    end
end

% take the center and radius
cx=Vx(minDistInd);
cy=Vy(minDistInd);
r=sqrt(minDist);

end
