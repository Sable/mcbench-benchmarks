% Step test for Model 5 - Two CSTRs in Series
% Created by John Hedengren

global u

% Steady State Initial Condition for the Control
u_ss = 100.0;

% Steady State Initial Conditions for the States
CA1_ss = 0.088227891617;
T1_ss = 441.219326816202;
CA2_ss = 0.005292690885;
T2_ss = 449.474581253729;
x_ss = [CA1_ss;T1_ss;CA2_ss;T2_ss];

% Final Time (sec)
tf = 16;

% Open Loop Step Change
u = u_ss * 1.1;

[t1,x1] = ode15s('cstr5',[0 tf],x_ss);

% Open Loop Step Change
u = u_ss / 1.1;

[t2,x2] = ode15s('cstr5',[0 tf],x_ss);

% Temperature of Reactor 2
T2_1 = x1(:,4);
T2_2 = x2(:,4);

% Concentration in Reactor 2
Ca2_1 = x1(:,3);
Ca2_2 = x2(:,3);

% Plot the results
figure(1)
plot(t1,T2_1,t2,T2_2);

figure(2);
plot(t1,Ca2_1,t2,Ca2_2);