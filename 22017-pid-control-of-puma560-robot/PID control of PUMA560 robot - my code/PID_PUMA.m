

% PID control of a 3DOF PUMA 560 Robot
% 
% Name: Abdel-Razzak MERHEB
% Date: 5 Oct. 2008
%

clear all
close all

global teta1 teta2 teta3 told
global xdot z perror2 pderror perror desiredteta teta olderror deltat


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

xdot = [0 0 0 0 0 0; 0 0 0 0 0 0];

% initial conditions
teta0 = [0 0 0 0 0 0];    % teta
dteta0 = [0 0 0 0 0 0];   % dteta


% make the initial condition vector needed for the ode function (it has to be only one column)
for i = 1:1:6
    init0(i)=teta0(i);    %first 6 elements of the vector are the displacement vector's elements
end

for i = 1:1:6
    init0(i+6)=dteta0(i); %second 6 elements of the vector are the velocity vector's elements
end

x0 = init0'; %x0 is a one-column initial condition vector


t=0:1:10; %simulation time


[t,teta]=ode15s('PID_PUMA_fn',t,x0);  % solve the differential equation

% plot the joint's displacement and velocity paths
figure
plot(t,teta)
 
 
