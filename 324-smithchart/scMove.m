function scMove(Pos1,length,LinCol)
%scMove : Move along the transmission line on smith chart to transform impedance
%
%
%  SYNOPSIS:
%     Transform a point to another one as one moves along a lossless transmission line on
%     smith chart.
%
%     See also scDraw, scInv, scConCirc, scMatchCirc
%     
%  SYNTAX:
%     scMove(Pos1, length, Direction, LinCol)
%
%  INPUT ARGUMENTS:
%     Pos1      : Starting point coordinates [r x] normalized
%     length    : Length of the transmission line normalized to wavelength
%     LinCol     : Color of the end-ray emanating from origin
%     Direction : Towards(+1) or away from the generator(-1) %%%%TO BE INCORPORATED YET.
%
%  OUTPUT ARGUMENT:
%     none
%
%  EXAMPLE:
%         The Command sequence 
%         scDraw;
%         scMove([2 3],.3)
%         will draw a blank smith chart and will plot the point
%         corresponding to impedance (2+j*3)*Z_L and its transformed value
%         after moving 0.3*lambda towards the generator along the
%         transmission line
%
%     Mohammad Ashfaq - (31-05-2000)
%     Mohammad Ashfaq - (13-04-2006) Modified (example included)
%

if nargin == 2
    LinCol = 'm';
end

 r1       = Pos1(1);
 x1       = Pos1(2);
 [u1, v1] = scPOI(r1,x1);

 % MARK STARTING POINT
 scRay(Pos1);

 r        = sqrt(u1^2+v1^2);
 Theta1   = atan2(v1,u1);
 length1  = (1-Theta1/pi)/4;
 length2  = length1 + length;
 Theta2   = (1-4*length2)*pi;
 u2       = r * cos(Theta2);
 v2       = r * sin(Theta2);

 % MARK END POINT
 plot(u2, v2,'r*')

 Theta2d  = Theta2*180/pi;
 if (Theta2d<-180)
    Theta2d  = 360 + Theta2d;
 elseif (Theta2d>180)
    Theta2d  = 360 - Theta2d;
 end
 length2 = length2-floor(length2/.5)*.5;
 
 plot([0 u2],[0 v2],LinCol);
 plot([1.25*cos(Theta2) u2],[1.25*sin(Theta2) v2],'k');
 string = ['\theta=', num2str(Theta2d,'%3.2f'), '  l/\lambda=', num2str(length2, '%0.3f')];
 
 if abs(Theta2d)>90
    Theta2d  = Theta2d+180;
    h = text(1.25*cos(Theta2),1.25*sin(Theta2), string);
    set(h,'rotation', Theta2d, 'Fontsize', 8, 'HorizontalAlignment','right');
 else
    h = text(1.25*cos(Theta2),1.25*sin(Theta2), string);
    set(h,'rotation', Theta2d, 'Fontsize', 8);
 end
