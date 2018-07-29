% Abdel-Razzak Merheb
% Quadrotor simulation
% 15/12/2011
% 28/06/2012
% Quadrotor: AscTec  Pelican  quadrotor UAV 
% The program here reads the gains of the PD controller of the quadrotor
% and use them to control the quadrotor for the desired position. The step
% responses start at different instants. Comparison values (Overshoot, Rise
% time and SS error) are provided for all variables. The program also reads and 
% draws the fitness average and best value given by a search algorithm (discard
% it if no such thing is used)
% % % % % % % % % % % % % % % 
% NOTE NOTE NOTE
% % % % % % % % % % % % % % % 
% The program has to read the Gain values from a 'Gains.mat' file. If this
% file does NOT exists you have to enter the gains manually
% % % % % % % % % % % % % % %
clc
clear all
close all

global Jtp Ixx Iyy Izz b d l m g Kpz Kdz Kpp Kdp Kpt Kdt Kpps Kdps ZdF PhidF ThetadF PsidF ztime phitime thetatime psitime Zinit Phiinit Thetainit Psiinit Uone Utwo Uthree Ufour Ez Ep Et Eps

% Read the gain values
GainsK = importdata('Gains.mat');
Kpz = GainsK(1,1);  % Height P controller
Kdz = GainsK(1,2);  % Height D controller
Kpp = GainsK(1,3);  % Roll P controller
Kdp = GainsK(1,4);  % Roll D controller
Kpt = GainsK(1,5);  % Pitch P controller
Kdt = GainsK(1,6);  % Pitch D controller
Kpps = GainsK(1,7);  % Yaw P controller
Kdps = GainsK(1,8);  % Yaw D controller

% 
% % % Best Gains of the controllers
% 
% Kpp = 30
% Kdp = 5
% 
% Kpt = 30
% Kdt = 5
% 
% Kpps = 30
% Kdps = 5
% 
% Kpz = 40
% Kdz = 12
% % save gains data
% Gains = [Kpz Kdz Kpp Kdp Kpt Kdt Kpps Kdps];
% save('Gains.mat','Gains') % Write the optimal gains in a .mat file

% Quadrotor constants
Ixx = 8.1*10^(-3);  % Quadrotor moment of inertia around X axis
Iyy = 8.1*10^(-3);  % Quadrotor moment of inertia around Y axis
Izz = 14.2*10^(-3);  % Quadrotor moment of inertia around Z axis
Jtp = 104*10^(-6);  % Total rotational moment of inertia around the propeller axis
b = 54.2*10^(5-6);  % Thrust factor
d = 1.1*10^(-6);  % Drag factor
l = 0.24;  % Distance to the center of the Quadrotor
m = 1;  % Mass of the Quadrotor in Kg
g = 9.81;   % Gravitational acceleration

stepsize = 0.01;
t = 0.00000000000000:stepsize:5.00000000000000; % simulation time
% Initial conditions for the Quadrotor
x0 = [];
for i = 1:12,
    x0 = [x0;0];    % Initial position is the origin O(0,0,0), linear and angular velocities/accelerations = 0
end

% Initial values
Zinit = 0;
Phiinit = pi/3;
Thetainit = pi/2;
Psiinit = -pi/5;

x0(1) = 3; % Xinit
x0(3) = 4; % Yinit
x0(5) = Zinit; % Zinit

x0(7) = Phiinit; % Phiinit
x0(9) = Thetainit; % Thetainit
x0(11) = Psiinit; % Psiinit

% Desired values
% Zd = 10*cos(t);
ZdF = 10;
PhidF = pi;
ThetadF = -pi/2;
PsidF = 2*pi;

% Solving the differential equation
options = odeset('OutputFcn','odeplot');   
[t,x] = ode23s(@quad_control_read_fn, t, x0,options);   % this function is faster to find the solution
% ODE15s, ODE23s, and ODE23tb.

% Desired values
Zd = 10;
Phid = pi;
Thetad = -pi/2;
Psid = 2*pi;

% To overcome the error problem:
% Warning: Failure at t=9.999897e-001. Unable to meet integration tolerances without
% reducing the step size below the smallest value allowed (1.776357e-015) at time t.
% We reduce the step size:
% options=odeset('RelTol',1e-10);
% [x,y]=ode45(@fn,[0,1],1,options);

% Plot the path of the Quadrotor in 3-D
figure(1)
plot3(x(:,2),x(:,4),x(:,6))
title('Quadrotor Path in 3-D');
grid
% Plot the motion in x, y and z axes
figure(2)
hold on
plot(t,x(:,1),'bx')
plot(t,x(:,3),'g^')
plot(t,x(:,5),'r.')
hold off
title('Motion in x,y and z axes');
legend('Motion in x-axis','Motion in y-axis','Motion in z-axis');
grid

% Plot the motion in Z-axis
figure(3)
% plot(t,Zd,'b-',t,x(:,5),'r--')
hold on
plot(t,Zd,'r-.')
plot(t,x(:,5),'r--','LineWidth',2)
% legend('Desired motion in Z-axis','Actual motion in z-axis');
hold off
title('Height response');
xlabel('seconds');
ylabel('meters');
grid

% Plot angles' response
figure(4)
hold on
plot(t,Phid,'r',t,x(:,7),'r-.','LineWidth',2)
plot(t,Thetad,'g',t,x(:,9),'g--','LineWidth',2)
plot(t,Psid,'b',t,x(:,11),'b--','LineWidth',2)

hold off
legend('Roll angle in Red','Pitch angle in Green','Yaw angle in Blue');
grid
title('Angle response');
xlabel('seconds');
ylabel('Radians');


% calculate the errors
Z = x(:,5);
Phi = x(:,7);
Theta = x(:,9);
Psi = x(:,11);

Ez = Zd - Z; % find the error in height
Ep = Phid - Phi; % find the error in height
Et = Thetad - Theta; % find the error in height
Eps = Psid - Psi; % find the error in height

% Plot the errors
figure(5)
[p q] = size(Ez);
t3 = 0:0.01:5; % For exp.3
hold on
plot(t3,Ez,'r')
plot(t3,Ep,'g')
plot(t3,Et,'b')
plot(t3,Eps,'k')
hold off
title('Error vectors');
legend('Z error','Phi error','Theta error','Psi error');
grid
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% Variables used to decide the effectiveness of the gains
[a b] = size(Ez);
%     Calculate the overshoot
ZOvershoot = 50;
ROvershoot = 50;
POvershoot = 50;
YOvershoot = 50;
% Height
if (min(Ez) < 0)
    ZOvershoot = abs(min(Ez))*10;  % Height overshoot
end
if (min(Ez) > 0)
    ZOvershoot = 0;  % Height overshoot
end
% Roll
if (min(Ep) < 0)
    ROvershoot = abs(min(Ep))*10;  % Roll overshoot
end
if (min(Ep) > 0)
    ROvershoot = 0;  % Height overshoot
end
% Pitch
if (min(Et) > 0)
    POvershoot = abs(min(-Et))*10;  % Pitch overshoot
end
if (min(Et) < 0)
    POvershoot = 0;  % Height overshoot
end
% Yaw
if (min(Eps) < 0)
    YOvershoot = abs(min(Eps))*10;  % Yaw overshoot
end
if (min(Eps) > 0)
    YOvershoot = 0;  % Height overshoot
end

Overshoot = [ZOvershoot ROvershoot POvershoot YOvershoot]

%     Calculate the steady-state error
Zess = Ez(a);
Ress = Ep(a);
Pess = Et(a);
Yess = Eps(a);

SSError = [Zess Ress Pess Yess]



%     Calculate the rise time
Ztr = 10;
Phitr = 10;
Thetatr = 10;
Psitr = 10;
for i = 1:a
    Ez(i) = Zd - Z(i); % find the error in height
    if abs(Ez(i)) < 0.05
        Ztr = i*stepsize;
        break;
    end
end

for i = 1:a
    Ep(i) = Phid - Phi(i); % find the error in height
    if abs(Ep(i)) < 0.05
        Phitr = i*stepsize;
        break;
    end
end

for i = 1:a
    Et(i) = Thetad - Theta(i); % find the error in height
    if abs(Et(i)) < 0.05
        Thetatr = i*stepsize;
        break;
    end
end

for i = 1:a
    Eps(i) = Psid - Psi(i); % find the error in height
    if abs(Eps(i)) < 0.05
        Psitr = i*stepsize;
        break;
    end
end

Ztr = Ztr - ztime;
Phitr = Phitr - phitime;
Thetatr = Thetatr - thetatime;
Psitr = Psitr - psitime;
 
 
Rise_time = [Ztr Phitr Thetatr Psitr]

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % Calculate the controls in order to draw them
    U1 = m*(g + Kpz*Ez + Kdz*( - x(:,6)))./(cos(x(:,9)).*cos(x(:,7)));   % Total Thrust on the body along z-axis
    U2 = (Kpp*Ep + Kdp*( - x(:,8)));   % Roll input
	U3 = (Kpt*Et + Kdt*( - x(:,10)));   % Pitch input
	U4 = (Kpps*Eps + Kdps*( - x(:,12)));   % Yawing moment
    
    U1 = real(U1);
    U2 = real(U2);
    U3 = real(U3);
    U4 = real(U4);
    
    % Bounding the controls
    [p q] = size(U2);
    for n = 1:p
            % Bounding U1
            if U1(n) > 15.7
                U1(n) = 15.7;
            end
    
            if U1(n) < 0
                U1(n) = 0;
            end
            
            % Bounding U2
            if U2(n) > 1
                U2(n) = 1;
            end
    
            if U2(n) < -1
                U2(n) = -1;
            end
            
            % Bounding U3
            if U3(n) > 1
                U3(n) = 1;
            end
    
            if U3(n) < -1
                U3(n) = -1;
            end
            
            % Bounding U4
            if U4(n) > 1
                U4(n) = 1;
            end
    
            if U4(n) < -1
                U4(n) = -1;
            end
    
    end

    
% Plot the control vector
figure(6)
t2 = 0:0.01:5; % For exp.3
hold on
plot(t2,U1,'r')
plot(t2,U2,'g')
plot(t2,U3,'b')
plot(t2,U4,'k')
hold off
title('Control vectors');
legend('U1 Control','U2 Control','U3 Control','U4 Control');
grid

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

