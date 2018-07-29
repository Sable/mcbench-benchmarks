function [u, v] = scPOI(r, x)
%scPOI: calculates the point of intersection of the circles defining r and x
%
%  SYNOPSIS:
%     Calculates the point of intersection of the circle describing r and the 
%     arc or line describing the x value in cartesian coordinates. The function
%     uses the standard matlab map-toolbox functions circcirc and linecirc if this
%     toolbox is present. Otherwise it defines its own functions to determine the
%     point(s) of intersection of two circles or a circle and a line.
%
%     THIS function is called internally from the function scDraw.
%
%     see also
%
%  SYNTAX:
%     [u, v] = scPOI(r, x)
%
%  INPUT ARGUMENTS:
%     r : normalized value of the resistance 
%     x : normalized value of the reactance
%
%  OUTPUT ARGUMENT:
%     u : x-coordinate of the point of intersection
%     v : y-coordinate of the point of intersection
%  EXAMPLE:
%         [u1, v1] = scPOI(2,3);
%         u1 =
%             0.6667
%         v1 =
%             0.3333
%     calculates the coordinates of the point of intersection of the
%     circles defining the impedances 2*Z_L and j*3*Z_L. A user may not
%     need this functionality, though.
%    
%     Mohammad Ashfaq - (31-05-2000)
%     Mohammad Ashfaq - (13-04-2006) Modified (included examples)

if x~=0,
    %IF THE MATLAB MAP TOOLBOX FUNCTION circcirc EXISTS, USE THAT
    if exist('circcirc','file')
        [u,v] = circ2(r/(1+r),0,abs(1/(1+r)),1,1/x,abs(1/x));
        %OTHERWISE USE THIS FUNCTION circ2
    else
        [u,v] = circ2(r/(1+r),0,abs(1/(1+r)),1,1/x,abs(1/x));
    end
else
    %IF THE MATLAB MAP TOOLBOX FUNCTION linecirc EXISTS, USE THAT
    if exist('linecirc','file')
        [u,v] = linecirc(0,0,r/(1+r),0,abs(1/(1+r)));
        %OTHERWISE USE THIS FUNCTION lincirc
    else
        [u,v] = lincirc(0,0,r/(1+r),0,abs(1/(1+r)));
    end
end,

u = min(u);
if isempty(u)
    u=1;
end
v=max(v);

if isempty(v)
    v=0;
end


function [x, y] = circ2(c1x, c1y, r1, c2x, c2y, r2)
%CIRC2: FINDS THE POINT OF INTERSECTION OF TWO CIRCLES

A = (-8*c2x*c1x-8*c1y*c2y+4*c1y^2+4*c2y^2+4*c1x^2+4*c2x^2);
B = (12*c2x^2*c1x^2*r2^2+12*c2x^2*c1x^2*r1^2+2*c1x^4*r1^2+2*c1x^4*r2^2-c1x^2*r1^4-...
    c1x^2*r2^4+2*c2x^4*r2^2-c2x^2*r1^4-c2x^2*r2^4+2*c1y^2*r2^2*c1x^2+...
    4*c1x^4*c2y*c1y+2*c1x^2*c2y^2*r2^2+8*c1x^3*c2y^2*c2x+2*c1y^2*r1^2*c1x^2+...
    12*c1y^2*c2y^2*c2x*c1x-8*c1y*c2y^3*c2x*c1x-4*r1^2*c2y*c1y*c2x^2-...
    4*r1^2*c2y*c1x^2*c1y-4*r1^2*c2y^2*c2x*c1x-8*c1y^3*c2x*c1x*c2y-...
    4*c2x^2*c2y*c1y*r2^2+24*c2x^2*c2y*c1x^2*c1y-16*c2x^3*c2y*c1x*c1y-...
    4*c1y*r2^2*c1x^2*c2y-4*c1y^2*r2^2*c2x*c1x-16*c1x^3*c2y*c2x*c1y-...
    4*c1y^2*r1^2*c2x*c1x+4*c1y*c2y^3*c2x^2-6*c1y^2*c2y^2*c2x^2+4*c1y*c2y^3*c1x^2-...
    6*c1y^2*c2y^2*c1x^2+2*c2x^2*r1^2*r2^2+2*c2x^4*r1^2+2*c1x^2*r1^2*r2^2-...
    4*c2x*c1x*r1^2*r2^2-4*c2y^2*r2^2*c2x*c1x-c1x^2*c2y^4-2*c1x^4*c1y^2+...
    20*c2x^3*c1x^3-15*c2x^2*c1x^4-15*c2x^4*c1x^2+6*c2x*c1x^5+6*c2x^5*c1x+...
    8*c1y*r2^2*c2x*c1x*c2y+8*c1x^3*c1y^2*c2x+2*c2x*c1x*c2y^4-8*c2x*c1x^3*r1^2-...
    8*c2x*c1x^3*r2^2-8*c2x^3*c1x*r1^2-8*c2x^3*c1x*r2^2+2*c2x*c1x*r1^4+...
    2*c2x*c1x*r2^4+2*r1^2*c2y^2*c2x^2+2*r1^2*c2y^2*c1x^2+8*r1^2*c2y*c2x*c1x*c1y+...
    4*c1y^3*c2x^2*c2y+4*c1y^3*c1x^2*c2y-c1y^4*c2x^2+2*c1y^4*c2x*c1x+...
    4*c2x^4*c2y*c1y-12*c2x^2*c2y^2*c1x^2+2*c2x^2*c2y^2*r2^2+8*c2x^3*c2y^2*c1x+...
    2*c1y^2*c2x^2*r2^2+2*c1y^2*c2x^2*r1^2-12*c1y^2*c2x^2*c1x^2+8*c1y^2*c2x^3*c1x-...
    c1x^6-c2x^6-c1y^4*c1x^2-2*c2x^4*c2y^2-c2x^2*c2y^4-2*c1y^2*c2x^4-2*c1x^4*c2y^2)^(1/2);

x = [ 1/2*(-1/A*(-4*c1y*c2y^2+4*r1^2*c2y+4*c1y^3+4*c2x^2*c2y+4*c1y*c2x^2+4*c1y*r2^2+...
        4*c1x^2*c2y-4*c1y*r1^2+4*c1x^2*c1y-4*c2y*r2^2-4*c1y^2*c2y-8*c2x*c1x*c1y-...
        8*c2x*c1x*c2y+4*c2y^3+4*B)*c1y+1/A*(-4*c1y*c2y^2+4*r1^2*c2y+4*c1y^3+...
        4*c2x^2*c2y+4*c1y*c2x^2+4*c1y*r2^2+4*c1x^2*c2y-4*c1y*r1^2+4*c1x^2*c1y-...
        4*c2y*r2^2-4*c1y^2*c2y-8*c2x*c1x*c1y-8*c2x*c1x*c2y+4*c2y^3+4*B)*c2y+c1x^2+...
        c1y^2-r1^2-c2x^2-c2y^2+r2^2)/(c1x-c2x),...
        1/2*(-1/A*(-4*c1y*c2y^2+4*r1^2*c2y+4*c1y^3+4*c2x^2*c2y+4*c1y*c2x^2+4*c1y*r2^2+...
        4*c1x^2*c2y-4*c1y*r1^2+4*c1x^2*c1y-4*c2y*r2^2-4*c1y^2*c2y-8*c2x*c1x*c1y-...
        8*c2x*c1x*c2y+4*c2y^3-4*B)*c1y+1/A*(-4*c1y*c2y^2+4*r1^2*c2y+4*c1y^3+...
        4*c2x^2*c2y+4*c1y*c2x^2+4*c1y*r2^2+4*c1x^2*c2y-4*c1y*r1^2+4*c1x^2*c1y-...
        4*c2y*r2^2-4*c1y^2*c2y-8*c2x*c1x*c1y-8*c2x*c1x*c2y+4*c2y^3-4*B)*c2y+c1x^2+...
        c1y^2-r1^2-c2x^2-c2y^2+r2^2)/(c1x-c2x)];

y = [ 1/2/A*(-4*c1y*c2y^2+4*r1^2*c2y+4*c1y^3+4*c2x^2*c2y+4*c1y*c2x^2+4*c1y*r2^2+...
        4*c1x^2*c2y-4*c1y*r1^2+4*c1x^2*c1y-4*c2y*r2^2-4*c1y^2*c2y-8*c2x*c1x*c1y-...
        8*c2x*c1x*c2y+4*c2y^3+4*B),...
        1/2/A*(-4*c1y*c2y^2+4*r1^2*c2y+4*c1y^3+4*c2x^2*c2y+4*c1y*c2x^2+4*c1y*r2^2+...
        4*c1x^2*c2y-4*c1y*r1^2+4*c1x^2*c1y-4*c2y*r2^2-4*c1y^2*c2y-8*c2x*c1x*c1y-...
        8*c2x*c1x*c2y+4*c2y^3-4*B)];



function [x, y] = lincirc(m, c, c1x, c1y, r1)
%LINCIRC: FINDS THE POINT OF INTERSECTION OF A CIRCLE AND A STRAIGHT LINE

int1 =2*(-2*m*c*c1x+2*c1y*m*c1x-c1y^2-c^2+2*c1y*c+r1^2-m^2*c1x^2+m^2*r1^2)^(1/2);
x=[ 1/2/(1+m^2)*(-2*m*c+2*c1y*m+2*c1x+int1),     1/2/(1+m^2)*(-2*m*c+2*c1y*m+2*c1x-int1)];
y=[ 1/2*m/(1+m^2)*(-2*m*c+2*c1y*m+2*c1x+int1)+c, 1/2*m/(1+m^2)*(-2*m*c+2*c1y*m+2*c1x-int1)+c];
