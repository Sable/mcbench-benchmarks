function demodercrv 
% Demonstrates the construction of a general 
% curve and determine of the derivative. 
% 
 
% D.M. Spink 
% Copyright (c) 2000 
 
% make and draw nurbs test curve 
crv = nrbtestcrv; 
nrbplot(crv,48); 
title('First derivatives along a test curve.'); 
 
npts = 9; 
tt = linspace(0.0,1.0,npts); 
 
dcrv = nrbderiv(crv); 
 
% first derivative 
[p1, dp] = nrbdeval(crv,dcrv,tt); 
 
p2 = vecnorm(dp); 
 
hold on; 
plot(p1(1,:),p1(2,:),'ro'); 
h = quiver(p1(1,:),p1(2,:),p2(1,:),p2(2,:),0); 
set(h,'Color','black'); 
hold off; 
