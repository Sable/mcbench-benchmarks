function H=circle(center,radius,NOP,style)
%---------------------------------------------------------------------------------------------
% H=CIRCLE(CENTER,RADIUS,NOP,STYLE)
% This routine draws a circle with center defined as
% a vector CENTER, radius as a scaler RADIS. NOP is 
% the number of points on the circle.
%
% Examples,
%
%   circle([1,3,1],3,1000,':'); 
%   circle([2,4,1],2,1000,'--');
%
%   Ahmed Ferozpuri <aferozpu@gmu.edu>
%   Version 1.00
%   May 25, 2006
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
Z = center(3)*ones(1,length(X));
H=plot3(X,Y,Z,style);
axis square;