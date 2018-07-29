%
%  MODEL REDUCTION BY THE ALGORITHMS LRSRM AND DSPMR. THE GOAL IS TO
%  GENERATE A "NUMERICALLY MINIMAL REALIZATION" OF THE GIVEN SYSTEM
%  AS WELL AS A REDUCED SYSTEM OF RELATIVELY SMALL ORDER. 
%
%  This demo program shows how the model reduction routines 'lp_lrsrm'
%  and 'lp_dspmr' work. Also, the use of 'lp_lradi', supplementary 
%  routines, and user-supplied functions is demonstrated.

% ----------------------------------------------------------------------- 
% Generate test problem 
% ----------------------------------------------------------------------- 
%
% As test example, we use an FEM-semidiscretized problem, which leads to
% a generalized system where M (the mass matrix) and N (the negative
% stiffness matrix) are sparse, symmetric, and definite. 

load rail821   % load the matrices M N Btilde Ctilde of the generalized
               % system

%load rail3113   % Uncomment this to get an example of larger order.

disp('Problem dimensions:')

n = size(M,1)   % problem order (number of states)
m = size(Btilde,2)   % number of inputs
q = size(Ctilde,1)   % number of outputs

% ----------------------------------------------------------------------- 
% Initialization/generation of data structures used in user-supplied 
% functions and computation of ADI shift parameters
% ----------------------------------------------------------------------- 
%
% See 'demo_u1', 'demo_u2', 'demo_u3', and 'demo_l1' for more detailed
% comments.

name = 'msns'; 
[M0,MU,N0,B0,C0,prm,iprm] = msns_pre(M,N,Btilde,Ctilde);  % preprocessing
msns_m_i(M0,MU,N0);   % initialization for multiplication with A0
msns_l_i;   % initialization for solving systems with A0

disp('Parameters for heuristic algorithm which computes ADI parameters:')
l0 = 20   % desired number of distinct shift parameters                  
kp = 50   % number of steps of Arnoldi process w.r.t. A0
km = 25   % number of steps of Arnoldi process w.r.t. inv(A0)

b0 = ones(n,1);   % This is just one way to choose the Arnoldi start 
                  % vector. 

p = lp_para(name,[],[],l0,kp,km,b0);   % computation of ADI shift 
                                       % parameters

disp('Actual number of ADI shift parameters:');
l = length(p)

disp('ADI shift parameters:');
p

msns_s_i(p)   % initialization for shifted systems of linear equations 
              % with A0+p(i)*I  (i = 1,...,l)


% ----------------------------------------------------------------------- 
% Solution of Lyapunov equations A0*X0+X0*A0' = -B0*B0' and
% A0'*X0+X0*A0 = -C0'*C0
% ----------------------------------------------------------------------- 

disp('Parameters for stopping criteria in LRCF-ADI iteration:')
max_it = 200   % (large value)
min_res = 0   % (avoided)
with_rs = 'S'   % ("activated")
min_in = 0   % (avoided)

zk = 'Z';
rc = 'C';
Bf = [];
Kf = [];
info = 3;

disp('... solving A0*XB0+XB0*A0'' = - B0*B0''...');
tp = 'B';

figure(1), hold off; clf;   % (lp_lradi will plot residual history.)

[ZB0,flag_B] = lp_lradi(tp,zk,rc,name,Bf,Kf,B0,p,max_it,min_res,...
               with_rs,min_in,info);  
                                       % compute ZB0

title('LRCF-ADI for CALE  A_0X_{B0}+X_{B0}A_0^T = -B_0B_0^T')
disp('Termination flag:')
flag_B 
disp('Size of ZB0:');
size_ZB0 = size(ZB0)

disp('... solving A0''*XC0+XC0*A0 = - C0''*C0...');
tp = 'C';

figure(2), hold off; clf;   % (lp_lradi will plot residual history.)

[ZC0,flag_C] = lp_lradi(tp,zk,rc,name,Bf,Kf,C0,p,max_it,min_res,...
               with_rs,min_in,info);  
                                       % compute ZC0

title('LRCF-ADI for CALE  A_0^T X_{C0} + X_{C0} A_0 = -C_0^TC_0')
disp('Termination flag:')
flag_C 
disp('Size of ZC0:');
size_ZC0 = size(ZC0)


% ----------------------------------------------------------------------- 
% Plot the transfer function of the system for a certain frequency range
% ----------------------------------------------------------------------- 

disp('... computing transfer function of original system ...'); 

freq = lp_lgfrq(1e-10,1e10,200);   % generate a set of 200 "frequency
                                   % sampling points" in the interval
                                   % [10^-10,10^+10]. 
G = lp_trfia(freq,N,Btilde,Ctilde,[],M);   % compute "transfer function 
                                           % sample" for these frequency 
                                           % points
nrm_G = lp_gnorm(G,m,q);   % compute norms of the "transfer function
                           % sample" for these frequency points
                           
figure(3); hold off; clf; 
loglog(freq,nrm_G,'k:'); 
xlabel('\omega');
ylabel('Magnitude');
t_text = 'dotted: ||G||';
title(t_text);
pause(1)


% ----------------------------------------------------------------------- 
% Generate reduced systems of high accuracy and possibly high order
% ----------------------------------------------------------------------- 

disp(' ')
disp('Generate reduced systems of high accuracy and possibly high order')
disp('-----------------------------------------------------------------')

disp('Parameters for model reduction:')
max_ord = []   % (avoided)
tol = 1e-14   % (This criterion determines the reduced order. The very 
              % small value is chosen to generate a "numerically minimal 
              % realization".)


disp('... computing reduced system by LRSRM ...');
[Ars,Brs,Crs] = lp_lrsrm(name,B0,C0,ZB0,ZC0,max_ord,tol);   % run LRSRM

disp('Reduced order:')
disp(length(Ars))

Grs = lp_trfia(freq,Ars,Brs,Crs,[],[]);   % compute "transfer function
                                          % sample" for reduced system
nrm_dGrs = lp_gnorm(G-Grs,m,q);   % compute norm of DIFFERENCE of 
                                  % transfer function samples of original 
                                  % and reduced system.
figure(3); hold on
loglog(freq,nrm_dGrs,'r-'); 
t_text = [t_text, ',    solid: ||G-G_{LRSRM}||'];
title(t_text); pause(1)


disp('... computing reduced system by DSPMR ...');
[Ard,Brd,Crd] = lp_dspmr(name,B0,C0,ZB0,ZC0,max_ord,tol);   % run DSPMR

disp('Reduced order:')
disp(length(Ard))

Grd = lp_trfia(freq,Ard,Brd,Crd,[],[]);   % compute "transfer function
                                          % sample" for reduced system
nrm_dGrd = lp_gnorm(G-Grd,m,q);   % compute norm of DIFFERENCE of 
                                  % transfer function samples of original 
                                  % and reduced system.
figure(3); hold on
loglog(freq,nrm_dGrd,'b--'); pause(1)
t_text = [t_text, ',    dashed: ||G-G_{DSPMR}||'];
title(t_text); pause(1)


% ----------------------------------------------------------------------- 
% Generate reduced systems of low order
% ----------------------------------------------------------------------- 

disp(' ')
disp('Generate reduced systems of low order')
disp('-------------------------------------')

disp('Parameters for model reduction:')
max_ord = 25   % (This criterion determines the reduced order.)
tol = 0    % (avoided)


disp('... computing reduced system by LRSRM ...');
[Ars,Brs,Crs] = lp_lrsrm(name,B0,C0,ZB0,ZC0,max_ord,tol);   % run LRSRM

disp('Reduced order:')
disp(length(Ars))

Grs = lp_trfia(freq,Ars,Brs,Crs,[],[]);   % compute "transfer function
                                          % sample" for reduced system
nrm_dGrs = lp_gnorm(G-Grs,m,q);   % compute norm of DIFFERENCE of 
                                  % transfer function samples of original 
                                  % and reduced system.
figure(3); hold on
loglog(freq,nrm_dGrs,'r-'); 


disp('... computing reduced system by DSPMR ...');
[Ard,Brd,Crd] = lp_dspmr(name,B0,C0,ZB0,ZC0,max_ord,tol);   % run DSPMR

disp('Reduced order:')
disp(length(Ard))

Grd = lp_trfia(freq,Ard,Brd,Crd,[],[]);   % compute "transfer function
                                          % sample" for reduced system
nrm_dGrd = lp_gnorm(G-Grd,m,q);   % compute norm of DIFFERENCE of 
                                  % transfer function samples of original 
                                  % and reduced system.
figure(3); hold on
loglog(freq,nrm_dGrd,'b--'); 


% ----------------------------------------------------------------------- 
% Destroy global data structures
% ----------------------------------------------------------------------- 

msns_m_d;
msns_l_d;
msns_s_d(p);



