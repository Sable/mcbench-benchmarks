 function scConCirc(r,LinCol)
 %scConCirc: draws concentric circles about the origin
%
%  SYNOPSIS:
%     Draws circle about origin in desired color.
%
%     See also scDraw, scInv, scMove, scMatchCirc  
%     
%  SYNTAX:
%     scConCirc(r,color)
%
%  INPUT ARGUMENTS:
%     r      : radius of the circle
%     LinCol : desired color of the arc, optional, default = 'm', magenta
%
%  OUTPUT ARGUMENT:
%     none
%
%
%  EXAMPLE:
%         The Command sequence 
%         scDraw;
%         scConCirc(0.4);
%         will draw a blank smith chart and draw a circle having center at the
%         smith chart center [1 0] and a radius 0.4. This may be thought of as
%         the locus of all the points having a reflection factor 0.4.
%
%     Mohammad Ashfaq - (31-05-2000)
%     Mohammad Ashfaq - (13-04-2006) Modified (example included)
%
 
 if nargin == 1
    LinCol = 'm';
 end

 x = linspace(-r,r,200);
 plot(x, sqrt(r^2-x.^2),LinCol);
 plot(x,-sqrt(r^2-x.^2),LinCol);
