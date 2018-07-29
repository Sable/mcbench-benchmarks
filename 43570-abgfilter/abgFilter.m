function [xkp,vkp,akp,rk] = abgFilter(xm, dt, xk, vk, ak, alpha, beta, gamma)
% abgFilter - alpha-beta-gamma filter for linear state estimation
%
% Syntax: [xkp,vkp,akp,rk] = abgFilter(xm, dt, xk, vk, ak, alpha, beta, gamma)
%
%
% Inputs:
%     xm - measured system state (ie: position)
%     dt - delta time
%     xk - current system state (ie: position)
%     vk - current derivative of system state (ie: velocity)
%     ak - current second derivative of system state (ie: acceleration)
%
% Outputs:
%    xkp - next system state (ie: position)
%    vkp - next derivative of system state (ie: velocity)
%    akp - next second derivative of system state (ie: acceleration)
%     rk - residual error
%
% Example:
%     dt = .005; T = 0:dt:10; % simulation time vector
%     alpha = 0.05;           % initial guess of alpha
%     beta = 0.001;           % initial guess of beta
%     gamma = 2E-5;           % initial guess of gamma
%     xk = [1 0]';            % initial state (position)
%     vk = [0 0]';            % initial dState/dt (velocity)
%     ak = [0 0]';            % initial dState/dt (acceleration)
%     XR = zeros(length(T),2); XM = zeros(length(T),2); XK = zeros(length(T),2);
%     VK = zeros(length(T),2); AK = zeros(length(T),2); RK = zeros(length(T),2);
%     for t = 1:length(T)
%         xm = [cos(2*pi*T(t)) sin(2*pi*T(t))]';        % true position (A circle)
%         XR(t,:) = xm;
%         xm(1) = xm(1) + .0 + .5 .* randn;   % error mean .0 and sd .5
%         xm(2) = xm(2) + .1 + .3 .* randn;   % error mean .1 and sd .3
%         XM(t,:) = xm;
%         [xkp,vkp,akp,rk] = abgFilter(xm, dt, xk, vk, ak, alpha, beta, gamma);
%         xk = xkp; vk = vkp; ak = akp;
%         XK(t,:) = xkp; VK(t,:) = vkp; AK(t,:) = akp; RK(t,:) = rk;
%     end
%     figure('units','pixels','Position',[0 0 1024 768]);
%     subplot(2,1,1);
%     plot(T,XR(:,1),T,XM(:,1),T,XK(:,1),T,VK(:,1),T,AK(:,1));
%     xlabel('Time (s)'); title('X Pos, Vel andAcc');
%     legend('Real','Measured','Estimated','Velocity','Acceleration');
%     subplot(2,1,2);
%     plot(T,XR(:,2),T,XM(:,2),T,XK(:,2),T,VK(:,2),T,AK(:,2));
%     xlabel('Time (s)'); title('Y Pos, Vel andAcc');
%     legend('Real','Measured','Estimated','Velocity','Acceleration');
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: evalABGParam, alphaBetaFilter;

% Author: Marco Borges, Ph.D. Student, Computer/Biomedical Engineer
% UFMG, PPGEE, Neurodinamica Lab, Brazil
% email address: marcoafborges@gmail.com
% Website: http://www.cpdee.ufmg.br/
% References:
%   SIMPSON, H. R., Performance measures and optimization condition for a
%      third order sampled data tracker, IEEE Trans. on Automatic Control,
%      AC-12, June 1962
%   NEAL, S. R., Parametric relations for a-b-g filter predictor, IEEE
%      Trans. on Automatic Control, AC-12, June 1967
% September 2013; Version: v1; Last revision: 2013-09-16
% Changelog:
% 
%------------------------------- BEGIN CODE -------------------------------
    xkp = xk + dt*vk + 1/2*dt^2*ak;	% update estimated system state x
    vkp = vk + dt*ak;               % update estimated velocity
    rk = xm - xkp;                  % residual error
    xkp = xkp + alpha * rk;         % update x 
    vkp = vkp + beta/dt * rk;       %    given residual
    akp = ak + gamma/(2*dt^2) * rk; %        error
end
%-------------------------------- END CODE --------------------------------