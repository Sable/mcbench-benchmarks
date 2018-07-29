function srf = nrbtestsrf 
% Constructs a simple test surface. 
 
%  D.M. Spink 
%  Copyright (c) 2000. 
 
% allocate multi-dimensional array of control points 
pnts = zeros(3,5,5); 
 
% define a grid of control points 
% in this case a regular grid of u,v points 
% pnts(3,u,v) 
% 
 
pnts(:,:,1) = [ 0.0  3.0  5.0  8.0 10.0;     % w*x 
                0.0  0.0  0.0  0.0  0.0;     % w*y 
                2.0  2.0  7.0  7.0  8.0];    % w*z 
 
pnts(:,:,2) = [ 0.0  3.0  5.0  8.0 10.0; 
                3.0  3.0  3.0  3.0  3.0; 
                0.0  0.0  5.0  5.0  7.0]; 
 
pnts(:,:,3) = [ 0.0  3.0  5.0  8.0 10.0; 
                5.0  5.0  5.0  5.0  5.0; 
                0.0  0.0  5.0  5.0  7.0]; 
 
pnts(:,:,4) = [ 0.0  3.0  5.0  8.0 10.0; 
                8.0  8.0  8.0  8.0  8.0; 
                5.0  5.0  8.0  8.0 10.0]; 
 
pnts(:,:,5) = [ 0.0  3.0  5.0  8.0 10.0; 
               10.0 10.0 10.0 10.0 10.0; 
                5.0  5.0  8.0  8.0 10.0]; 
 
% knots 
knots{1} = [0 0 0 1/3 2/3 1 1 1]; % knots along u 
knots{2} = [0 0 0 1/3 2/3 1 1 1]; % knots along v 
 
% make and draw nurbs surface 
srf = nrbmak(pnts,knots); 
