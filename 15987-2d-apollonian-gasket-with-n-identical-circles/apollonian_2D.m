function S = apollonian_2D(n,level,display_inversion_circle,...
                                create_mpost,create_svg,filename_export)
% This function creates and displays 2D Apollonian gaskets.
%
% In mathematics, an Apollonian gasket or Apollonian net is a fractal 
% generated from three circles, any two of which are tangent to one another
% 
% The method used to create the Apollonian gasket is based on circle
% inversion, which is a geometrical transformation acting with a reference 
% circle that modifies points.
% In the plane, the inverse of a point P in respect to a circle of center O
% and radius R is a point P' such that P and P' are on the same ray going 
% from O, and OP times OP' equals the radius squared
% OP * OP' =R²
%
% All circles are created using the inversion properties of circles.
%
% Input: This function takes 6 arguments (each argument is optional)
%		- a positive integer, which corresponds to the number of circles on
%           the first level of the apollonian packing. (3 at least)
%		- a positive integer, which corresponds to the number of levels 
%           of the apollonian.
%           Higher the number of level is, more numerous the circles will 
%           be. 10 levels is a quite high value.
%		- an interger (0 or 1), which allows to display(1) or not(0) 
%           the inversion circles
%       - an integer (0 or 1), which indicates whether or not a metapost
%           file is created within the results.
%       - an integer (0 or 1), which indicates whether or not a SVG
%           file is created within the results.
%       - a string which indicates the filename in which results
%           will be printed.
% Output: a struture that contains all informations on created circles on 
%         each level:
%           S(1) contains all data on level 1, coordinates centers and
%           radius of each circle
%           
% Guillaume JACQUENOT
% guillaume dot jacquenot at gmail dot com
% 2007_08_19
% 2008_01_13     : Metapost export script added
% 2009_01_31     : SVG export script added

% Checking input
if nargin==0
    n                        = 5;
	level		     	     = 4;
	display_inversion_circle = 0;
    create_mpost = 0;
    create_svg   = 0;    
elseif nargin==1
    level                    = 5;
    display_inversion_circle = 0;
    create_mpost             = 0;
    create_svg               = 0;
elseif nargin >= 2
    display_inversion_circle = 0;
    create_mpost             = 0;
    create_svg               = 0;    
elseif nargin >= 3
    if nargin == 3
        create_mpost         = 0;
        create_svg           = 0;
    elseif nargin == 4
        create_svg           = 0;
    end
    if nargin == 4 || nargin == 5
        filename_export = 'apollonian';
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n = ceil(n);
if n < 0;n = ceil(abs(n));end
if n < 3;n = 3; end

level = ceil(level);
if level  < 0;level = ceil(abs(level));end
if level == 0;level = 5; end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Creating the resulting figure
h = figure;
hAxs = axes('Parent',h);
axis equal;
axis([-1,1,-1,1])
grid on;
hold on;
axis off;

% Creating the initial circles depending on user parameter
V  = 0:2*pi/n:2*pi;
V  = V +pi/2;
cV = cos(V);
sV = sin(V);

d = sqrt(diff(cV).^2+diff(sin(V)).^2);
r = d(1)/2;

% Data are made dimensionless so that the plot dimensions are known
ratio = max(max(max(abs(cV+r)),max(abs(sV+r))),...
            max(max(abs(cV-r)),max(abs(sV-r))));

cV = cV/ratio;
sV = sV/ratio;
r  =  r/ratio;
r_inner1 = sqrt(cV(1).^2+sV(1).^2) - r;

% Create intial structure that will store all created circles
S(1).x = [0,0,cV(1:end-1)];
S(1).y = [0,0,sV(1:end-1)];
S(1).r = [1,r_inner1,r*ones(1,n)];

% Display initial circles
hAxs = plot_circles(hAxs,S,1);

% Creating inversion circles.
x_mid = zeros(1,n);
y_mid = zeros(1,n);
for t = 1:n
	x_mid(t) = (cV(t)+cV(t+1))/2;
	y_mid(t) = (sV(t)+sV(t+1))/2;
    a1 = atan2(sV(t),cV(t));
    a2 = atan2(sV(t+1),cV(t+1));
    x1 = cV(t)  +cos(a1)*r;
    y1 = sV(t)  +sin(a1)*r;
    x2 = cV(t+1)+cos(a2)*r;
    y2 = sV(t+1)+sin(a2)*r;
	[xc,yc,rc] = circles_from_3pts(x1,y1,x2,y2,x_mid(t),y_mid(t));
	S_circle.x(t)=xc;
	S_circle.y(t)=yc;
	S_circle.r(t)=rc;
end
S_circle.x(n+1)=0;
S_circle.y(n+1)=0;
S_circle.r(n+1)=sqrt(x_mid(1).^2+y_mid(1).^2);

if display_inversion_circle
     hAxs = plot_circles(hAxs,S_circle,1,'k--');
end

% Start the creation of the circles for each level.
for i = 1:level-1           % For all level
	% Initiate the structure
    S(i+1).x = [];
    S(i+1).y = [];
    S(i+1).r = [];
    for j=1:size(S(i).x,2) 	% For all circles contain on the i-th level
        for k = 1:n+1       % For all inversion circles
            d = sqrt((S_circle.x(k)-S(i).x(j)).^2+...
                     (S_circle.y(k)-S(i).y(j)).^2);
            if d > S_circle.r(k)
                [xi,yi,ri] = inversion_circle(S(i).x(j),S(i).y(j),...
                                            S(i).r(j),...
                                            S_circle.x(k),S_circle.y(k),...
                                            S_circle.r(k));
                if sqrt((xi-S(i).x(j))^2+(yi-S(i).y(j))^2)>S(i).r(j)
                    S(i+1).x  = [S(i+1).x,xi];
                    S(i+1).y  = [S(i+1).y,yi];
                    S(i+1).r  = [S(i+1).r,ri];
                end          
            end
        end
    end
	% All new circles are ploted
    hAxs = plot_circles(hAxs,S,i+1);    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if create_mpost
    Create_result_in_metapost(S,filename_export);
end
if create_svg
    Create_result_in_svg(S,filename_export);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hAxs = plot_circles(hAxs,S,n,display_style)
% This function display all circles of the n-th level of the structure S.
% Input: -  hAxs 		 : axes handle
% 	     - S       		 : structure containing the apollonian circles
%	     - n       		 : level of the struture to be plot
%        - display_style : options for the plot command
%
if nargin==3
    display_style = 'k-';
end
hold on
for t=1:size(S(n).x,2)
	rectangle('Position',[S(n).x(t)-S(n).r(t),...
		 S(n).y(t)-S(n).r(t),2*S(n).r(t),2*S(n).r(t)],...
         'Curvature',[1,1],'LineWidth',0.5,...
		 'tag',num2str(n),'Parent',hAxs);         
%      plot(S(n).x(t),S(n).y(t),'k+','tag',num2str(n));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xc,yc,Rc] = inversion_circle(x,y,R,x0,y0,R0)
% This function performs the inversion of a circle of center P(x,y) and
% radius R in respect to a circle of center  O (xO,yO) and radius R0.
% This function calls another function: inversion, which performs the
% inversion of a point
%
% Input arguments: 	x  ,y  ,R coordinates of the center and radius of
%                             the circle to be inversed
%    				x0,y0,R0  coordinates of the center O and the radius R0
%
% Guillaume JACQUENOT
theta = atan2((y-y0),(x-x0));

[x1,y1] = inversion(x+R*cos(theta),y+R*sin(theta),x0,y0,R0);
[x2,y2] = inversion(x-R*cos(theta),y-R*sin(theta),x0,y0,R0);

xc = (x1+x2)/2;
yc = (y1+y2)/2; 
Rc = sqrt((x1-x2)^2+(y1-y2)^2)/2;


function [xn,yn] = inversion(x,y,x0,y0,R0)
% This function performs the inversion of point P(x,y) in respect to a 
% circle of center  O (xO,yO) and radius R0
% In the plane, the inverse of a point P in respect to a circle of center O
% and radius R is a point P' such that P and P' are on the same ray going 
% from O, and OP times OP' equals the radius squared
% OP * OP' =R²
% The circle in respect to which inversion is performed will be called the
% reference circle.
% 
% Input arguments: 	x  ,y		coordinates of the point to be inversed
%				x0,y0,R0	coordinates of the center O and the radius R0
%
% Guillaume JACQUENOT
d  = sqrt((x-x0).^2+(y-y0).^2);
dn = (R0.^2)./d;

theta = atan2((y-y0),(x-x0));
xn = x0 + dn.*cos(theta);
yn = y0 + dn.*sin(theta);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
function [x,y,r] = circles_from_3pts(x1,y1,x2,y2,x3,y3)
% This function gives the coordinates of the circle passing through 3 
% points given in input.
%
% Input   : - x1,y1 coordinates of point 1
%           - x2,y2 coordinates of point 2
%           - x3,y3 coordinates of point 3
%
% Output :  - x ,y  coordinates of the center of the circle
%           - r  radius of the circle passing through the 3 input points
% 2007_08_19
% Guillaume JACQUENOT

if nargin==0
    x1 = 0;
    y1 = 0;
    
    x2 = 1;
    y2 = 0;

    x3 = 0;
    y3 = 1;    
end



% Checking arguments
% One checks if 2 or 3 points are identical
if (((x1==x2) && (y1==y2)) || ((x1==x3) && (y1==y3)))
    error('2 or 3 points are identical')
end

% One checks if points are not colinear
if atan2((y2-y1),(x2-x1))==atan2((y3-y1),(x3-x1))
    hold on
    plot(x1,y1,'b+',x2,y2,'b+',x3,y3,'b+');
    error('The three points are aligned, infinite radius...')
end

% Center coordinates are obtained solving a linear system.
M = [(x1-x2) (y1-y2);(x1-x3) (y1-y3)];
V = 1/2*[x1^2+y1^2-x2^2-y2^2;x1^2+y1^2-x3^2-y3^2];

Res = M\V;
x   = Res(1);
y   = Res(2);

r = sqrt((x1-x).^2+(y1-y).^2);

if nargin==0
    figure, box on, axis equal, hold on
    plot(x1,y1,'b+',x2,y2,'b+',x3,y3,'b+');
    plot(x,y,'r+',x+r*cos(0:2*pi/300:2*pi),y+r*sin(0:2*pi/300:2*pi),'r');
   
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Create_result_in_metapost(S,filename)
% Script used to create a metapost script.
% This script can then be executed using mpost 
%
% mpost filename
%
% You can include the result in a LaTeX document
% Here is a document example to  include the mpost document

% \documentclass{article}
% 
% \usepackage{graphicx}
% 
% \begin{document}
%   \begin{figure}
%     \includegraphics{figure.1}
%   \end{figure}
% \end{document}

if nargin==1
    filename = 'Apollonius.mp';
elseif nargin == 2
    filename = [filename '.mp'];
end

delta = 3;

fid = fopen(filename,'w');
fprintf(fid,'beginfig(1);');
fprintf(fid,'u =    1 cm;');
for i=1:numel(S)
    for j=1:numel(S(i).x)
        fprintf(fid,'draw fullcircle\n');
        fprintf(fid,'xscaled   %10.8fu\n',2*delta*S(i).r(j));
        fprintf(fid,'yscaled   %10.8fu\n',2*delta*S(i).r(j));
        fprintf(fid,'shifted (  %10.8fu,   %10.8fu);\n',...
            delta*(S(i).x(j))+10,delta*(S(i).y(j))+10);
        fprintf(fid,'\n');
    end
end
fprintf(fid,'endfig;');
fprintf(fid,'end;');
fclose(fid);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Create_result_in_svg(S,filename)
% Script used to create a SVG script.
if nargin==1
    filename ='Apollonius.svg';
elseif nargin == 2
    filename = [filename '.svg'];    
end

fid = fopen(filename,'w');
fprintf(fid,'<?xml version="1.0" standalone="no"?>\n');
fprintf(fid,'<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN"\n');
fprintf(fid,'"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n');
fprintf(fid,'<svg width="620" height="620" version="1.1"\n');
fprintf(fid,'xmlns="http://www.w3.org/2000/svg">\n');
for i=1:numel(S)
    for j=1:numel(S(i).x)
        fprintf(fid,'<circle cx="%10.8f" cy="%10.8f" r="%10.8f" ',...
                300*S(i).x(j)+310,300*S(i).y(j)+310,300*S(i).r(j));
        fprintf(fid,'stroke="black" stroke-width="1" fill="none"/>\n');            
    end
end
fprintf(fid,'</svg>\n');
fclose(fid);
