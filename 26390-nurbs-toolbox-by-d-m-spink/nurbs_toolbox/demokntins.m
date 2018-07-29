function demokntins 
% Demonstration of the knot insertion algorithm. 
% 
 
% D.M. Spink 
% Copyright (c) 2000. 
 
crv = nrbtestcrv; 
 
% plot the control points 
plot(crv.coefs(1,:),crv.coefs(2,:),'bo') 
title('Knot insertion along test curve.'); 
hold on; 
plot(crv.coefs(1,:),crv.coefs(2,:),'b--'); 
 
% draw nurbs curve 
nrbplot(crv,48); 
 
% insert new knots and plot new control points 
icrv = nrbkntins(crv,[0.125 0.375 0.625 0.875] ); 
plot(icrv.coefs(1,:),icrv.coefs(2,:),'ro') 
plot(icrv.coefs(1,:),icrv.coefs(2,:),'r--'); 
 
hold off; 
 
 
