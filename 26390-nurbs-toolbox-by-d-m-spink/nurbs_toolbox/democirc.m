function democirc 
% Demonstration of a circle and arcs in the x-y plane. 
% 
 
% D.M. Spink 
% Copyright (c) 2000 
 
for r = 1:9 
  crv = nrbcirc(r,[],deg2rad(45),deg2rad(315)); 
  nrbplot(crv,50); 
  hold on; 
end 
hold off; 
axis equal; 
title('NURBS construction of a 2D circle and arc.'); 
 