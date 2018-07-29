% Step test for Electric Vehicle
% Created by John Hedengren
close all
clear all

global u

% Steady State Initial Conditions for the States - Vehicle at Rest
x_ss = zeros(7,1);

% Steady State Initial Condition for Input
u_ss = 36; % volts
u = u_ss;

% Final Time (sec)
tf = 20;

[t,x] = ode15s('electric_car',[0 tf],x_ss);

% Parse out the state values
% i is the motor current (Amps)
% dth_m is the rotor angular velocity sometimes called omega (radians/sec)
% th_m is the rotor angle, theta (radians)
% dth_l is the wheel angular velocity (rad/sec)
% th_l is the wheel angle (radians)
% dth_v is the vehicle velocity (m/sec)
% th_v is the distance travelled (m)
current = x(:,1);
dth_m = x(:,2);
th_m = x(:,3);
dth_l = x(:,4);
th_l = x(:,5);
dth_v = x(:,6);
th_v = x(:,7);

% Plot the results
figure(1);
subplot(2,1,1)
plot(t,current);
xlabel('time (sec)')
ylabel('current (A)')
title ('Power Supply')

subplot(2,1,2)
u_plot = ones(size(t,1)) * u;
plot(t,u_plot,'r-');
xlabel('time (sec)')
ylabel('voltage (V)')


figure(2);
subplot(2,1,1);
plot(t,dth_m,'b-');
hold on;
plot(t,dth_l,'r.');
xlabel('time (sec)');
ylabel('velocity (rad/sec)');
title ('Motor / Drive Shaft');
legend('motor','power train')

subplot(2,1,2)
plot(t,th_m,'b-');
hold on
plot(t,th_l,'r.');
xlabel('time (sec)')
ylabel('position (rad)')
legend('motor','power train')



figure(3);
hold on
subplot(2,1,1)
plot(t,dth_v,'b-');
xlabel('time (sec)')
ylabel('velocity (m/sec)')
title ('Automobile')

subplot(2,1,2)
plot(t,th_v,'b-');
xlabel('time (sec)')
ylabel('position (m)')
