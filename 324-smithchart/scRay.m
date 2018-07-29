 function scRay(point, LinCol)
%scRay : Draws a ray emanating from the origin towards a given point on smith chart 
%
%  SYNOPSIS:
%     Draws a ray emanating from the origin towards a given point on smith chart.
%     One may need to do so when solving a transmission line problem using a smith
%     chart. This may be useful, because it also shows the phase angle and the
%     transmission line length on its outer extrimity which need not be read manualy
%     from the outer scales of the smith chart.
% 
%     
%  SYNTAX:
%     scRay(point, LinCol)
%
%  INPUT ARGUMENTS:
%     point  : coordinates of the given point [r x] normalized
%     LinCol : color of the ray
%
%  OUTPUT ARGUMENT:
%     none
%
%  EXAMPLE:
%         The Command sequence 
%         scDraw;
%         scRay([2 3]);
%         will draw a blank smith chart and draw a line from smith chart
%         center [1 0] (corresponding to impedence Z_L) to the point [2 3]
%         in the smith chart corresponding to an impedance (2+j3)*Z_L. This
%         may be thought of locating an load impedance of (2+j3)*Z_L on the
%         smith chart
%  
%
%     Mohammad Ashfaq - (31-05-2000)
%     Mohammad Ashfaq - (13-04-2006) Modified (example included)
%
 if nargin == 1
     LinCol='m';
 end
 r1 = point(1);
 x1 = point(2);
 [u1, v1] = scPOI(r1,x1);

 % MARK POINT
 plot(u1,v1,'r*')

 Theta    = atan2(v1,u1);
 
 plot([0 u1],[0 v1],LinCol);
 
 plot([1.35*cos(Theta) u1],[1.35*sin(Theta) v1],'k');

 h = text(1.4*cos(Theta),1.4*sin(Theta), '\theta=');
 set(h, 'Fontsize', 9, 'HorizontalAlignment','center','Color','r');
 h = text(1.4*cos(Theta)+0.08,1.4*sin(Theta), ['     ', num2str(Theta*180/pi,'%3.2f')]);
 set(h, 'Fontsize', 8, 'HorizontalAlignment','center','Color','k');

 h = text(1.4*cos(Theta),1.4*sin(Theta)-0.05, 'l / \lambda=');
 set(h, 'Fontsize', 9, 'HorizontalAlignment','center','Color','r');

 h = text(1.4*cos(Theta)+0.08,1.4*sin(Theta)-0.05, ['         ',num2str((1-Theta/pi)/4, '%0.3f')]);
 set(h, 'Fontsize', 8, 'HorizontalAlignment','center','Color','k');

if 0

 string1 = ['\theta=', num2str(Theta*180/pi,'%3.2f')];
 string2 = ['l/\lambda=', num2str((1-Theta/pi)/4, '%0.3f')];
 
 Thetad = Theta*180/pi;
 
 h1 = text(1.4*cos(Theta),1.4*sin(Theta)    , string1);
 h2 = text(1.4*cos(Theta),1.4*sin(Theta)-0.2, string2);
 set(h1, 'Fontsize', 8, 'HorizontalAlignment','right');
 set(h2, 'Fontsize', 8, 'HorizontalAlignment','right');

 if abs(Thetad)>90
    Thetad  = Thetad+180;
    set(h1,'rotation', Thetad, 'Fontsize', 8, 'HorizontalAlignment','right');
    set(h2,'rotation', Thetad, 'Fontsize', 8, 'HorizontalAlignment','right');
 else
    set(h1,'rotation', Thetad, 'Fontsize', 8);
    set(h2,'rotation', Thetad, 'Fontsize', 8);
 end
end
