%
%  MODEL REDUCTION BY THE ALGORITHMS LRSRM AND DSPMR. THE GOAL IS TO
%  GENERATE A REDUCED SYSTEM OF VERY SMALL ORDER.
%
%  This demo program shows how the model reduction routines 'lp_lrsrm'
%  and 'lp_dspmr' work. Also, the use of 'lp_lradi', supplementary 
%  routines, and user-supplied functions is demonstrated.

% ----------------------------------------------------------------------- 
% Generate test problem 
% ----------------------------------------------------------------------- 
%
% This is an artificial test problem of a system, whose Bode plot shows
% "spires".

A = sparse(408,408); B = ones(408,1); C = ones(1,408);
A(1:2,1:2) = [-.01 -200; 200 .001]; 
A(3:4,3:4) = [-.2 -300; 300 -.1]; 
A(5:6,5:6) = [-.02 -500; 500 0]; 
A(7:8,7:8) = [-.01 -520; 520 -.01]; 
A(9:408,9:408) = spdiags(-(1:400)',0,400,400);

disp('Problem dimensions:')

n = size(A,1)   % problem order (number of states)
m = size(B,2)   % number of inputs
q = size(C,1)   % number of outputs

% ----------------------------------------------------------------------- 
% Initialization/generation of data structures used in user-supplied 
% functions and computation of ADI shift parameters
% ----------------------------------------------------------------------- 
%
% See 'demo_u1', 'demo_u2', 'demo_u3', and 'demo_l1' for more detailed
% comments.
%
% Note that A is a tridiagonal matrix. No preprocessing needs to be done.

name = 'au'; 
au_m_i(A);   % initialization for multiplication with A
au_l_i;   % initialization for solving systems with A

disp('Parameters for heuristic algorithm which computes ADI parameters:')
l0 = 10   % desired number of distinct shift parameters                  
kp = 30   % number of steps of Arnoldi process w.r.t. A
km = 15   % number of steps of Arnoldi process w.r.t. inv(A)

b0 = ones(n,1);   % This is just one way to choose the Arnoldi start 
                  % vector. 

p = lp_para(name,[],[],l0,kp,km,b0);   % computation of ADI shift 
                                       % parameters

disp('Actual number of ADI shift parameters:');
l = length(p)

disp('ADI shift parameters:');
p

au_s_i(p)   % initialization for shifted systems of linear equations 
            % with A+p(i)*I  (i = 1,...,l)


% ----------------------------------------------------------------------- 
% Solution of Lyapunov equations A*X+X*A' = -B*B' and
% A'*X+X*A = -C'*C
% ----------------------------------------------------------------------- 

disp('Parameters for stopping criteria in LRCF-ADI iteration:')
max_it = 20   % (will stop the iteration)
min_res = 1e-100   % (avoided, but the residual history is shown)
with_rs = 'N'   % (avoided)
min_in = 0   % (avoided)

zk = 'Z';
rc = 'C';
Bf = [];
Kf = [];
info = 3;

disp('... solving A*XB+XB*A'' = - B*B''...');
tp = 'B';

figure(1), hold off; clf;   % (lp_lradi will plot residual history.)

[ZB,flag_B] = lp_lradi(tp,zk,rc,name,Bf,Kf,B,p,max_it,min_res,...
              with_rs,min_in,info);  
                                       % compute ZB

title('LRCF-ADI for CALE  AX_{B}+X_{B}A^T = -BB^T')
disp('Termination flag:')
flag_B 
disp('Size of ZB:');
size_ZB = size(ZB)

disp('... solving A''*XC+XC*A = - C''*C...');
tp = 'C';

figure(2), hold off; clf;   % (lp_lradi will plot residual history.)

[ZC,flag_C] = lp_lradi(tp,zk,rc,name,Bf,Kf,C,p,max_it,min_res,...
              with_rs,min_in,info);  
                                       % compute ZC

title('LRCF-ADI for CALE  A^T X_{C} + X_{C} A_ = -C^TC')
disp('Termination flag:')
flag_C 
disp('Size of ZC:');
size_ZC = size(ZC)


% ----------------------------------------------------------------------- 
% Plot the transfer function of the system for a certain frequency range
% ----------------------------------------------------------------------- 

disp('... computing transfer function of original system ...'); 

freq = lp_lgfrq(100,1000,200);    % generate a set of 200 "frequency
                                  % sampling points" in the interval
                                  % [100,1000]. 
G = lp_trfia(freq,A,B,C,[],[]);   % compute "transfer function sample" 
                                  % for these frequency points
nrm_G = lp_gnorm(G,m,q);   % compute norms of the "transfer function
                           % sample" for these frequency points
                           
figure(3); hold off; clf; 
loglog(freq,nrm_G,'k:'); 
xlabel('\omega');
ylabel('Magnitude');
t_text = 'Bode plots:  dotted: ||G||';
title(t_text);
pause(1)


% ----------------------------------------------------------------------- 
% Generate reduced systems
% ----------------------------------------------------------------------- 

disp('Parameters for model reduction:')
max_ord = 10   % (This parameter determines the reduced order.)
tol = 0   % (avoided)


disp('... computing reduced system by LRSRM ...');
[Ars,Brs,Crs] = lp_lrsrm(name,B,C,ZB,ZC,max_ord,tol);   % run LRSRM

disp('Reduced order:')
disp(length(Ars))

Grs = lp_trfia(freq,Ars,Brs,Crs,[],[]);   % compute "transfer function
                                          % sample" for reduced system
nrm_Grs = lp_gnorm(Grs,m,q);   % compute norm transfer function samples 
                               % of reduced system
figure(3); hold on
loglog(freq,nrm_Grs,'r-'); 
t_text = [t_text, ',    solid: ||G_{LRSRM}||'];
title(t_text); pause(1)


disp('... computing reduced system by DSPMR ...');
[Ard,Brd,Crd] = lp_dspmr(name,B,C,ZB,ZC,max_ord,tol);   % run DSPMR

disp('Reduced order:')
disp(length(Ard))

Grd = lp_trfia(freq,Ard,Brd,Crd,[],[]);   % compute "transfer function
                                          % sample" for reduced system
nrm_Grd = lp_gnorm(Grd,m,q);   % compute norm transfer function samples 
                               % of reduced system
figure(3); hold on
loglog(freq,nrm_Grd,'b--'); 
t_text = [t_text, ',    dashed: ||G_{DSPMR}||'];
title(t_text); pause(1)


% ----------------------------------------------------------------------- 
% Destroy global data structures
% ----------------------------------------------------------------------- 

au_m_d;
au_l_d;
au_s_d(p);



