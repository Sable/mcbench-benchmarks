function demohelix 
% Demonstration of a 3D helical curve 
% 
 
% D.M. Spink 
% Copyright (c) 2000 
 
coefs =[ 6.0  0.0  6.0  1; 
        -5.5  0.5  5.5  1; 
        -5.0  1.0 -5.0  1; 
         4.5  1.5 -4.5  1; 
         4.0  2.0  4.0  1; 
        -3.5  2.5  3.5  1; 
        -3.0  3.0 -3.0  1; 
         2.5  3.5 -2.5  1; 
         2.0  4.0  2.0  1; 
        -1.5  4.5  1.5  1; 
        -1.0  5.0 -1.0  1; 
         0.5  5.5 -0.5  1; 
         0.0  6.0  0.0  1]'; 
knots = [0 0 0 0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1 1 1 1]; 
 
crv = nrbmak(coefs,knots); 
nrbplot(crv,100); 
title('3D helical curve.'); 
grid on; 
