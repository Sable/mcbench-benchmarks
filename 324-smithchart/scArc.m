 function scArc(Point, LinCol)
 %scArc : Draws an arc (a circle) on the smith chart passing through a given point
%
%  SYNOPSIS:
%     Draws an arc (a circle) on the smith chart passing through a given point.
%     the point in question is defined as an (r,x) pair. This function should only
%     be called when a smith chart figure is already present.
%
%     See also scDraw, scInv, scMove, scMatchCirc
%     
%  SYNTAX:
%     scArc(Point, LinCol)
%
%  INPUT ARGUMENTS:
%     Point  : values of r and x defining a point on the smith chart as a vector [r x]
%     LinCol : color of the arc (or circle)
%
%  OUTPUT ARGUMENT:
%     none
%
%  EXAMPLE:
%         The Command sequence 
%         scDraw;
%         scArc([2 3]);
%         will draw a blank smith chart and draw a circle having center at the
%         smith chart center [1 0] and passing through the point [2 3]
%         in the smith chart corresponding to an impedance (2+j3)*Z_L. This
%         may be thought of as the locus of impedance along the lossless
%         line of line impedance Z_L.
%  
%
%     Mohammad Ashfaq - (31-05-2000)
%     Mohammad Ashfaq - (13-04-2006) Modified (example included)
%

 if nargin == 1
     LinCol = 'm';
 end
     
 r1 = Point(1);
 x1 = Point(2);

 %x2 = to(2);
 %r2 = to(1);

 [u1, v1] = scPOI(r1, x1);
 %[u2,v2]=point_of_intersection(r2,x2);
 x = linspace(-sqrt(u1^2+v1^2),sqrt(u1^2+v1^2),500);
 
 plot(x,sqrt(u1^2+v1^2-x.^2),LinCol);
 plot(x,-sqrt(u1^2+v1^2-x.^2),LinCol);

 % MARK POINT
 plot(u1,v1,'r*')

