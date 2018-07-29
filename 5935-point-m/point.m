% Richard Rieber
% December 23, 2006
% rrieber@gmail.com
%
% function point(x,y,z,fig)
% 
% Purpose: This will plot a circle at point (x(i,j),y(i,j)) with diameter
%          proportional to z(i,j) and scaled based on the magnitude of
%          values in z.
%
% Inputs: o x   - Matrix of size ixj corresponding to the x-coordinates
%         o y   - Matrix of size ixj corresponding to the y-coordinates
%         o z   - Matrix of size ixj corresponding to the value at the
%                 coordinates [x(i,j),y(i,j)]
%         o fig - Figure number where this should be plotted [OPTIONAL]
%
% Outputs o NONE
%

function point(x,y,z,fig)

if nargin < 3 || nargin > 4
    error('Incorrect number of inputs.  See help point.m')
elseif nargin == 3
    figure
elseif nargin == 4
    figure(fig)
end

d = size(z);

maxz = 0;
minz = 0;

for i = 1:d(2)
    tempx = max(z(:,i));
    tempy = min(z(:,i));
    if tempx > maxz
        maxz = tempx;
    end
    if tempy < minz
        minz = tempy;
    end
end

range = (maxz - minz)*2;

hold on

for i = 1:d(1)
    for j = 1:d(2)
        if z(i,j) < 0
            circle([x(i,j),y(i,j)],z(i,j)/range/2,25,'r');
        else
            circle([x(i,j),y(i,j)],z(i,j)/range/2,25,'b');
        end
    end
end


function H=circle(center,radius,NOP,style)
%---------------------------------------------------------------------------------------------
% H=CIRCLE(CENTER,RADIUS,NOP,STYLE)
% This routine draws a circle with center defined as
% a vector CENTER, radius as a scaler RADIS. NOP is 
% the number of points on the circle. As to STYLE,
% use it the same way as you use the rountine PLOT.
% Since the handle of the object is returned, you
% use routine SET to get the best result.
%
%   Usage Examples,
%
%   circle([1,3],3,1000,':'); 
%   circle([2,4],2,1000,'--');
%
%   Zhenhai Wang <zhenhai@ieee.org>
%   Version 1.00
%   December, 2002
%---------------------------------------------------------------------------------------------

if (nargin <3),
 error('Please see help for INPUT DATA.');
elseif (nargin==3)
    style='b-';
end;
THETA=linspace(0,2*pi,NOP);
RHO=ones(1,NOP)*radius;
[X,Y] = pol2cart(THETA,RHO);
X=X+center(1);
Y=Y+center(2);
H=plot(X,Y,style);
axis square;