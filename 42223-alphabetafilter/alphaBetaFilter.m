function [xkp,vkp,rk] = alphaBetaFilter(xm, dt, xk, vk, alpha, beta)
% alphaBetaFilter - alpha-beta filter for linear state estimation
%
% Syntax:  [xkp,vkp] = alphaBetaFilter(xm, dt, xk, vk, alpha, beta)
%
% Inputs:
%     xm - measured system state (ie: position)
%     dt - delta time
%     xk - current system state (ie: position)
%     vk - current derivative of system state (ie: velocity)
%
% Outputs:
%    xkp - next system state (ie: position)
%    vkp - next derivative of system state (ie: velocity)
%     rk - residual error
%
% Example:
%     dt = .01; T = 0:dt:10;   % simulation time vector
%     alpha = 0.9;            % initial guess of alpha
%     beta = 0.005;           % initial guess of beta
%     xk = [1 0]';            % initial state (position)
%     vk = [0 0]';            % initial dState/dt (velocity)
%     XR = zeros(length(T),2); XM = zeros(length(T),2); XK = zeros(length(T),2);
%     VK = zeros(length(T),2); RK = zeros(length(T),2);
%     for t = 1:length(T)
%         xm = [cos(2*pi*T(t)) sin(2*pi*T(t))]';  % true position (A circle)
%         XR(t,:) = xm;
%         xm(1) = xm(1) + .0 + .5 .* randn;       % error mean .0 and sd .5
%         xm(2) = xm(2) + .1 + .3 .* randn;       % error mean .1 and sd .3
%         XM(t,:) = xm;
%         [xkp,vkp,rk] = alphaBetaFilter(xm, dt, xk, vk, alpha, beta);
%         xk = xkp;
%         vk = vkp;
%         XK(t,:) = xkp; VK(t,:) = vkp; RK(t,:) = rk;
%     end
%     figure('units','pixels','Position',[0 0 1024 768]);
%     subplot(2,1,1);
%     plot(T,XR(:,1),T,XM(:,1),T,XK(:,1),T,VK(:,1));
%     xlabel('Time (s)'); title('X Pos, Vel and Acc');
%     legend('Real','Measured','Estimated','Velocity');
%     subplot(2,1,2);
%     plot(T,XR(:,2),T,XM(:,2),T,XK(:,2),T,VK(:,2));
%     xlabel('Time (s)'); title('Y Pos, Vel and Acc');
%     legend('Real','Measured','Estimated','Velocity');
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: evaluateAlphaBetaParam;

% Author: Marco Borges, Ph.D. Student, Computer/Biomedical Engineer
% UFMG, PPGEE, Neurodinamica Lab, Brazil
% email address: marcoafborges@gmail.com
% Website: http://www.cpdee.ufmg.br/
% June 2013; Version: v1; Last revision: 2013-09-18
% Changelog:
% 
%------------------------------- BEGIN CODE -------------------------------
    xkp = xk + dt * vk;         % update estimated state x from the system
    vkp = vk;                   % update estimated velocity
    rk = xm - xkp;              % residual error
    xkp = xkp + alpha * rk;     % update our estimates 
    vkp = vkp + beta/dt * rk;   %    given residual error
end
%-------------------------------- END CODE --------------------------------