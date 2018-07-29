function [alpha, beta, stability] = evaluateAlphaBetaParam(process, noisy, dt)
% evaluateAlphaBetaParam - evaluates alpha and beta parameters for alpha-beta filter
% With this parameters, alpha-beta filter becomes a steady-state Kalman filter
%
% Syntax:          [xkp,vkp] = alphaBetaFilter(xm, dt, xk, vk, alpha, beta)
%   [alpha, beta, stability] = evaluateAlphaBetaParam(process, noisy, dt)
%     [alpha,beta,stability] = evalABGParam([alpha,beta])
%
% Inputs:
%   process - real system state
%     noisy - measured system state
%
% Outputs:
%   alpha - alpha parameter
%    beta - beta parameter
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: alphaBetaFilter;

% Author: Marco Borges, Ph.D. Student, Computer/Biomedical Engineer
% UFMG, PPGEE, Neurodinamica Lab, Brazil
% email address: marcoafborges@gmail.com
% Website: http://www.cpdee.ufmg.br/
% June 2013; Version: v2; Last revision: 2013-09-18
% Changelog:
%  v2 - add Stability test
%
%------------------------------- BEGIN CODE -------------------------------

if nargin == 3
    varProcess = var(process);
    varNoise = var(noisy);
    l = varProcess * dt / varNoise; % lambda
    r = (4+l-sqrt(8*l+l^2))/4;
    alpha = 1 - r^2;
    beta = 2*(2-alpha)-4*sqrt(1-alpha);
elseif nargin == 1 && length(process) == 2
    alpha = process(1);
    beta = process(2);
else
    error('evaluateAlphaBetaParam : Incorrect Parameters!');
end

if ( alpha > 0 && alpha < 2 && beta > 0 && beta < (4-2*alpha) )
    stability = 'Stable';
else
    stability = 'Unstable';
end

end
%-------------------------------- END CODE --------------------------------