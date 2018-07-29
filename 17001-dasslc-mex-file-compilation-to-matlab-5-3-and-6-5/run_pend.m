% Dasslc test problem with classical pendulum
% requires files: pend.m

dae_index = 3;		% differential index of the DAE
g   = 9.8;			% gravity acceleration
L	 = 1.0;			% pendulum cord lenght
t0  = 0.0;        % initial value for independent variable
tf  = 10;         % final value for independent variable
y0  = [1 0 0 0 0]'; % initial state variables (overwritten by pend.dat)
rpar=[g L dae_index]; % optional arguments passed to residual and jacobian functions

index = [0 0 0 0 0	% index 0 formulation (with drift-off effect)
		   1 1 1 1 1	% index 1 formulation
			1 1 2 2 2	% index 2 formulation
         1 1 2 2 3];	% index 3 formulation

tspan=[t0:0.001:tf];
[t,y]=dasslc('pend',tspan,y0,rpar,[],[],index(dae_index+1,:),'pend.dat','jacpend');

plot(t,y);
