function animateCrane(sol)
% animateCrane  Create interactive animation of the crane
%   animateCrane(SOL) creates an animation of the crane based on SOL
%     returned from "solveCraneODE"

% Copyright 2011 The MathWorks, Inc.

% Create evenly spaced points
Tnew = linspace(0, sol.T(end), 400)';
Ynew = interp1(sol.T, sol.Y, Tnew);

% Block X position
xx = motionProfile('pos', Tnew, sol.x, sol.ptotal);

%% Calculate x,y position of end of line and payload

theta  = Ynew(:,1);
xtheta = sol.r * sin(theta);
ytheta = sol.r * cos(theta);

%% Setup Animation

fh = gcf; clf(fh); figure(fh);
set(fh, 'DoubleBuffer', 'on');
subplot(2,1,1); axis equal
set(gca, 'DrawMode', 'fast', 'Box', 'on', 'YTick', [], ...
   'XLim', [-5, sol.ptotal*1.1], 'YLim', [-sol.r*1.25, sol.r*0.25]);
ht = title(' ', 'Color', 'r', 'FontWeight', 'bold');

% Create block, line, and payload
rWidth  = sol.ptotal * 0.05;
rHeight = sol.ptotal * 0.02;
cDiam   = sol.r * 0.25;
hr = rectangle('Position', [-rWidth/2, -rHeight/2, rWidth, rHeight], ...
   'LineWidth', 2, 'FaceColor', 'k');
hl = line([0 0], [0 -sol.r], 'LineWidth', 2);
hb = rectangle('Position', [-cDiam/2, -ytheta(1)-cDiam/2, cDiam, cDiam], ...
   'Curvature', [1,1], ...
   'LineWidth', 2, 'FaceColor', 'r', 'EdgeColor', 'none');

% Swing Angle
subplot(2,1,2);
ylim([floor(min(theta*180/pi)), ceil(max(theta*180/pi))]);
yl = ylim();
patch([sol.x(3), Tnew(end), Tnew(end), sol.x(3)], yl([1 1 2 2]), ...
   [0.75 0.75 1], 'EdgeColor', [0.75 0.75 1]);
line([0, Tnew(end)], [0 0], 'Color', [.5 .5 .5]);
line(Tnew, theta*180/pi, 'Color', 'k', 'LineWidth', 2);  % converting radians to degrees
hp = line(0, 0, 'Color', 'r', 'Marker', '.', 'MarkerSize', 20);
xlim([0, Tnew(end)]);
xlabel('Time (sec)'); ylabel('Angle (deg)');

animate();

%%
   function animate()
      
      set(fh, 'WindowButtonDownFcn', '');
      set(ht, 'String', ' ');

      % Animate through frames
      for ii = 1:length(Tnew)
         newX = xx(ii);
         set(hr, 'Position',[newX-rWidth/2, -rHeight/2, rWidth, rHeight]);
         set(hl, 'XData', [newX, newX+xtheta(ii)], 'YData', [0, -ytheta(ii)]);
         set(hb, 'Position', [-cDiam/2+xx(ii)+xtheta(ii), -cDiam/2-ytheta(ii), cDiam, cDiam]);
         
         set(hp, 'XData', Tnew(ii), 'YData', theta(ii)*180/pi);
         
         pause(0.01);
      end
      
      set(fh, 'WindowButtonDownFcn', @(o,e) animate);
      set(ht, 'String', 'Click figure to replay');
   end

end

