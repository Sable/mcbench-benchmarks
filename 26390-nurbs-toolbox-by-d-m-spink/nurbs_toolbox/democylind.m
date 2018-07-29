function democylind 
% Demonstration of the construction of a cylinder. 
% 
 
% D.M. Spink 
% Copyright (c) 2000 
 
srf = nrbcylind(3,1,[],deg2rad(270),deg2rad(180)); 
nrbplot(srf,[20,20]); 
axis equal; 
title('Cylinderical section by extrusion of a circular arc.'); 
 
