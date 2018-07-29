function S = apollonian_2D_4(n,display_inversion_circle)
% Computers graphics
% apollonian 2D
% In mathematics, an Apollonian gasket or Apollonian net is a fractal generated from three circles, any two of which are tangent to one another
% The method used to create the Apollonian gasket is based on circle inversion, which is a geometrical transformation acting with a reference circle that modifies points.
% In the plane, the inverse of a point P in respect to a circle of center O and radius R is a point P' such that P and P' are on the same ray going from O, and OP times OP' equals the radius squared
% OP * OP' =R²
%
% Here 4 inversion circles are used to create the Apollonian gasket.
% The 4 inversion circles have the following characterics
%	Inversion circle 1: x1 =  -1	y1 =  1	r1 = 1
%	Inversion circle 1: x2 = -1	y1 = -1	r2 = 1
%	Inversion circle 1: x3 =  1	y1 = -1	r3 = 1
%	Inversion circle 1: x4 =  1  	y1 =  1	r4 = 1
% Input: This function takes one argument or two arguments
%		- a positive integer, which corresponds to the number of levels of the apollonian. Higher the number of level is, more numerous the circles will be. 10 levels is a quite high value.
%		- an interger (0 or 1), which allows to display(1) or not(0) the inversion circles
%
% Output: a struture that contains all informations on created circles on each level

% Guillaume JACQUENOT
% guillaume.jacquenot@gmail.com
% 2007_08_17


% Checking input
if nargin==0
	n					     = 4;
	display_inversion_circle = 0;
elseif nargin==1
	display_inversion_circle = 0;
	n = ceil(n);
	if n < 0;n = ceil(abs(n));end
	if n ==0;n = 4; end
elseif nargin==2	
	n = ceil(n);
	if n < 0;n = ceil(abs(n));end
	if n ==0;n = 4; end
end

% 
h = figure;
hAxs = axes('Parent',h);
axis equal;
axis([-1,1,-1,1])
grid on;
hold on;
axis off;

% Number of points used to plot circles
nb_points = 300;

if display_inversion_circle
	% Plot inversion circles
	plot(-1+cos(-pi/2:pi/(2*nb_points):     0), 1+sin(-pi/2:pi/(2*nb_points):     0),'k--','Parent',hAxs);
	plot(-1+cos(    0:pi/(2*nb_points):  pi/2),-1+sin(    0:pi/(2*nb_points):  pi/2),'k--','Parent',hAxs);
	plot( 1+cos( pi/2:pi/(2*nb_points):    pi),-1+sin( pi/2:pi/(2*nb_points):    pi),'k--','Parent',hAxs);
	plot( 1+cos(   pi:pi/(2*nb_points):3*pi/2), 1+sin(   pi:pi/(2*nb_points):3*pi/2),'k--','Parent',hAxs);
	plot((sqrt(2)-1)*cos(0:2*pi/nb_points:2*pi),(sqrt(2)-1)*sin(0:2*pi/nb_points:2*pi),'k--','Parent',hAxs);
end


% Create intial structure that will store all created circles
S(1).x = [0,0,0.0,-2+sqrt(2),0.0,2-sqrt(2)];
S(1).y = [0,0,2-sqrt(2),0.0,-2+sqrt(2),0.0];
S(1).r = [1,1-2*(sqrt(2)-1),(sqrt(2)-1)*ones(1,4)];

% Display initial circles
hAxs = plot_circles(hAxs,S,1,nb_points);

% Start the creation of the circles for each level.
for i = 1:n-1
	% Initiate the structure
    S(i+1).x = [];
    S(i+1).y = [];
    S(i+1).r = [];
	
    for j=1:size(S(i).x,2) 	% For all circles contain on the i-th level
		% Compute the distance between a circle center and the centers of the inversion circles
        d1 = sqrt((-1-S(i).x(j)).^2+( 1-S(i).y(j)).^2);
        d2 = sqrt((-1-S(i).x(j)).^2+(-1-S(i).y(j)).^2);
        d3 = sqrt(( 1-S(i).x(j)).^2+(-1-S(i).y(j)).^2);
        d4 = sqrt(( 1-S(i).x(j)).^2+( 1-S(i).y(j)).^2);
        d5 = sqrt((   S(i).x(j)).^2+(   S(i).y(j)).^2);
		
        if d1 > 1 %		If the center of the circle is outside the inversion circle 1
            [x1,y1,r1] = inversion_circle(S(i).x(j),S(i).y(j),S(i).r(j),-1, 1,1);
			% Test to check if the new center doesn't belong to its original circle 
            if sqrt((x1-S(i).x(j))^2+(y1-S(i).y(j))^2)>S(i).r(j)
                S(i+1).x  = [S(i+1).x,x1];
                S(i+1).y  = [S(i+1).y,y1];
                S(i+1).r  = [S(i+1).r,r1];
            end
        end
        if d2 > 1 %		If the center of the circle is outside the inversion circle 2 
            [x2,y2,r2] = inversion_circle(S(i).x(j),S(i).y(j),S(i).r(j),-1,-1,1);
			% Test to check if the new center doesn't belong to its original circle 
            if sqrt((x2-S(i).x(j))^2+(y2-S(i).y(j))^2)>S(i).r(j)
                S(i+1).x  = [S(i+1).x,x2];
                S(i+1).y  = [S(i+1).y,y2];
                S(i+1).r  = [S(i+1).r,r2];
            end
        end
        if d3 > 1 %		If the center of the circle is outside the inversion circle 3
            [x3,y3,r3] = inversion_circle(S(i).x(j),S(i).y(j),S(i).r(j), 1,-1,1);   
			% Test to check if the new center doesn't belong to its original circle 			
            if sqrt((x3-S(i).x(j))^2+(y3-S(i).y(j))^2)>S(i).r(j)
                S(i+1).x  = [S(i+1).x,x3];
                S(i+1).y  = [S(i+1).y,y3];
                S(i+1).r  = [S(i+1).r,r3];
            end
        end
        if d4 > 1 %		If the center of the circle is outside the inversion circle 4
            [x4,y4,r4] = inversion_circle(S(i).x(j),S(i).y(j),S(i).r(j), 1, 1,1);
            % Test to check if the new center doesn't belong to its original circle 
			if sqrt((x4-S(i).x(j))^2+(y4-S(i).y(j))^2)>S(i).r(j)
                S(i+1).x  = [S(i+1).x,x4];
                S(i+1).y  = [S(i+1).y,y4];
                S(i+1).r  = [S(i+1).r,r4];
            end
        end
        if d5 > (sqrt(2)-1)
            [x5,y5,r5] = inversion_circle(S(i).x(j),S(i).y(j),S(i).r(j), 0, 0,sqrt(2)-1);
			% Test to check if the new center doesn't belong to its original circle 
            if sqrt((x5-S(i).x(j))^2+(y5-S(i).y(j))^2)>S(i).r(j)
                S(i+1).x  = [S(i+1).x,x5];
                S(i+1).y  = [S(i+1).y,y5];
                S(i+1).r  = [S(i+1).r,r5];
            end
        end        
    end
	% All new circles are ploted
    hAxs = plot_circles(hAxs,S,i+1,nb_points);
end


function hAxs = plot_circles(hAxs,S,n,nb_points)
% This function display all circles of the n-th level of the structure S.
% Input: -  hAxs 		: axes handle
% 	     - S       		: structure containing the apollonian circles
%	     - n       		: level of the struture to be plot
%	     - nb_points	: number of points used to plot circles
%
% Guillaume JACQUENOT
hold on
for t=1:size(S(n).x,2)
	plot(S(n).x(t)+S(n).r(t)*cos(0:2*pi/nb_points:2*pi),...
		 S(n).y(t)+S(n).r(t)*sin(0:2*pi/nb_points:2*pi),'k-',...
		 'tag',num2str(n),'Parent',hAxs);
%      plot(S(n).x(t),S(n).y(t),'k+','tag',num2str(n));
end

function [xc,yc,Rc] = inversion_circle(x,y,R,x0,y0,R0)
% This function performs the inversion of a circle of center P(x,y)  and radius R in respect to a circle of center  O (xO,yO) and radius R0.
% This function calls another function: inversion, which performs the inversion of a point
%
% Input arguments: 	x  ,y  ,R	cordinates of the center and radius of the circle to be inversed
%				x0,y0,R0	cordinates of the center O and the radius R0
%
% Guillaume JACQUENOT
d  = sqrt((x-x0).^2+(y-y0).^2);
dn = (R0.^2)./d;

theta = atan2((y-y0),(x-x0));

[x1,y1] = inversion(x+R*cos(theta),y+R*sin(theta),x0,y0,R0);
[x2,y2] = inversion(x-R*cos(theta),y-R*sin(theta),x0,y0,R0);

xc = (x1+x2)/2;
yc = (y1+y2)/2; 
Rc = sqrt((x1-x2)^2+(y1-y2)^2)/2;


function [xn,yn] = inversion(x,y,x0,y0,R0)
% This function performs the inversion of point P(x,y) in respect to a circle of center  O (xO,yO) and radius R0
% In the plane, the inverse of a point P in respect to a circle of center O and radius R is a point P' such that P and P' are on the same ray going from O, and OP times OP' equals the radius squared
% OP * OP' =R²
% The circle in respect to which inversion is performed will be called the reference circle.
% 
% Input arguments: 	x  ,y		cordinates of the point to be inversed
%				x0,y0,R0	cordinates of the center O and the radius R0
%
% Guillaume JACQUENOT
d  = sqrt((x-x0).^2+(y-y0).^2);
dn = (R0.^2)./d;

theta = atan2((y-y0),(x-x0));
xn = x0 + dn.*cos(theta);
yn = y0 + dn.*sin(theta);
