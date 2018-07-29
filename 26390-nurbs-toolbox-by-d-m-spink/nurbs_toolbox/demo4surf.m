function demo4surf 
% Demonstration of a bilinear surface. 
% 
 
% D.M. Spink 
% Copyright (c) 2000 
 
srf = nrb4surf([0.0 0.0 0.5],[1.0 0.0 -0.5],[0.0 1.0 -0.5],[1.0 1.0 0.5]); 
nrbplot(srf,[10,10]); 
title('Construction of a bilinear surface.'); 
