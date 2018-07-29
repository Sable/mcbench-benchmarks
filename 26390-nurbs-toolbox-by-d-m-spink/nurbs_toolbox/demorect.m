function demorect 
% Demonstrate of rectangluar curve 
% 
 
% D.M. Spink 
% Copyright (c) 2000 
 
crv = nrbtform(nrbrect(2,1), vecrotz(deg2rad(35))); 
nrbplot(crv,4); 
title('Construction and rotation of a rectangle.'); 
axis equal; 
