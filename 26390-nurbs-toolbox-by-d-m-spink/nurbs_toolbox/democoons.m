% Construction of a bilinearly blended Coons surface 
% 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
% Boundary curve 1 
pnts = [ 0.0  3.0  4.5  6.5 8.0 10.0; 
         0.0  0.0  0.0  0.0 0.0  0.0;  
         2.0  2.0  7.0  4.0 7.0  9.0];    
crv1 = nrbmak(pnts, [0 0 0 1/3 0.5 2/3 1 1 1]); 
 
% Boundary curve 2 
pnts= [ 0.0  3.0  5.0  8.0 10.0; 
        10.0 10.0 10.0 10.0 10.0; 
        3.0  5.0  8.0  6.0 10.0]; 
crv2 = nrbmak(pnts, [0 0 0 1/3 2/3 1 1 1]); 
 
% Boundary curve 3 
pnts= [ 0.0 0.0 0.0 0.0; 
        0.0 3.0 8.0 10.0; 
        2.0 0.0 5.0 3.0]; 
crv3 = nrbmak(pnts, [0 0 0 0.5 1 1 1]); 
 
% Boundary curve 4 
pnts= [ 10.0 10.0 10.0 10.0 10.0; 
        0.0   3.0  5.0  8.0 10.0; 
        9.0   7.0  7.0 10.0 10.0]; 
crv4 = nrbmak(pnts, [0 0 0 0.25 0.75 1 1 1]); 
 
srf = nrbcoons(crv1, crv2, crv3, crv4); 
 
% Draw the surface 
nrbplot(srf,[20 20]); 
title('Construction of a bilinearly blended Coons surface.'); 
