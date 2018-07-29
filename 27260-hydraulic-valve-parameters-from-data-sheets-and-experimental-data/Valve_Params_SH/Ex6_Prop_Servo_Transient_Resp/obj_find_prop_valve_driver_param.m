function F  = obj_find_prop_valve_driver_param(x)
% Objective function to find parameters of the actuator that produce
% required transient response
% Copyright 2010 MathWorks, Inc.

assignin('base','gain', x(1));
assignin('base','time_constant', x(2));
assignin('base','act_saturation', x(3));

% To avoid negative values of variable parameters, the minimum acceptable
% values are provided
gain_min = 25;
time_constant_min = 0.001;
saturation_min = 0.5;

model = 'transient_response_match_test_rig';
load_system(model);
sim(model);

% Computing objective function
F = 0;

% To keep variable parameters in feasable region, penalty function P(x) is
% introduced
if x(1) <= gain_min
    P(1) = (x(1) - gain_min)^2;
else
    P(1) = 0;
end

if x(2) <= time_constant_min
    P(2) = (x(2) - time_const_min)^2;
else
    P(2) = 0;
end

if x(3) <= saturation_min
    P(3) = (x(3) - saturation_min)^2;
else
    P(3) = 0;
end

k = [200 100];        % Weight multipliers for transient responses
z = [1e9 1e9 1e9];    % Weight multipliers for penalty function

for j = 1:2
    F = F + k(j) * yout(end,j);
end

% Adding penalty function
for j = 1:3
    F = F + z(j) * P(j);
end

end

% EOF