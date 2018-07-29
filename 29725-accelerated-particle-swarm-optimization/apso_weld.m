% ============================================================= % 
% Files of the Matlab programs included in the book:            %
%     Xin-She Yang, Nature-Inspired Metaheuristic Algorithms,   %
%     Second Edition, Luniver Press, (2010).   www.luniver.com  %
% ============================================================= %   
% The Accelerated Particle Swarm Optimization (APSO):           %
% APSO was deloveloped by Xin-She Yang at Cambridge University  %
% in 2008.  For detail, please refer to Chapter 5 (section 5.3) % 
% of the following book by                                      %
% Xin-She Yang, Nature-Inspired Metaheuristic Algorithms,       %
% First Edition, Luniver Press, (2008). Also in Chapter 8       %
% (section 8.3, page 65) of the second edition (2010).          %
% ------------------------------------------------------------- %

% Optimization of a welded beam using Accelerated PSO
function apso_weld
% This welded beam example can be found in Section 4.4 of the book

%% Lower and upper bounds 
Lb=[0.1 0.1  0.1  0.1];
Ub=[2.0 10.0 10.0 2.0];
% Default parameters [number of particles, number of iterations]
para=[25 150 0.95];

% Call the accelerated PSO optimizer
[gbest,fmin]=pso_mincon(@cost,@constraint,Lb,Ub,para);

% Display results
Bestsolution=gbest
fmin

%% == Modify the following to use your own functions ===============
% Welded beam optimization. For detailed description, see
% X. S. Yang, Chapter 4 (section 4.4) of Nature-Inspired 
% Metaheuristic Algorithms, 2nd Edition, Luniver Press, (2010).
%% Objective function
function f=cost(x)
f=1.10471*x(1)^2*x(2)+0.04811*x(3)*x(4)*(14.0+x(2));

% Nonlinear constraints
function [g,geq]=constraint(x)
% Inequality constraints
Q=6000*(14+x(2)/2);
D=sqrt(x(2)^2/4+(x(1)+x(3))^2/4);
J=2*(x(1)*x(2)*sqrt(2)*(x(2)^2/12+(x(1)+x(3))^2/4));
alpha=6000/(sqrt(2)*x(1)*x(2));
beta=Q*D/J;
tau=sqrt(alpha^2+2*alpha*beta*x(2)/(2*D)+beta^2);
sigma=504000/(x(4)*x(3)^2);
delta=65856000/(30*10^6*x(4)*x(3)^3);
F=4.013*(30*10^6)/196*sqrt(x(3)^2*x(4)^6/36)*(1-x(3)*sqrt(30/48)/28);

g(1)=tau-13600;
g(2)=sigma-30000;
g(3)=x(1)-x(4);
g(4)=0.10471*x(1)^2+0.04811*x(3)*x(4)*(14+x(2))-5.0;
g(5)=0.125-x(1);
g(6)=delta-0.25;
g(7)=6000-F;

% If no equality constraint at all, put geq=[] as follows
geq=[];
%% === End of your own functions ==============================


%% === APSO Solver starts here ================================
% No need to modify the following, unless you want to improve
% the perfornance of this accelerated PSO.
function [gbest,fbest]=pso_mincon(fhandle,fnonlin,Lb,Ub,para)
if nargin<=4,
    para=[20 150 0.95];
end
% Populazation size, time steps and gamma
n=para(1); time=para(2); gamma=para(3);
% -----------------------------------------------------------------
%% Scalings
 scale=abs(Ub-Lb);
% Validation constraints
if abs(length(Lb)-length(Ub))>0,
    disp('Constraints must have equal size');
    return
end

% -----------------------------------------------------------
% Setting  parameters alpha, beta
% Randomness amplitude of roaming particles alpha=[0,1]
% Speed of convergence (0->1)=(slow->fast); % beta=0.5 
  alpha=0.2; beta=0.5; 
% A potential improvement of convergence is to use a variable
% alpha & beta. For example, to use a reduced alpha, we have
% gamma in [0.7, 1];
% -----------------------------------------------------------

%% ------------- Start Particle Swarm Optimization -----------
% generating the initial locations of n particles
best=init_pso(n,Lb,Ub);

fbest=1.0e+100;
% ----- Iterations starts ------ 
for t=1:time,     
   
% Find which particle is the global best
  for i=1:n,   
    fval=Fun(fhandle,fnonlin,best(i,:)); 
    % Update the best
    if fval<=fbest, 
        gbest=best(i,:);
        fbest=fval;
    end
        
  end
% -----------------------------------------------------------
% Randomness reduction
alpha=newPara(alpha,gamma);

% Move all particles to new locations    
  best=pso_move(best,gbest,alpha,beta,Lb,Ub);  
 
% Output the results to screen
	str=strcat('Best estimates: gbest=',num2str(gbest));
	str=strcat(str,'  iteration='); str=strcat(str,num2str(t));
	disp(str);

end  %%%%% end of main program

% -------------------------------------------------
% All subfunctions are listed here
% 
% Intial locations of particles
function [guess]=init_pso(n,Lb,Ub)
ndim=length(Lb);
for i=1:n,
guess(i,1:ndim)=Lb+rand(1,ndim).*(Ub-Lb);
end

% Move all the particles toward (xo,yo)
function ns=pso_move(best,gbest,alpha,beta,Lb,Ub)
% This scale is important as it increases the mobility of particles
n=size(best,1); ndim=size(best,2);
scale=(Ub-Lb);
for i=1:n,
ns(i,:)=best(i,:)+beta*(gbest-best(i,:))+alpha.*randn(1,ndim).*scale;
end
ns=findrange(ns,Lb,Ub);

% Application of simple lower and upper bounds
function ns=findrange(ns,Lb,Ub)
n=length(ns);
for i=1:n,
  % Apply the lower bound
  ns_tmp=ns(i,:);
  I=ns_tmp<Lb;
  ns_tmp(I)=Lb(I);
  
  % Apply the upper bounds 
  J=ns_tmp>Ub;
  ns_tmp(J)=Ub(J);
  % Update this new move 
  ns(i,:)=ns_tmp;
end

% Reduction of the randomness
function alpha=newPara(alpha,gamma);
% More elaborate scheme can be used.
alpha=alpha*gamma;

% ---------------------------------------------------------------------
% Computing the d-dimensional objective function with constraints
function z=Fun(fhandle,fnonlin,u)
% Objective
z=fhandle(u);

% Apply nonlinear constraints by the penalty method
% Z=f+sum_k=1^N lam_k g_k^2 *H(g_k) where lam_k >> 1 
z=z+getconstraints(fnonlin,u);

function Z=getconstraints(fnonlin,u)
% Penalty constant >> 1
PEN=10^15;
lam=PEN; lameq=PEN;

Z=0;
% Get nonlinear constraints
[g,geq]=fnonlin(u);

% Apply all inequality constraints as a penalty function 
for k=1:length(g),
    Z=Z+ lam*g(k)^2*getH(g(k));
end
% Apply all equality constraints (when geq=[], length->0)
for k=1:length(geq),
   Z=Z+lameq*geq(k)^2*geteqH(geq(k));
end

% Test if inequalities hold so as to get the value of the Index function
% H(g) which is something like the Index in the interior-point methods
function H=getH(g)
if g<=0, 
    H=0; 
else
    H=1; 
end

% Test if equalities hold
function H=geteqH(g)
if g==0,
    H=0;
else
    H=1; 
end
%% -----------------------------------------------------------------------
%% End of this program ---------------------------------------------------