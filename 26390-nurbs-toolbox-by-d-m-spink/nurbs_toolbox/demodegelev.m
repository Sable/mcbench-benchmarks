% Demonstration of the degree elevation algorithm. 
% 
 
crv = nrbtestcrv; 
 
% plot the control points 
plot(crv.coefs(1,:),crv.coefs(2,:),'bo') 
title('Degree elevation of test curve by 1'); 
hold on; 
plot(crv.coefs(1,:),crv.coefs(2,:),'b--'); 
 
% draw nurbs curve 
nrbplot(crv,48); 
 
% degree elevate the curve by 1 
icrv = nrbdegelev(crv, 1); 
 
% insert new knots and plot new control points 
plot(icrv.coefs(1,:),icrv.coefs(2,:),'ro') 
plot(icrv.coefs(1,:),icrv.coefs(2,:),'r--'); 
 
hold off; 
