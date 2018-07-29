function scMatchCirc(LinCol)
%scMatchCirc : Draws the match-circle on smith chart
%
%  SYNOPSIS:
%     This function draws a circle for impedance matching purposes on the smith
%     chart. Such a circle has its center at the point (-0.5, 0) and has a radius
%     equal to 0.5
%
%     See also scDraw, scInv, scMove, scConCirc
%     
%  SYNTAX:
%     scMatchCirc(LinCol)
%
%  INPUT ARGUMENTS:
%     LinCol     : Color of the matching circle, default = 'm', magenta
%
%  OUTPUT ARGUMENT:
%     none
%
%
%  EXAMPLE:
%         The Command sequence 
%         scDraw;
%         scMatchCirc;
%         will draw a blank smith chart and draw a circle having center at the
%         at the point (-0.5, 0) and has a radius equal to 0.5. This circle
%         will be the locus of all the points having admittances reciprocal to the 
%         impedances on the circle r = 1 of the smith chart.
%
%     Mohammad Ashfaq - (31-05-2000)
%     Mohammad Ashfaq - (13-04-2006) Modified (example included)
%


 if nargin == 0
    LinCol = 'm';
 end

 x = -1:0.01:0;
 y = real(sqrt(0.5^2-(x+.5).^2));
 plot(x,  y, LinCol);
 plot(x, -y, LinCol);

