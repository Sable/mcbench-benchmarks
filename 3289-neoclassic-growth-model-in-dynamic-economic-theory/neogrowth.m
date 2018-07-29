% This is a demonstration of deterministic neoclassical growth model in
% macro economic theory programed for phd course I'm taking in CMU
% for full reference of model See  "Recersive methods in Economi Dynamics", Nancy L stockey and robert E. Lucas. Jr. 
% you can change model parameter for your need
%
% There is no population growth or technology progress
% Labor supply is inelastic
% Method=1----Deterministic, discrete state space model, No interpolation
% Method=2----Deterministic, continuous state space model, With interpolation 
%
% Utility function is util.m
% Production function is cobb.m
% Plotting function vgc_glot.m
% 
% Author Dan Li, Carnegie Mellon University
% Email :  danli@andrew.cmu.edu 
% Homepage  www.danli.org
% April.2003

clc;
clear all; 

% ------Model Parameter specification---------
global gamma alpha
gamma=1;        % risk aversion coefficient, log utility function
alpha=0.3;      % capital share	
beta=0.96;      % discount factor	
delta=.1;       %   depreciation rate	
z=1  ;           % initial state for deteriministic case

method=input(['Method=?,\n'...
             '1 for Deterministic,No interpolation \n' ...
             '2 for Deterministic With Interpolation,\n']);

%------ Parameter of computation--------------------------
nk=input(['Number of grid?(20-200 for Method 1)\n'...
          '(<=30 for Method 2, <=200 for Method 3)>>']);   % number of grid
maxloop=40;         % number of maximum iteration 
tol=10^(-3);        % tolerence level for value function iteration

tic; % start the clock

% ******Low and upper bound of state variable k ******
% Steady state value kstar,   f'(kstar)=1/beta-1+delta

kstar=(((1/(alpha*beta))-((1-delta)/alpha)))^(1/(alpha-1));
lowk=0.8*kstar;
upk=1.2*kstar;

k=linspace(lowk,upk,nk)';  % build up grid
[K,Kprime]=meshgrid(k);

v=zeros(size(k))*ones(size(z));     vn=v;
g=v;     gn=g;	
loop=0;     dv=1;   dk=1;

if method==1
%--------------------------------------
%  No Interpolation Method, Method=1
%---------------------------------------
	C=cobb(K)+(1-delta)*K-Kprime;
	U=util(C);
    
	kpos=100*ones(size(k));% initial value of loop and distance of value

	while dv>tol & loop<=maxloop & dk
        loop=loop+1; 
        [vn,kposn]=max(U+beta*v*ones(1,nk));  %new value vector
        vn=vn'; kposn=kposn';
        dv=max(abs((vn-v)./(v+eps)));
        dk=~all(kpos==kposn); % whether or not position exactly the same
        v=vn; kpos=kposn;
	end
	g=k(kpos);  %  policy  function of next period capital
    
elseif method==2;
%--------------------------------------
%  Interpolation Method, Method=2
%---------------------------------------
   	while dv>tol & dk>tol & loop<=maxloop
	loop=loop+1; 
	pp = spline(k,v);
	vf=inline('-(util(-y+cobb(k)+(1-delta)*k)+beta*ppval(pp,y))','y','k','delta','beta','pp');
		for ik=1:nk 
            [gn(ik),vn(ik)]=fminbnd(vf,lowk,upk,[],k(ik),delta,beta,pp) ;
            vn(ik)=-vn(ik);
		end;
	dk=max(abs((gn-g)./(g+eps)));
    dv=max(abs((vn-v)./(v+eps)));
	v=vn; g=gn;
    end; 
end
%------------------------------------------------------------
% use calculated k g to get consumption policy and plot , save
%--------------------------------------------------------------
%Polc=cobb(k)*z+(1-delta)*k*ones(size(z))-g; %  policy function of consumption
Polc=cobb(k)+(1-delta)*k-g; %  policy function of consumption

vgc_plot(k,kstar,v,Polc,g, method);

%--------------so other output for observation of convergence--------------
t=toc  % read clock
