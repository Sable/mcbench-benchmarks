function [kld, llh1, llh2] = GFM_kld( theta1, theta2, sz )

% Kullback-Leibler divergence between GFM models
% The KLD is computed by simulating observations from model 1 and
% evaluating the composite log-likelihood of these observations under
% model 1 and model 2.
%
% Syntax:
%   [kld, llh1, llh2] = GFM_kld( theta1, theta2, sz )
%
%
% Input:
%   theta1 : Parameters of model 1.
%
%   theta2 : Parameters of model 2.
%
%   sz     : Size of image simulated from model 1
%
%
% Output:
%   kld    : The Kullback-Leibler divergence from model 1 to model 2
%
%   llhX   : The likelihood of the simulation from model 1 under model X
%
%
% See also: GFM_SIMULATION

if ~isequal( size(theta1), size(theta2) )
    error('Models must be of the same size');
end

% Simulate from model1
tree = GFM_simulation( theta1, sz );

% Evaluate likelihood for each direction and level
llh1 = GFM_llh( theta1, tree );
llh2 = GFM_llh( theta2, tree );

% Sum composite likelihood and directions into KLD
kld = llh1 - llh2;

end
