% Step test for Model 1 - CSTR
% Created by John Hedengren

global u

% Steady State Initial Conditions for the States
Ca_ss = 0.87725294608097;
T_ss = 324.475443431599;
x_ss = [Ca_ss;T_ss];

% Steady State Initial Condition for the Control
u_ss = 300;

% Open Loop Step Change
u = 290;

% Final Time (sec)
tf = 5;

[t,x] = ode15s('cstr1',[0 tf],x_ss);

% Parse out the state values
Ca = x(:,1);
T = x(:,2);

% Plot the results
figure(1);
plot(t,Ca);

figure(2)
plot(t,T);