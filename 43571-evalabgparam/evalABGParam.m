function [alpha, beta, gamma, stability] = evalABGParam(process, noisy, dt)
% evalABGParam - evaluates alpha, beta and gamma parameters
% With this parameters, alpha-beta filter becomes a steady-state Kalman filter
%
% Syntax:  [alpha,beta,gamma,stability] = evalABGParam(process,noisy,dt)
%          [alpha,beta,gamma,stability] = evalABGParam([alpha,beta,gamma])
%
% Inputs:
%   process - real system state
%     noisy - measured system state
%        dt - delta time (sample rate)
%
% Outputs:
%     alpha - alpha parameter
%      beta - beta parameter
%     gamma - gamma parameter
% stability - Juri's Stability Test
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: abgFilter;

% Author: Marco Borges, Ph.D. Student, Computer/Biomedical Engineer
% UFMG, PPGEE, Neurodinamica Lab, Brazil
% email address: marcoafborges@gmail.com
% Website: http://www.cpdee.ufmg.br/
% References:
%   NEAL, S. R., Parametric relations for a-b-g filter predictor, IEEE
%      Trans. on Automatic Control, AC-12, June 1967
%   TENNE, D. and Singh, T., Characterizing Performance a-b-g Filters, IEEE
%      Transactions on Aerospace and Electronic Systems, 38, 2002
% September 2013; Version: v1; Last revision: 2013-09-18
% Changelog:
%
%------------------------------- BEGIN CODE -------------------------------

if nargin == 3
    varProcess = var(process);
    varNoise = var(noisy);
    l = varProcess * dt / varNoise; % lambda
    r = (4+l-sqrt(8*l+l^2))/4;
    alpha = 1 - r^2;
    beta = 2*(2-alpha)-4*sqrt(1-alpha);
    gamma = beta^2/(2*alpha);
elseif nargin == 1 && length(process) == 3
    alpha = process(1);
    beta = process(2);
    gamma = process(3);
else
    error('evalABGParam : Incorrect Parameters!');
end

if ( alpha > 0 && alpha < 2 && beta > 0 && beta < (4-2*alpha) && ...
        gamma > 0 && gamma < (4*alpha*beta)/(2*alpha) )
    stability = 'Stable';
else
    stability = 'Unstable';
end
%-------------------------------- END CODE --------------------------------