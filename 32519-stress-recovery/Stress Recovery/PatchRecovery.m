% Preocedure for Patch recovery
%
% Reference: The Superconvergent Patch Recovery and a Posteriori Error
% Estimates. Part 1: THE RECOVERY TECHNIQUE - O. C. Zienkiewicz & Z. Zhu
% INTERNATIONAL JOURNAL OF NUMERICAL METHODS IN ENGINEERING, VOL. 33,
% 1331-1364 (1992)
function [sigma,gravity] = PatchRecovery(x,y,stressGP)
%--------------------------------------------------------------------------
% Code written by : Siva Srinivas Kolukula                                %
%                   Senior Research Fellow                                %
%                   Structural Mechanics Laboratory                       %
%                   Indira Gandhi Center for Atomic Research              %
%                   India                                                 %
% E-mail : allwayzitzme@gmail.com                                         %
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Purpose : Extrapolate the stresses at Gaussian Points to get nodal
%           stresses using Pach Recovery Technique
% Synopsis :
%   [sigma] = patch_recovery(x,y,stressGP)
% 
% Variable Description :
%       sigma - stress at a nodes for a element
%       x,y - Nodal Coordinates
%       stressGP - stress at Gaussian Points/Sampling points
% 
% Note : Origin is the center of the element i.e the Gaussian
%        point coordinates are written w.r.t that point 
%--------------------------------------------------------------------------
% Getting coordinates of Gaussian points/Sampling points
a = abs(x(3)-x(1))/2 ;  % Half length of the element along X-axes
b = abs(y(3)-y(1))/2 ;  % Half length of the element along Y-axes
mp = [x(1)+x(3) y(1)+y(3)]/2 ;
s1 = 1/sqrt(3) ; % Factor to get the Sampling points
gp = [-s1*a+mp(1) -s1*b+mp(2) ;
      +s1*a+mp(1) -s1*b+mp(2) ;
      +s1*a+mp(1) +s1*b+mp(2) ;
      -s1*a+mp(1) +s1*b+mp(2)];
gpx = gp(:,1) ;gpy = gp(:,2);
% plot(x,y,'.r') ;
% hold on
% plot(mp(1),mp(2),'*r');
% plot(gpx,gpy,'*k')
% Extrapolating stress at nodal points
P = [ones(4,1) gpx gpy gpx.*gpy ];
A = P'*P ;

bx = P'*stressGP(:,1) ;
by = P'*stressGP(:,2) ;
bxy = P'*stressGP(:,3) ;

ax = A\bx ;ay = A\by ; axy = A\bxy ;

P = [ones(4,1) x' y' x'.*y'] ;
sigmax = P*ax ;
sigmay = P*ay ;
sigmaxy = P*axy ;


sigma = [sigmax sigmay sigmaxy];

% Extrapolating stress at Middle point of the element
PM = [1 mp(1) mp(2) mp(1)*mp(2)] ;

gravity = [PM*ax PM*ay PM*axy] ;
    
