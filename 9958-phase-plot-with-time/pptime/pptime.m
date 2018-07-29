function pptime(y,time)

% Phase plot with colored time representation
% 
%   PPTIME(Y,TIME)  Takes a two dimensional Y array and
%   one dimensional TIME array of the same size as input 
%   argument and plots the colored phase plot with explicit
%   time 
%   Every second of the simulation time will be represented 
%   with another color in the phase plot.
%
%   Date: 02.11.2006
%   Author: Atakan Varol


leny = length(y);
n = floor(max(time));            % n is the number of different color segments in the plot (1-64)
palette = jet(n);               % Create the color palette from the jet color map


% Plot the phase plot
figure
subplot(10,1,1:9)
for t = 1:n 
    hold on
    % Plot part of the phase plot
    title('Phase Plot with Colored Time Representation')
    pplot1 = plot( y(floor(leny/n)*(t-1)+1 : floor(leny/n)*t,1), ...
                   y(floor(leny/n)*(t-1)+1 : floor(leny/n)*t,2), ...
                    'LineWidth',3,'Color', palette(t,:) );
    xlabel('x_{1}');
    ylabel('x_{2}'); 
end
hold off
grid on


% Plot the time scale 
subplot(10,1,10)
hold on
for t = 1:n 
    x = [ t-1  t  t t-1]; 
    y = [ 0    0  1 1 ]; 
    patch(x,y,palette(t,:))
    xlabel('time');
    ylabel('Color');
end
hold off

end
