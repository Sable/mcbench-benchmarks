%% Learning PID Tuning I: Process Reaction Curve
% Most PID tuning rules are based on the assumption that the plant can be
% approaximated by a first-order plus time delay system. This code explains
% why this assumption is valid and how to identify such an approximation
% model. Finaly, we use a 4th-order example to show how this can be done and
% compare it with oscilation based tuning approach.

%% Step Response
% Consider a typical first order system,
%
% $$G(s) = \frac{1}{s+1}$$
%
% and a fourth order system
%
% $$G_2(s) = \frac{1}{(s+1)^4}$$
%
% Their step responses are generated using the MATLAB Control System
% Toolbox as follows.
G = tf(1,[1 1]);
subplot(221)
step(G)
G2 = tf(1, [1 4 6 4 1]);
subplot(222)
step(G2)

%% Maximum Slope of Step Responses
% The difference is that the response of the first order system has the
% maximum response slope at the t=0, whilst that of the 4th order system
% is at t>0. This difference is true for all high-order (>1) systems. 
%
% The maximum slope is the maximum reseponse speed. For a first order
% system, if we assume the system can keep the maximum resppnse speed all 
% the time, then the system will take exact the time of the time constant
% to reach its steady-state. Therefore, the time constant can be identified
% by taking the maximum slope and measuring the time period between the
% points where the the maximum slope line accrosses the initial and final
% response lines.
% 
subplot(223)
step(G)
hold
plot([0 1],[0 1],'Linewidth',2)
plot([1 1],[0 1],':')
set(gca,'Xtick',1)

%% Approximation of the 4th Order System using the Maximum Slope Line
% To approximate the 4th order system, we wish to keep the maximum
% response speed being the same between the actual system and the
% approximated first-order plus time delay system. Therefore, this leads to
% the so called process reaction curve approach to identify the
% approaximation.  

[y,t]=step(G2);
% The maximum response speed and the corresponding time point
[dydt,idx]=max(diff(y)./diff(t));
% The crossing point with the initial line
t0=t(idx)-y(idx)/dydt;
% The crossing point with the steady state line
t1=t(idx)+(1-y(idx))/dydt;
% plot the step response with the maximum slope
subplot(224)
plot(t,y,'-',[t0 t1],[0 1],'r--','Linewidth',2)

%% Process Reaction Curve Approximation
% The step response is termed as the Process Reaction Curve in process.
% However, manually to draw the maximum slope on a Process Reaction Curve
% is neither accurate nor convinient. The submission of Process Reaction
% Curve provides a tool to get the first-order plus time delay approaximate 
% model directly from the supplied step response data (Process Reaction
% Curve). 
%
% Let us apply this function to the step response of the 4th order system,
% then compare how good of the approximation is.
[model,controller]=ReactionCurve(t,y);
fprintf('Process gain: %g, Time constant: %g, Time delay: %g\n',model.gain, model.time_constant, model.time_delay)

% We can compare how good the approximation is.
figure
Ga = tf(model.gain,[model.time_constant 1]);
set(Ga,'InputDelay',model.time_delay')
step(Ga)
hold
plot(t,y,'--','Linewidth',2)
legend('approximation','Process Reaction Curve')

% This example shows that the approximation matches the maximum response
% speed well but overall response speed is slower than original system.
% This is the general behaviour of this approach.

%% PID Tuning
% There are many PID tuning rules around for first-order plus time delay
% systems. The following tuning table was derived by Ziegler-Nichols to
% provide a quarter decay ratio (the ratio of the second peak over the
% first peak). (alpha: time delay, tau: time constant, Kp: gain)
%
% <html>
% <table border=1>
% <tr><td>Controller</td><td>Kc</td><td>Ti</td><td>Td</td></tr>
% <tr><td>P</td><td> tau/(Kp*alpha) </td><td> </td><td> </td></tr>
% <tr><td>PI</td><td> 0.9*tau/(Kp*alpha) </td><td> 3.33*alpha  </td><td> </td></tr>
% <tr><td>PID</td><td> 1.2*tau/(Kp*alpha) </td><td> 2*alpha </td><td> 0.5*alpha </td></tr>
% </table>
% </html>
%
% For the 4th order example, the corresponding controller is derived by the
% ReactionCurve function as follows:
%
% <html>
% <table border=1>
% <tr><td>Controller</td><td>Kc</td><td>Ti</td><td>Td</td></tr>
% <tr><td>P</td><td> 2.4381 </td><td> </td><td> </td></tr>
% <tr><td>PI</td><td> 2.194 </td><td> 6.929 </td><td> </td></tr>
% <tr><td>PID</td><td> 2.929 </td><td> 4.2 </td><td> 1.0497 </td></tr>
% </table>
% </html>

%% The ITAE Tuning Rule
% For comparison, the minimum ITAE approximate model controller tuning
% rules (for setpoint tracking) are presented in the following table.
%
% <html>
% <table border=1>
% <tr><td>Controller</td><td>Kc</td><td>Ti</td><td>Td</td></tr>
% <tr><td>PI</td><td> 0.586/Kp*(tau/alpha)^0.916 </td><td> tau/(1.03-0.165*alpha/tau)  </td><td> </td></tr>
% <tr><td>PID</td><td> 0.965/Kp*(tau/alpha)^0.855 </td><td> tau/(0.796-0.147*alpha/tau) </td><td> 0.308*tau*(alpha/tau)^0.929 </td></tr>
% </table>
% </html>
%
% For the 4th order example, the ITAE PI and PID controllers are:
%
% <html>
% <table border=1>
% <tr><td>Controller</td><td>Kc</td><td>Ti</td><td>Td</td></tr>
% <tr><td>PI</td><td> 1.6681 </td><td> 4.5628 </td><td> </td></tr>
% <tr><td>PID</td><td> 2.5622 </td><td> 5.9532 </td><td> 0.4760 </td></tr>
% </table>
% </html>


%% Closed-Loop Response Comparison
% Let us take the PID controller derived above.
K = controller.PID;
% Connect it with the 4th-order system to form a closed-loop system.
T = feedback(G2*K,1);
% The closed-loop response to a step input is as follows.
[y,t]=step(T);

% Compare it with the ITAE PID controller derived as above
%
k=znpidtuning(G2,3);
K2=2.5622*(1+tf(1,[5.9532 0])+tf([0.4760 0],1));
T2=feedback(G2*K2,1);
y2=step(T2,t);
figure
plot(t,y,'-',t,y2,'--','Linewidth',2)
grid
legend('Approximate Model Tuning','ITAE Tuning')
% Clearly, the ITAE tuning rule gives much better result. 
