function plotResult(sol)
% plotResult   Plot acceleration profile and swing angle
%   plotResults(SOL) creates an acceleration and swing angle plot based on
%     SOL returned from "solveCraneODE"
%
%   SOL can be a 1-by-n array representing multiple solutions (returned by
%     "solveCraneODE".

% Copyright 2011 The MathWorks, Inc.

n = length(sol);

maxY = nan(1, n); minY = nan(1, n);
maxA = nan(1, n); minA = nan(1, n);
hA = nan(1, n); hY = nan(1, n);

figure;
for ii = 1:n
   % Get acceleration profile
   acc = motionProfile('accel', sol(ii).T, sol(ii).x, sol(ii).ptotal);
   
   % Plot acceleration profile
   hA(ii) = subplot(2, n, ii);
   plot(sol(ii).T, acc)
   xlim([0 sol(ii).T(end)])
   xlabel('Time (sec)'); ylabel('Acc (m/s^2)')
   
   % Plot swing angle
   hY(ii) = subplot(2, n, n+ii); 
   plot(sol(ii).T, sol(ii).Y(:,1)*180/pi, 'k')  % converting radians to degrees
   hold on
   idx = sol(ii).T >= sol(ii).x(3);
   area(sol(ii).T(idx), sol(ii).Y(idx, 1)*180/pi, 'FaceColor', 'b') ;
   hold off
   xlim([0 sol(ii).T(end)])
   xlabel('Time (sec)'); ylabel('Angle (deg)')
   
   % Record max and min accelerations and angles
   maxA(ii) = max(acc);
   minA(ii) = min(acc);
   maxY(ii) = max(sol(ii).Y(:,1)) * 180/pi;
   minY(ii) = min(sol(ii).Y(:,1)) * 180/pi;
end

% Adjust y-limits
set(hA, 'ylim', [floor(min(minA)), ceil(max(maxA))]);
set(hY, 'ylim', [floor(min(minY)), ceil(max(maxY))]);