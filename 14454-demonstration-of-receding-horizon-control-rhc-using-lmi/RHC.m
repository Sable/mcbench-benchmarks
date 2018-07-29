% Example 6.2: Constrained Receding Horizon Control
% Demonstration of Receding Horizon Control (RHC) using LMI

% ###################################################################
% Edited by Giovani Tonel ( giotonel@enq.ufrgs.br ) March, 28th 2007
% ###################################################################
%
% Retired from the book: 
% Receding Horizon Control - Model Predictive Control for State Models
% Authors: W.H. Kwon and S. Han
% 


clear all
close all
clc
disp(' ');
disp('=================================================================================');
disp(' 	                 Constrained Receding Horizon Control	 ');
disp('=================================================================================');
disp(' ');



%% System State Equation
A	= 	[1 0.2212; 0 0.7788];
B 	= 	[0.0288; 0.2212]; 
G 	=	[1 0; 0 1; 1.5 1];

%% Initial State
x0 		= 	[1;0.3];
[n,n]	=	size(A); 
[n,m]	=	size(B);

% Let's get predictor
N 		= input(' Horizon Length N:' ); 
tsim = input('Total simulation time:');

% Input Constraint
u_lim		=	0.5; 
ubar_lim 	=	[]; 

for i=1:N,
   ubar_lim=[ubar_lim; u_lim];
end

% State Constraint
x_lim 		= 	[1.5; 0.3]; 
G 				=	[1 0; 0 1];
g_lim 		= 	[1.5; 0.3]; 
gbar_lim 	= 	[]; 

for i=1:N,
   gbar_lim	=	[gbar_lim; g_lim];
end

[ng_r, ng_c] = size(G);

% Weighting Matrix
Q 			= 	1*eye(size(A)); 
R 			= 	1;
A_hat	=	[]; 
B_hat	=	[]; 

for i=1:N-1,
   A_hat = daug(A_hat, A);
   B_hat = daug(B_hat, B);
end 

A_hat 	= 	[zeros(n,n*N); A_hat zeros(n*(N-1),n)];
B_hat 	= 	[zeros(n,m*N); B_hat zeros(n*(N-1),m)];
W_hat 	= 	inv(eye(n*N)-A_hat)*B_hat; 
V0_hat =	inv(eye(n*N)-A_hat)*[x0;zeros(n*(N-1),1)];
B_bar=[]; 

for i=1:N,
   B_bar = [B_bar A^(N-i)*B];
end

% Let's get stacked weighting matrix
[m,n]	=	size(Q); 
[p,q] 	= size(R); 
Q_hat 	= []; 
R_hat 	= []; 


for i=1:N,
   Q_hat = daug(Q_hat, Q);
   R_hat = daug(R_hat, R);
end

% Let's get constraint matrix
G_bar = []; 

for i=1:N
   G_bar = daug(G_bar, G);
end

W		=	W_hat'*Q_hat*W_hat + R_hat; 
W		=	(W+W')/2;

% Simulation starts !
t			= []; 
State 	= []; 
U 			= []; 
summed_cost	=	0; 
Summed_cost	=	[];
Cost_at_k		=	[]; 
x = x0;

R1=[]; 
R2=[]; 

for i=0:(tsim-1),
   V0_hat	= 	inv(eye(n*N)-A_hat)*[x;zeros(n*(N-1),1)];
   V 		= 	2*W_hat'*Q_hat*V0_hat;
   V0 		= 	V0_hat'*Q_hat*V0_hat;
   
   %% Solve LMI
   [X,Y,r1,r2,opt_u] = rhc_lmi(x,N,A,B,Q,R,W_hat,V0_hat,Q_hat,B_bar,...
      W,V,V0,G,G_bar,ubar_lim,gbar_lim,u_lim,g_lim);
   
   P = r2*inv(X);
   
   if (i==0),
      boundary0=[];
      for th=0:0.01:2*pi,
         z 				= 	sqrt(r2)*inv(P^0.5)*[cos(th);sin(th)];
         boundary0	=	[boundary0 z];
      end
   elseif(i==1),
      boundary1=[];
      for th=0:0.01:2*pi,
         z = sqrt(r2)*inv(P^0.5)*[cos(th);sin(th)];
         boundary1=[boundary1 z];
      end
   elseif(i==2),
      boundary2=[];
      for th=0:0.01:2*pi,
         z = sqrt(r2)*inv(P^0.5)*[cos(th);sin(th)];
         boundary2=[boundary2 z];
      end
   elseif(i==3),
      boundary3=[];
      for th=0:0.01:2*pi,
         z = sqrt(r2)*inv(P^0.5)*[cos(th);sin(th)];
         boundary3=[boundary3 z];
      end
   elseif(i==4),
      boundary4=[];
      for th=0:0.01:2*pi,
         z = sqrt(r2)*inv(P^0.5)*[cos(th);sin(th)];
         boundary4=[boundary4 z];
      end
   end
   K = Y*inv(X);
   u = opt_u(1);
   State = [State x];
   U = [U u]; 
   
   %% Control Input
   cost_at_k = r1+r2;
   real_cost = x'*Q*x + u'*R*u;
   R1=[R1 r1];
   R2=[R2 r2];
   summed_cost = summed_cost + real_cost;
   Cost_at_k = [Cost_at_k cost_at_k];
   Summed_cost = [Summed_cost summed_cost];
   
   % State Update
   x = A*x + B*u;
   t= [t i+1];
   
   % home;
   disp(' ')
   sprintf('Time: %f',i)
   disp(' ')
      
end

Cost_at_k		=	[Cost_at_k Cost_at_k(tsim)]; 
Summed_cost	=	[	Summed_cost   Summed_cost(tsim)]; 
U					=	[U u]; 
State			=	[State x]; 
t					=	[ 0 t];
R2					=	[R2 R2(tsim)];
R1					=	[R1 R1(tsim)];

% Let's take a look at the simulation results

figure; 
plot(t,State(1,:),'r:',t,State(2,:),'b');
legend('x1','x2',0); 
xlabel('time(sec)');
grid; 
title('States');

if (i>5), figure;
plot(State(1,:),State(2,:),'o',boundary0(1,:),boundary0(2,:),'b',...
boundary1(1,:),boundary1(2,:),'r',...
boundary2(1,:),boundary2(2,:),'k',boundary3(1,:),boundary3(2,:),...
'r',boundary4(1,:),boundary4(2,:),'r'); 
axis([-1.7 1.7 -0.35 0.35]);
legend('States','Bound0','Bound1','Bound2','Bound3','Bound4',0); 
end

figure; stairs(t,U); xlabel('time(sec)');
grid; 
title('control input');
figure; stairs(t,Cost_at_k,'r'); 
xlabel('time(sec)');
grid;
title('Expected cost at time k');
figure; stairs(t,Summed_cost,'b');
grid; 
xlabel('time(sec)');
title('Summed cost');
figure; 
plot(t,R1,'r',t,R2,'b');
