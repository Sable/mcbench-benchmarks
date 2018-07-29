% Demonstration of ruled surface construction. 
% 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
% clear all recorded graphics and the current window 
title('Ruled surface construction from two NURBS curves.'); 
 
crv1 = nrbtestcrv; 
crv2 = nrbtform(nrbcirc(4,[4.5;0],pi,0.0),vectrans([0.0 4.0 -4.0])); 
srf = nrbruled(crv1,crv2); 
nrbplot(srf,[40 20]); 
title('Ruled surface construction from two NURBS curves.'); 
