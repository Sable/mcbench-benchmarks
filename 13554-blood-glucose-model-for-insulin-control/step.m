% Created for the blood glucose step response
% by John D. Hedengren
% 02 Sept 2003

global u A


% Steady State Initial Conditions for the States
% Basal values of glucose and insulin conc.
G_ss = 4.5; % mmol/L
X_ss = 15; % mU/L
I_ss = 15; % mU/L

x_ss = [G_ss;I_ss;X_ss];

% Steady State Initial Condition for the Control
u_ss = 16.667; % mU/min

% Steady State for the Disturbance
d_ss = 0; % mmol/L-min

% Final Time (min)
tf = 400;

[t,x] = ode15s('blood_glucose',[0 tf],x_ss);

% Separate out the state values
G = x(:,1);
X = x(:,2);
I = x(:,3);

% Plot the results
figure(1);
plot(t,G);
legend('Glucose');
xlabel('Time (min)');
ylabel('mmol/L');

figure(2);
plot(t,I,t,X);
legend('Plasma Insulin','Remote Compartment Insulin');
xlabel('Time (min)');
ylabel('mU/L');