function demoellip 
% Demonstration of a unit circle transformed to a inclined ellipse 
% by first scaling, then rotating and finally translating. 
% 
 
% D.M. Spink 
% Copyright (c) 2000 
 
xx = vectrans([2.0 1.0])*vecroty(pi/8)*vecrotx(pi/4)*vecscale([1.0 2.0]); 
c0 = nrbtform(nrbcirc, xx); 
nrbplot(c0,50); 
title('Construction of an ellipse by transforming a unit circle.'); 
grid on; 
