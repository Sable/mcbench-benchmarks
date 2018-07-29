%%%%%% Robotics mid-term (EOM for a 2 link serial chain manipulator using constraint dynamics)

% Course: Robotic Manipulation and Mobility
% Advisor: Dr. V. Krovi
% 
% Homework Number: MIDTERM
% 
% Names: Sourish Chakravarty 
% 	Hrishi Lalit Shah

% Element 1: Fixed link
% Element 2: Free Link 
% Independent Variable: (Extended Coordinate)-Q=  th1, x2, y2, th2, (Minimal Coordinate)-Z= th1, th2

clc
close all
clear all
%%%%%%%%%%%%%%%%%%%%%%% INPUT
global l1 lc1 m1 j1 tau1 l2 lc2 m2 j2 tau2 g Lambda1 Lambda2 omega zeta

l1= 2 ;% (m)Length of element 1
lc1= 1 ;%(m) Distance of CM of element 1 from source end
m1= 10;% (kg) Mass of element 1
j1= 3;% (kg-m^2) Moment of Inertia of element 1 about its CM
tau1=0;% (N-m) External torque applied on element 1

l2= 1;% (m)Length of element 2
lc2= 0.5;% (m)Distance of CM of element 2 from source end
m2= 6;% (kg) Mass of element 2
j2= 2;% (kg-m^2)Moment of Inertia of element 2 about its CM
tau2=0;% (N-m)External torque applied on element 2

g= 9.81; % (m/sec^2) Acceleration due to gravity
Lambda1 =[]; % Initialise Lambda to null (Without constraint stabilization)
Lambda2 =[]; % Initialise Lambda to null (With constraint stabilization)

%%%%%%%% Initial condition % Q =[th1, x2, y2, th2]'
th1_0= 45*pi/180; % Radian
th2_0= -50*pi/180; % Radian
x2_0 = 1.65; % l1*cos(th1_0)+lc2*cos(th2_0);%1.65 % (m)
y2_0 = 0.8; % l1*sin(th1_0)+lc2*sin(th2_0);%0.8 % (m)
% Assuming system is at rest at t=0
th1d_0=0; %Degree/s
th2d_0=0; %Degree/s
x2d_0 =0; % m/s
y2d_0 =0; % m/s

Tspan =[0, 10]; % (sec) Time Span


%%%%%%%%%%%%%%%%%%%%%%% CASE- 1: PROJECTION ONTO FEASIBLE MOTION SPACE

options = odeset('RelTol',1e-4,'AbsTol',[1e-5 1e-5 1e-5 1e-5 1e-5 1e-5]);
[T1,Y1] = ode45(@ROBO_f1,Tspan,[th1_0 x2_0 y2_0 th2_0 th1d_0 th2d_0],options);

th11=Y1(:,1);
x21=Y1(:,2);
y21=Y1(:,3);
th21=Y1(:,4);

figure(1)
subplot(2,1,1);
plot(T1,th11);
% title('Case-1(A)- Theta1 vs Time plot)');
xlabel('Time (sec)');
ylabel('Theta1 (Radians)');
title('CASE-1: Projection onto Feasible Motion Space');

subplot(2,1,2);
plot(T1,th21);
% title('Case-1(A)- Theta2 vs Time plot)');
xlabel('Time (sec)');
ylabel('Theta2 (Radians)');


Cerr1=CONSTRAINT_ERROR_1(th11,x21,y21,th21);

figure(2)
% title('Projection onto Feasible Motion Space with initial constraint violation');
subplot(2,1,1);
plot(T1,log(Cerr1(:,1)));
title('Case-1: X-constraint violation');
xlabel('Time (sec)');
ylabel('log(Cerr1,x)');

subplot(2,1,2);
plot(T1,log(Cerr1(:,2)));
title('Case-1: Y-constraint violation');
xlabel('Time (sec)');
ylabel('log(Cerr1,y)');

% aviobj1 = avifile('ROBO_1_anime.avi','compression','Cinepak'); % Declare an avi object
% h=figure(3);
% title('Projection onto Feasible motion space');
% [aviobj1]= CREATE_ANIME_1(aviobj1,T1,th11,x21,y21,th21,h);% Calls function to create animation
% aviobj1 = close(aviobj1)  % Close the avi object

...............................................................................
%%%%%%%%%%%%%%%%%%%%%%% CASE-2(A) - PROJECTION ONTO CONSTRAINED FORCE SPACE
%%%%%%%%%%%%%%%%%%%%%%% WITHOUT CONSTRAINT STABILIZATION

options = odeset('RelTol',1e-4,'AbsTol',1e-5*ones(1,8));
[T2,Y2] = ode45(@ROBO_f2,Tspan,[th1_0 x2_0 y2_0 th2_0 th1d_0 x2d_0 y2d_0 th2d_0],options);

th12=Y2(:,1);
th22=Y2(:,4);
x22=Y2(:,2);
y22=Y2(:,3);

Lambda1;
figure(4)
subplot(2,1,1);
plot(T2,th12);
% title('Case-1(A)- Theta1 vs Time plot)');
xlabel('Time (sec)');
ylabel('Theta1 (Radians)');
title('CASE-2(A): Projection onto constrained force space without constraint stabilization');

subplot(2,1,2);
plot(T2,th22);
% title('Case-1(A)- Theta2 vs Time plot)');
xlabel('Time (sec)');
ylabel('Theta2 (Radians)');



Cerr2=CONSTRAINT_ERROR_1(th12,x22,y22,th22);
figure(5)
subplot(2,1,1);
plot(T2,log(Cerr2(:,1)));
title('Case-2(A): X-constraint violation');
xlabel('Time (sec)');
ylabel('log(Cerr2,x)');

subplot(2,1,2);
plot(T2,log(Cerr2(:,2)));
title('Case-2(A): Y-constraint violation');
xlabel('Time (sec)');
ylabel('log(Cerr2,y)');


% aviobj2 = avifile('ROBO_2_anime.avi','compression','Cinepak'); % Declare an avi object
% h=figure(6)
% title('Projection onto constrained force space without stabilization');
% [aviobj2]= CREATE_ANIME_1(aviobj2,T2,th12,x22,y22,th22,h);% Calls function to create animation
% aviobj2 = close(aviobj2)  % Close the avi object

...........................................................................................
%%%%%%%%%%%%%%%%%%%%%%% CASE-2(B)- PROJECTION ONTO CONSTRAINED FORCE SPACE USING
%%%%%%%%%%%%%%%%%%%%%%% CONSTRAINT STABILIZATION

omega = 10; %%% Frequency
zeta = 10; %%% Damping Coefficient

options = odeset('RelTol',1e-4,'AbsTol',1e-5*ones(1,8));
[T3,Y3] = ode45(@ROBO_f3,Tspan,[th1_0 x2_0 y2_0 th2_0 th1d_0 x2d_0 y2d_0 th2d_0],options);

th13=Y3(:,1);
th23=Y3(:,4);
x23=Y3(:,2);
y23=Y3(:,3);

Lambda2;
figure(7)
subplot(2,1,1);
plot(T3,th13);
% title('Case-1(A)- Theta1 vs Time plot)');
xlabel('Time (sec)');
ylabel('Theta1 (Radians)');
title('CASE-2(B): Projection onto constrained force space with constraint stabilization');

subplot(2,1,2);
plot(T3,th23);
% title('Case-1(A)- Theta2 vs Time plot)');
xlabel('Time (sec)');
ylabel('Theta2 (Radians)');



Cerr3=CONSTRAINT_ERROR_1(th13,x23,y23,th23);
figure(8)
subplot(2,1,1);
plot(T3,log(Cerr3(:,1)));
title('Case-2(B): X-constraint violation');
xlabel('Time (sec)');
ylabel('log(Cerr3,x)');

subplot(2,1,2);
plot(T3,log(Cerr3(:,2)));
title('Case-2(B): Y-constraint violation');
xlabel('Time (sec)');
ylabel('log(Cerr3,y)');


% aviobj3 = avifile('ROBO_3_anime.avi','compression','Cinepak'); % Declare an avi object
% h=figure(9)
% title('Projection onto constrained force Space with constraint stabilization')
% [aviobj3]= CREATE_ANIME_1(aviobj3,T3,th13,x23,y23,th23,h);% Calls function to create animation
% aviobj3 = close(aviobj3)  % Close the avi object

..........................................................................
%%%%%% End of program