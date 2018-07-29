function demorevolve 
% Demonstration of surface construction by revolving a 
% profile curve. 
 
% D.M. Spink 
% Copyright (c) 2000 
 
% Construct a test profile in the x-z plane  
pnts = [3.0 5.5 5.5 1.5 1.5 4.0 4.5; 
        0.0 0.0 0.0 0.0 0.0 0.0 0.0; 
        0.5 1.5 4.5 3.0 7.5 6.0 8.5]; 
crv = nrbmak(pnts,[0 0 0 1/4 1/2 3/4 3/4 1 1 1]); 
 
% rotate and vectrans by some arbitrary amounts. 
xx = vecrotz(deg2rad(25))*vecroty(deg2rad(15))*vecrotx(deg2rad(20)); 
nrb = nrbtform(crv,vectrans([5 5])*xx); 
 
% define axes of rotation 
pnt = [5 5 0]'; 
vec = xx*[0 0 1 1]'; 
srf = nrbrevolve(nrb,pnt,vec(1:3)); 
 
% make and draw nurbs curve 
p = nrbeval(srf,{linspace(0.0,1.0,20) linspace(0.0,1.0,20)}); 
surfl(squeeze(p(1,:,:)),squeeze(p(2,:,:)),squeeze(p(3,:,:))); 
title('Construct of a 3D surface by revolution of a curve.'); 
shading interp; 
colormap(copper); 
axis equal; 
 
