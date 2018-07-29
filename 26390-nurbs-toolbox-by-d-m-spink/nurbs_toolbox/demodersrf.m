function demodersrf 
% Demonstrates the construction of a general 
% surface derivatives. 
% 
 
% D.M. Spink 
% Copyright (c) 2000 
 
% make and draw a test surface 
srf = nrbtestsrf; 
p = nrbeval(srf,{linspace(0.0,1.0,20) linspace(0.0,1.0,20)}); 
h = surf(squeeze(p(1,:,:)),squeeze(p(2,:,:)),squeeze(p(3,:,:))); 
set(h,'FaceColor','blue','EdgeColor','blue'); 
title('First derivatives over a test surface.'); 
 
npts = 5; 
tt = linspace(0.0,1.0,npts); 
 
dsrf = nrbderiv(srf); 
 
[p1, dp] = nrbdeval(srf, dsrf, {tt, tt}); 
 
up2 = vecnorm(dp{1}); 
vp2 = vecnorm(dp{2}); 
 
hold on; 
plot3(p1(1,:),p1(2,:),p1(3,:),'ro'); 
h1 = quiver3(p1(1,:),p1(2,:),p1(3,:),up2(1,:),up2(2,:),up2(3,:)); 
h2 = quiver3(p1(1,:),p1(2,:),p1(3,:),vp2(1,:),vp2(2,:),vp2(3,:)); 
set(h1,'Color','black'); 
set(h2,'Color','black'); 
 
hold off; 
 
