function state = plotfun(options,state,flag)
% Custom plot function for genetic algorithm
% minimization of rastriginsfcn.

%% Plot underlying contour plot of surface

% Sample x-y plane between -5 and 5
x = -5:0.1:5;
y = -5:0.1:5;

% Sample Rastrgin's function
z = ras(allcomb(x,y));

% Reshape output for visualization
z = reshape(z,101,101);

% Plot contour and hold figure
contour(x,y,z);
hold on;

%% Plot current generation

% Black star for each individual
plot(state.Population(:,1),state.Population(:,2),'k*');

% Set axis limits
axis([-5,5,-5,5]);
hold off;

% Slow down so we can see progression
pause(0.4);