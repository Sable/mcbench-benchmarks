function [ alpha ] = LiMapS(s, D, DINV, gamma, maxIter)
%
% [ alpha ] = LIMAPS(s, D, DINV, gamma)
%
%   Returns the sparsest vector alpha which satisfies underdetermined 
%   system of equations  D*alpha=s, using  Lipschitzian Mapping for Sparsity
%   Recovery algorithm. 
%   The dictionary matrix  D should have more columns than rows. The 
%   number of rows of dictionary D  must be equal to the length of the 
%   column observation vector(or matrix) s.
%
%     The observations signal(s) s and the dictionary D necessarily, must 
%   be provided by the user. The other parameters have defult values, or
%   may be provided by the user.
% 
%   This algorithm work fine with matrix too, returning the sparsest matrix
%   alpha that satisfy the underdetermined system of equations D*alpha=s.
%   Then the dictionary D is of size [n x m], s must be of size [ s x T ] and
%   as consiquence the coefficients matirx alpha is of size [ m x T]
% 
%   s: 
%       The observation vector (matrix)
%        
%   D: 
%       The dictionary 
%        
%   DINV (optional): 
%       The pseudo-inverse of the dictionary matrix D
%
%   gamma (optional): 
%       The increase factor (default 1.01)
%
%   maxIter (optional): 
%       Maximum number of iterations (default 1000)
%
% Authors: Alessandro Adamo and Giuliano Grossi
% Version: 1.0
% Last modified: 1 Aug. 2011.
%
% WEB PAGE:
% ------------------
%    http://dalab.dsi.unimi.it/limaps
%
% HISTORY:
%--------------
% Version 1.0: 1 Aug. 2011
%        first official version.
%

if(nargin<2||nargin>5)
    error('Wrong parameters number');
end
if(nargin==2)
    DINV=pinv(D);
    gamma=1.01;
    maxIter=1000;
end
if(nargin==3)
    gamma=1.01;
    maxIter=1000;
end
if(nargin==4)
    maxIter=1000;
end


%% --  INITIALIZATION  --
alpha = DINV*s;

lambda = 1/max(abs(alpha(:)));
epsilon=1e-5;                    % stopping criteria
alpha_min=1e-2;

%% --  CORE  --
for i=1:maxIter
    
    alphaold=alpha;
    % apply sparsity constraction mapping: increase sparsity
    beta = alpha.*(1-exp(-lambda.*abs(alpha)));
    
    beta(abs(beta)<alpha_min)=0;
    
    % apply the orthogonal projection
    alpha = beta-DINV*(D*beta-s);
    
    % update the lambda coefficient
    lambda = lambda*gamma;
    
    % check the stopping criteria
    if (norm(alpha(:)-alphaold(:))<epsilon)
        break;
    end
   
    if (mod(i,100)) 
        if(sum(abs(1-exp(-lambda*abs(alpha)))>1/lambda)>size(D,1))
           break;
        end
    end
    
end

%% -- REFINEMENT --

% threshold the coefficients 
alpha(abs(alpha)<alpha_min) = 0;

% final refinements of the solution
for i=1:size(alpha,2);
    alpha_ind = alpha(:,i)~=0;
    D1 = D(:,alpha_ind);
    alpha(alpha_ind,i) = alpha(alpha_ind,i) - pinv(D1)*(D1*alpha(alpha_ind,i)-s(:,i));
end

end

