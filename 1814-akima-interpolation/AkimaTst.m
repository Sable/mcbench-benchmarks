% Test problem for Akima interpolation
% Ref. : Hiroshi Akima, Journal of the ACM, Vol. 17, No. 4, October 1970,
%        pages 589-602.
%
x=0:10; 
y=[10 10 10 10 10 10 10.5 15 50 60 85];
xi=linspace(0,10,51);
yf=akima(x,y,xi); 
subplot(2,2,1); plot(x,y,'o',xi,yf); title('Abscissa set 1')

x=[0 1 3 4 6 7 9 10 12 13 15];
xi=linspace(0,15,51);
yf=akima(x,y,xi); 
subplot(2,2,2); plot(x,y,'o',xi,yf); title('Abscissa set 2')

x=[0 2 3 5 6 8 9 11 12 14 15];
xi=linspace(0,15,51);
yf=akima(x,y,xi);
subplot(2,2,3); plot(x,y,'o',xi,yf); title('Abscissa set 3')

yf=spline(x,y,xi); 
subplot(2,2,4); plot(x,y,'o',xi,yf); title('Cubic spline')