function F  = obj_find_simple_valve_driver_param(x)
% Objective function to find out the parameters of the simple Valve
% Actuator
% Copyright 2010 MathWorks, Inc.

% Assigning current values of the variable parameters to the model
assignin('base','time_const', x(1));
assignin('base','t_d', x(2));

model = 'simple_valve_driver_testrig';
load_system(model);
sim(model);

% Computing objective function. The integral of the difference between the
% required and obtained characteristics is exported to the MATLAB workspace 
% in array yout. The last value in the array is the measure of the difference.

F = yout(end);

end

% EOF