function demogeom 
% Demonstration of how to construct a 2D geometric   
% shape from a piece-wise set of NURBSs 
% 
 
% D.M. Spink 
% Copyright (c) 2000. 
 
coefs = [0.0 7.5 15.0 25.0 35.0 30.0 27.5 30.0; 
         0.0 2.5  0.0 -5.0  5.0 15.0 22.5 30.0]; 
knots = [0.0 0.0 0.0 1/6 1/3 1/2 2/3 5/6 1.0 1.0 1.0]; 
 
% Geometric boundary curve 
geom = [ 
nrbmak(coefs,knots) 
nrbline([30.0 30.0],[20.0 30.0]) 
nrbline([20.0 30.0],[20.0 20.0]) 
nrbcirc(10.0,[10.0 20.0],1.5*pi,0.0) 
nrbline([10.0 10.0],[0.0 10.0]) 
nrbline([0.0 10.0],[0.0 0.0]) 
nrbcirc(5.0,[22.5 7.5]) 
]; 
 
ng = length(geom); 
for i = 1:ng 
  nrbplot(geom(i),50); 
  hold on; 
end 
hold off; 
axis equal; 
title('2D Geometry formed by a series of NURBS curves'); 
