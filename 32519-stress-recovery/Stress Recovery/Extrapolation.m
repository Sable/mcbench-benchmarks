% Procedure to get nodal stresses using Extrapolation method
function [sigma] = Extrapolation(stressGP)

%--------------------------------------------------------------------------
% Purpose : Extrapolating stress at Gaussian points to get nodal stress
%           values
%
% Synopsis : sigma = extrapolation(stressGP)
% 
% Variable Description :
%       sigma - Stress at nodal points
%       stressGP - Stressat gaussian points
%--------------------------------------------------------------------------
% Extrapolation matrix obtained from Shape Functions
% Stress points are at (-1,-1),(-1,1),(1,1),1,-1)
explmt = [1+sqrt(3)/2    -1/2          1-sqrt(3)/2    -1/2;
           -1/2       1-sqrt(3)/2          -1/2    1+sqrt(3)/2 ;
          1-sqrt(3)/2    -1/2          1+sqrt(3)/2    -1/2; 
           -1/2       1+sqrt(3)/2         -1/2     1-sqrt(3)/2 ] ;

sigmax = explmt*stressGP(:,1) ;
sigmay = explmt*stressGP(:,2) ;
sigmaxy = explmt*stressGP(:,3) ;

sigma = [sigmax sigmay sigmaxy]; 
 
