function demotorus 
% A second demonstration of surface construction 
% by revolution. 
% 
 
% D.M. Spink 
% Copyright (c) 2000 
 
sphere = nrbrevolve(nrbcirc(1,[],0.0,pi),[0.0 0.0 0.0],[1.0 0.0 0.0]); 
nrbplot(sphere,[20 20],'light','on'); 
title('Ball and torus - surface construction by revolution'); 
hold on; 
torus = nrbrevolve(nrbcirc(0.2,[0.9 1.0]),[0.0 0.0 0.0],[1.0 0.0 0.0]); 
nrbplot(torus,[20 10],'light','on'); 
nrbplot(nrbtform(torus,vectrans([-1.8])),[20 10],'light','on'); 
hold off; 
