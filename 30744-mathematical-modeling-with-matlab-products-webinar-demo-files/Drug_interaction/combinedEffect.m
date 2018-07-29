function Effect = combinedEffect(x, y, IC50A, IC50B, alpha, n)
% Copyright 2011 The MathWorks, Inc.
%
% Effect is normalized to maxEffect. Therefore, assume Emax = 1
Emax = 1;

% Model 
Effect = Emax*( x/IC50A + y/IC50B + alpha*( x/IC50A ).*( y/IC50B ) ).^n  ...
           ./(( x/IC50A + y/IC50B + alpha*( x/IC50A ).*( y/IC50B ) ).^n + 1);
