function [X_opt,Y_opt,r1_opt,r2_opt,u_opt] = rhc_lmi(x,N,A,B,Q,R,W_hat,V0_hat,Q_hat,B_bar,W,V,V0,G,G_bar,...
   ubar_lim,gbar_lim,u_lim,g_lim)
% Function: rhc_lmi.m
%
% LMI Variable = X, Y, r1, r2, U
%
%
% ###################################################################
% Edited by Giovani Tonel ( giotonel@enq.ufrgs.br ) March, 28th 2007
% ###################################################################


[n,n]						=	size(A); 
[n,nu]						=	size(B); 
[nG_r, nG_c]			= size(G); 
[nglim_r,nglim_c]	= size(g_lim);

if (~isempty(G_bar)),
   GW 	= 	G_bar*W_hat;
   gg1 	= 	gbar_lim + G_bar*V0_hat;
   gg2 	= 	gbar_lim-G_bar*V0_hat;
end 

[nGW_r,nGW_c] = size(GW);
setlmis([]);

% LMI Variable
r1 	= lmivar(1,[1 0]); 
r2 	= lmivar(1,[1 0]); 
X 		= lmivar(1,[n 1]); 
Y		= lmivar(2,[nu n]); 
Z 		= lmivar(1,[nu 1]); 
U 		= lmivar(2,[N*nu 1]);
VV 	= lmivar(1,[nglim_r 1]);


lmiterm([-1 1 1 r1], 1, 1); 
lmiterm([-1 1 1 U],  0.5*V',1,'s');
lmiterm([-1 1 1 0], -V0); 						%% (1,1) = r1-V'*U -V0
lmiterm([-1 2 1 U], W^0.5, 1); 				%% (2,1) = W^0.5*U
lmiterm([-1 2 2 0], 1); 						%% (2,2) = I
lmiterm([-2 1 1 0], 1); 							%% (1,1) = 1
lmiterm([-2 2 1 0], A^N*x); 					%% (2,1) = A^N*x
lmiterm([-2 2 1 U], B_bar,1); 				%% (2,1) = A^N*x + B_bar*U
lmiterm([-2 2 2 X], 1,1); 						%% (2,2) = X
lmiterm([-3 1 1 X], 1, 1); 					%% (1,1) = X
lmiterm([-3 2 2 X], 1, 1); 					%% (2,2) = X
lmiterm([-3 3 3 r2], 1,1); 					%% (3,3) = r2*I
lmiterm([-3 4 4 r2], 1, 1); 					%% (4,4) = r2*I
lmiterm([-3 2 1 X], A, 1);
lmiterm([-3 2 1 Y], B, 1);  					%% (2,1) = A*X + B*Y
lmiterm([-3 3 1 X], real(Q^0.5), 1); 	%% (3,1) = Q^0.5*X
lmiterm([-3 4 1 Y], R^0.5, 1); 				%% (4,1) = R^0.5*X

% Constraint on u during the horizon from 0 to N-1
Ucon_LMI_1 = newlmi; 

for i=1:N*nu,
   tmp = zeros(nu*N,1);
   tmp(i,1) = 1;
   
   %% U(i) >= -ubar_lim(i)
   lmiterm([-(Ucon_LMI_1+i-1) 1 1 U], 0.5*tmp',1,'s');
   lmiterm([-(Ucon_LMI_1+i-1) 1 1 0], ubar_lim(i));
   
   % U(i) <= ubar_lim(i)
   lmiterm([(Ucon_LMI_1+N*nu+i-1) 1 1 U], 0.5*tmp', 1,'s');
   lmiterm([(Ucon_LMI_1+N*nu+i-1) 1 1 0], -ubar_lim(i));
   
   
end

% Constraint on u after the horizon N

Ucon_LMI_2 = newlmi;
lmiterm([-Ucon_LMI_2 1 1 Z], 1,1); %% (1,1) = Z
lmiterm([-Ucon_LMI_2 1 2 Y], 1,1); %% (1,2) = Y
lmiterm([-Ucon_LMI_2 2 2 X], 1,1); %% (2,2) = X
Ucon_LMI_3 = newlmi; 

for i=1:nu,
   tmp = zeros(nu,1);
   tmp(i,1) = 1;
   lmiterm([(Ucon_LMI_3+i-1) 1 1 Z], tmp', tmp);
   
   %% (1,1) Z(i,i) <= u_lim(i)^2
   lmiterm([(Ucon_LMI_3+i-1) 1 1 0], -u_lim(i)^2);
   
end


% Constraint on x during the horizon from 0 to N-1

if (~isempty(G_bar)),
   Xcon_LMI1 = newlmi;
   for i=1:nGW_r,
      %% (1,1) GW*U + gg1 > = 0
      lmiterm([-(Xcon_LMI1+i-1) 1 1 U], 0.5*GW(i,:),1,'s');
      lmiterm([-(Xcon_LMI1+i-1) 1 1 0], gg1(i));
      
      %% (1,1) -GW*U + gg2 >= 0
      lmiterm([-(Xcon_LMI1+nGW_r+i-1) 1 1 U], -0.5*GW(i,:),1,'s')
      lmiterm([-(Xcon_LMI1+nGW_r+i-1) 1 1 0], gg2(i));
   end
end

% Constraint on x after the horizon N

if (~isempty(G)),
   X_con_LMI2 = newlmi;
   lmiterm([X_con_LMI2 1 1 X], G, G');
   lmiterm([X_con_LMI2 1 1 VV], -1, 1); %% (1,1) G*X*G' <= VV
   
   for i=1:nglim_r,
      tmp = zeros(nglim_r,1);
      tmp(i,1) = 1;
      lmiterm([(X_con_LMI2+i) 1 1 VV], tmp',tmp);
      %% (1,1) VV(i,i) <= g_lim(i)^2
      lmiterm([(X_con_LMI2+i) 1 1 0], -g_lim(i)^2);
   end
end

rhclmi = getlmis;

% Now we're ready to solve LMI
n_lmi = decnbr(rhclmi); 
c = zeros(n_lmi,1); 

for j=1:n_lmi,
   [r1j, r2j]= defcx(rhclmi,j,r1,r2);
   c(j) = r1j + r2j;
end

[copt, Uopt]= mincx(rhclmi, c', [1e-6 300 0 0 0]);

u_opt 	= dec2mat(rhclmi, Uopt, U); 
r1_opt 	= dec2mat(rhclmi, Uopt, r1); 
r2_opt 	= dec2mat(rhclmi, Uopt, r2); 
X_opt 	= dec2mat(rhclmi, Uopt, X); 
Y_opt 	= dec2mat(rhclmi, Uopt, Y);

