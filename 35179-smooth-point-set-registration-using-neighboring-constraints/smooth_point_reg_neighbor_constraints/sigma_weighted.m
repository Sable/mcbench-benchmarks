% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Estimates covariances of the EM algorithm according to the matrix of
% correspondence weights W
% 
% Inputs:
%   gD,gM: 2D coordinates of the data and model graph nodes
%   W: matrix of correspondence weights
%   epsi: optional parameter that introduces better stability
% 
% Output:
%   sigma: covariance matrix

function sigma = sigma_weighted(gD,gM,W,epsi)

if nargin < 4
    epsi = 0.0001;  % improves stability as noted by Horaud et al. PAMI'11
                     % Rigid and articulated point registration with ECM.
end

lD = length(gD);
lM = length(gM);
r1 = W .* ((gD(:,1)*ones(1,lM) - ones(lD,1)*gM(:,1)').^2);
r2 = W .* ((gD(:,2)*ones(1,lM) - ones(lD,1)*gM(:,2)').^2);
sw = sum(W(:));
sigma = diag([sum(r1(:))/sw sum(r2(:))/sw]) + epsi*eye(2);
