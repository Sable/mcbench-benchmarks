function F = colebrook(R,K)
% F = COLEBROOK(R,K) fast, accurate and robust computation of the 
%     Darcy-Weisbach friction factor F according to the Colebrook equation:
%                             -                       -
%      1                     |    K        2.51        |
%  ---------  =  -2 * Log_10 |  ----- + -------------  |
%   sqrt(F)                  |   3.7     R * sqrt(F)   |
%                             -                       -
% INPUT:
%   R : Reynolds' number (should be >= 2300).
%   K : Equivalent sand roughness height divided by the hydraulic 
%       diameter (default K=0).
%
% OUTPUT:
%   F : Friction factor.
%
% FORMAT:
%   R, K and F are either scalars or compatible arrays.
%
% ACCURACY:
%   Around machine precision forall R > 3 and forall 0 <= K, 
%   i.e. forall values of physical interest. 
%
% EXAMPLE: F = colebrook([3e3,7e5,1e100],0.01)
%
% Edit the m-file for more details.

% Method: Quartic iterations.
% Reference: http://arxiv.org/abs/0810.5564 
% Read this reference to understand the method and to modify the code.

% Author: D. Clamond, 2008-09-16. 

% Check for errors.
if any(R(:)<2300) == 1, 
   warning('The Colebrook equation is valid for Reynolds'' numbers >= 2300.');      
end,
if nargin == 1 || isempty(K) == 1,      
   K = 0;
end,
if any(K(:)<0) == 1, 
   warning('The relative sand roughness must be non-negative.'); 
end,

% Initialization.
X1 = K .* R * 0.123968186335417556;              % X1 <- K * R * log(10) / 18.574.
X2 = log(R) - 0.779397488455682028;              % X2 <- log( R * log(10) / 5.02 );                   

% Initial guess.                                              
F = X2 - 0.2;     

% First iteration.
E = ( log(X1+F) - 0.2 ) ./ ( 1 + X1 + F );
F = F - (1+X1+F+0.5*E) .* E .*(X1+F) ./ (1+X1+F+E.*(1+E/3));

% Second iteration (remove the next two lines for moderate accuracy).
E = ( log(X1+F) + F - X2 ) ./ ( 1 + X1 + F );
F = F - (1+X1+F+0.5*E) .* E .*(X1+F) ./ (1+X1+F+E.*(1+E/3));

% Finalized solution.
F = 1.151292546497022842 ./ F;                   % F <- 0.5 * log(10) / F;
F = F .* F;                                      % F <- Friction factor.
