%% Dynamic Matrix Control Tutorial
% Dynamic Matrix Control (DMC) was the first Model Predictive Control (MPC)
% algorithm introduced in early 1980s. Nowadays, DMC is available in almost
% all commercial industrial distributed control systems and process
% simulation software packages. This tutorial intends to explain the
% features of DMC using the dmc function developed by the author.

%% Example: A Water Heater
% Consider a water heater as shown in the following figure, where the cold
% water is heated by means of a gas burner. The aim of DMC is by
% manipulating valve to control the gas flow so that the outlet temperature
% is at desired level.
%%
% 
% <<WaterHeater.PNG>>
% 

%% The Step Response Model
% The DMC algorithm works with a step response model. The first step to
% design a DMC controller is to perform a step test on the plant to
% generate a step response model. The step response of the water heater is
% obtained through such a test and given as follows:
p.sr = [0;0;0.271;0.498;0.687;0.845;0.977;1.087;1.179;1.256;...
        1.320;1.374;1.419;1.456;1.487;1.513;1.535;1.553;1.565;1.581;...
        1.592;1.600;1.608;1.614;1.619;1.632;1.627;1.630;1.633;1.635];

% The response is converged after 30 steps.

%% DMC without Setpoint Prediction
% Setup the DMC
N=120;  % Total simulation length (samples)
p.p=10; % Prediction horizon
p.m=5;  % Moving horizon
p.la=1; % Control weight
% Reference (setpoint)
R=[ones(30,1);zeros(30,1);ones(30,1);zeros(30,1)];
p.y=0;  % Initial output
p.v=[]; % empty past input to indicate initialization
% buffer of input to cope with time delay
u=zeros(3,1);
% Initialization of variables for results
Y=zeros(N,1);
U=zeros(N,1);
% DMC Simulation
for k=1:120
    p.a=0;
    p.r=R(k);   % DMC only knows current setpoint
    if k>60     % change smoothing factor for second half simulation
        p.a=0.7;
    end
    p=dmc(p);
    Y(k)=p.y;
    U(k)=p.u;
    u=[u(2:3);p.u];
    p.y=0.8351*p.y+0.2713*u(1); % actual plant output 
end
% DMC results
subplot(211)
plot(1:N,Y,'b-',1:N,R,'r--',[60 60],[-0.5 1.5],':','linewidth',2)
title('solid: output, dashed: reference')
text(35,1,'\alpha=0')
text(95,1,'\alpha=0.7')
axis([0 120 -0.5 1.5])
subplot(212)
[xx,yy]=stairs(1:N,U);
plot(xx,yy,'-',[60 60],[-0.5 1.5],':','linewidth',2)
axis([0 120 -0.5 1.5])
title('input, \lambda=1')
xlabel('time, min')

%% DMC with Setpoint Prediction
% Setup the DMC
N=120;  % Total simulation length (samples)
p.p=10; % Prediction horizon
p.m=5;  % Moving horizon
p.la=1; % Control weight
% Reference (setpoint)
R=[ones(30,1);zeros(30,1);ones(30,1);zeros(30,1)];
p.y=0;  % Initial output
p.v=[]; % empty past input to indicate initialization
% buffer of input to cope with time delay
u=zeros(3,1);
% Initialization of variables for results
Y=zeros(N,1);
U=zeros(N,1);
% DMC Simulation
for k=1:120
    p.a=0;
    p.r=R(k:min(N,k+p.p)); % DMC knows future setpoint
    if k>60     % change smoothing factor for second half simulation
        p.a=0.7;
    end
    p=dmc(p);
    Y(k)=p.y;
    U(k)=p.u;
    u=[u(2:3);p.u];
    p.y=0.8351*p.y+0.2713*u(1); % actual plant output 
end
% DMC results
subplot(211)
plot(1:N,Y,'b-',1:N,R,'r--',[60 60],[-0.5 1.5],':','linewidth',2)
title('solid: output, dashed: reference')
text(35,1,'\alpha=0')
text(95,1,'\alpha=0.7')
axis([0 120 -0.5 1.5])
subplot(212)
[xx,yy]=stairs(1:N,U);
plot(xx,yy,'-',[60 60],[-0.5 1.5],':','linewidth',2)
axis([0 120 -0.5 1.5])
title('input, \lambda=1')
xlabel('time, min')

%% DMC with Different Control Weight
% Setup the DMC
N=120;  % Total simulation length (samples)
p.p=10; % Prediction horizon
p.m=5;  % Moving horizon
p.la=0.1; % Control weight
% Reference (setpoint)
R=[ones(30,1);zeros(30,1);ones(30,1);zeros(30,1)];
p.y=0;  % Initial output
p.v=[]; % empty past input to indicate initialization
% buffer of input to cope with time delay
u=zeros(3,1);
% Initialization of variables for results
Y=zeros(N,1);
U=zeros(N,1);
% DMC Simulation
for k=1:120
    p.a=0;
    p.r=R(k:min(N,k+p.p)); % DMC knows future setpoint
    if k>60     % change smoothing factor for second half simulation
        p.a=0.7;
    end
    p=dmc(p);
    Y(k)=p.y;
    U(k)=p.u;
    u=[u(2:3);p.u];
    p.y=0.8351*p.y+0.2713*u(1); % actual plant output 
end
% DMC results
subplot(211)
plot(1:N,Y,'b-',1:N,R,'r--',[60 60],[-0.5 1.5],':','linewidth',2)
title('solid: output, dashed: reference')
text(35,1,'\alpha=0')
text(95,1,'\alpha=0.7')
axis([0 120 -0.5 1.5])
subplot(212)
[xx,yy]=stairs(1:N,U);
plot(xx,yy,'-',[60 60],[-0.5 1.5],':','linewidth',2)
axis([0 120 -1 2])
title('input, \lambda=0.1')
xlabel('time, min')

%% Reference
% Camacho, E.F. and Bordons, C., Model Predictive Control, Springer-Verlag,
% 1999.
