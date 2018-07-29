% This Matlab code simulates a PID controller for a fisrt order time delay system 
% G(s) = (K*e(-theta*s))/(T*s+1)

% Derick Suranga Widanalage
% Graduate Student
% Faculty of Engineering and Applied Sciences
% Memorial University of Newfoundland
% St John's, NL, A1B3X5
% Canada

clear all; clc;


T=360; K=14.9; theta= 80;  % System Parameters
refe = 10;                 % Reference to follow
Tf = 1000;                 % Simulation time
yold = 0;yold1=0;
yp = []; ys_prime = [];
er = refe;                 % Error (Initial error = Reference)       
er1 = 0;                   % First derivative of error
er2 = 0;                   % Second derivative of error
eold = refe; eold2 = 0;
dt = 1;
for i=1:dt:Tf
    dtspan = [i i+dt];
    eold2 = eold ;
    eold = er;
    er = refe - yold;
    er2 = er + eold2 - 2*eold;
    er1 = er - eold;
    init_con = [yold ; (yold-yold1)]; % Initial conditions for the diffirential equations
    options = [];
    [t,y]  = ode45(@pid_ctrl,dtspan,init_con,options,er,er1,er2); 
    yold1 = yold;
    ys = y(length(y),1);
    if i <= theta
        ys_prime = [0 ys_prime];
    else
        ys_prime = [ys ys_prime];
    end
    yold = ys_prime(1);
    yp = [yp yold];
end

plot(yp);
xlabel('Time');
ylabel('Output');
title('Output of the system with PID Controller');
grid on;



