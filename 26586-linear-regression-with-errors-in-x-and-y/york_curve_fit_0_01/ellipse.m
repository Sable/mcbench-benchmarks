function [X Y] = ellipse(Xc,Yc,dX,dY,N_p)
%calculates an elipse

theta=linspace(0,2*pi,N_p);

X=Xc+dX*cos(theta)-dY*sin(theta);
Y=Yc+dX*cos(theta)+dY*sin(theta);

X=Xc+dX*cos(theta);
Y=Yc+dY*sin(theta);