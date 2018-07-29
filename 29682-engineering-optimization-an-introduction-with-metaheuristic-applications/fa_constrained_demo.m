% -----------------------------------------------------------------  %
% Matlab Programs included the Appendix B in the book:               %
%  Xin-She Yang, Engineering Optimization: An Introduction           %
%                with Metaheuristic Applications                     %
%  Published by John Wiley & Sons, USA, July 2010                    %
%  ISBN: 978-0-470-58246-6,   Hardcover, 347 pages                   %
% -----------------------------------------------------------------  %
% Citation detail:                                                   %
% X.-S. Yang, Engineering Optimization: An Introduction with         %
% Metaheuristic Application, Wiley, USA, (2010).                     %
%                                                                    % 
% http://www.wiley.com/WileyCDA/WileyTitle/productCd-0470582464.html % 
% http://eu.wiley.com/WileyCDA/WileyTitle/productCd-0470582464.html  %
% -----------------------------------------------------------------  %
% ===== ftp://  ===== ftp://   ===== ftp:// =======================  %
% Matlab files ftp site at Wiley                                     %
% ftp://ftp.wiley.com/public/sci_tech_med/engineering_optimization   %
% ----------------------------------------------------------------   %

% -----------------------------------------------------------------
% % Firefly Algorithm for nonlinear constrained optimization      %
% % by Xin-She Yang (Cambridge University) Copyright @2009        %
% % This program is a demo only, but should work reasonably well. %
% -----------------------------------------------------------------

%%% you can modify the following part --------------------------%%%
function fa_constrained_demo

format long;
% parameters [n N_iteration alpha betamin gamma]
para=[20 250 0.5 0.2 1];

help fa_constrained_demo  % display help

  % This demo uses the Firefly Algorithm to solve the
  % Spring Desing Problem as described by Cagnina et al (2008)
  % [Cagnina et al, Solving engineering optimization problems
  %  with the simple constrained particle swarm optimizer,
  %  Informatica, vol. 32, 319-326 (2008). ]
  % The best solution was 
  %    [0.051690; 0.356750; 11.287126] with the objective = 0.012665;
  % If you run this program a few times, you will find some solutions
  % are better than the above optimum. Try to experiment a bit :)

% Simple bounds/limits
disp('Solve the simple spring desing problem ...');
Lb=[0.05 0.25 2.0];
Ub=[2.0 1.3 15.0];

% Initial random guess
u0=(Lb+Ub)/2;

[u,fval,NumEval]=ffa_mincon(@cost, @constraint,u0,Lb,Ub,para);

% Display results (best solution => u, best objective value => fval
bestsolution=u
bestojb=fval
total_number_of_function_evaluations=NumEval

%%% Put your own cost/objective function -----------------------------%%%
%% Cost or Objective function
 function z=cost(x)
z=(2+x(3))*x(1)^2*x(2);

% Constrained optimization using penalty methods
% by changing f to F=f+ \sum lam_j*g^2_j*H_j(g_j)
% where H(g)=0 if g<=0 (true), =1 if g is false

%%% Put your own constraints here ------------------------------------%%%

function [g,geq]=constraint(x)
% All nonlinear inequality constraints should be here
% If no inequality constraint at all, simple use g=[];
% Note: there was some typo in Cagnina et al.'s paper, as the bracket near
% 12566 ( ) was misplaced in g(2), a factor 7178 instead of 71785 in g(1) 
g(1)=1-x(2)^3*x(3)/(71785*x(1)^4);
g(2)=(4*x(2)^2-x(1)*x(2))/(12566*(x(2)*x(1)^3-x(1)^4))+1/(5108*x(1)^2)-1;
g(3)=1-140.45*x(1)/(x(2)^2*x(3));
g(4)=x(1)+x(2)-1.5;

% all nonlinear equality constraints should be here
% formation geq(1)= ...., geq(2)=...
% If no equality constraint at all, put geq=[] as follows
geq=[];

%%% End of the part to be modifed ------------------------------------%%%

%%% ------------------------------------------------------------------%%%
%%% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%%%
%%% Do not modify the following codes unless you want to improve its  %%%
%%% performance or introduce other hydridization into the algorithm   %%%

% ------------------------------------------------------------------------
% ============ Start of the Firefly Algorithm Implementation =============
% The following implementation is to demonstrate the basic idea of 
% firefly algorithm for solving constrained optimization for any
% d-dimensional continous, nonlinear constrained problems. 
% The code is Not an optimized version, but it should work.
% In fact, this code was not used for the simulations in my publications
% listed below, but the principle/basic ideas and major steps are same.
% To suit your own purpose, some find adjustment may be needed.
% ------------------------------------------------------------------------
% To cite: 
% 1) X.-S. Yang, Engineering Optimization: An Introduction with
%      Metaheuristic Applications, John Wiley and Sons, July, (2010).
% 2) X.-S. Yang, Firefly algorithm for multimodal optimization,
%      in: Stochastic Algorithms: Foundations and Applications, SAGA 2009,
%      Lecture Notes in Computer Science, vol. 5792, pp. 169-178 (2009)
% 3) X.-S. Yang, Firefly algorithm, stochastic test functions and design
%      optimization, Int. J. Bio-Inspired Computation, 
%      Vol. 2, No. 2, pp. 78-84  (2010).
% -----------------------------------------------------------------------

% To call ffa_mincon (Firefly algorithm minimization with constraints)
% Inputs: fhandle => @cost (your own cost/objective function, it can be
%                   an external file or a function as above)
%         nonhandle => @constraint, all nonlinear constraints
%                   can be an external file or a function
%         Lb = lower bounds/limits
%         Ub = upper bounds/limits
%         If it is unconstrained, simply put any large/small enough values
%         (even -10^10 to 10^10 will do)
%  
%         u0 = initial guess (a row vector)
%              if no idea what u0 should, simply use u0=(Lb+Ub)/2 or u0=Lb;
%   para == optional (to control the Firefly algorithm)
%   you can use ffa_mincon(@cost,@constraint,u0,Lb, Ub) with parameters
%   if you want to change,
%   para =[number of fireflies (n), MaxGeneration, alpha, beta_min, gamma]
% Outputs: nbest   = the best solution found so far 
%          fbest   = the best objective value
%          NumEval = number of function evaluations should be: n * MaxGeneration
% Optional bits:
% The alpha can be reduced (as to reduce the randomness) (see later)
% ----------------------------------------------------------------------

% Start FA 
function [nbest,fbest,NumEval]=ffa_mincon(fhandle,nonhandle,u0, Lb, Ub, para)
% Check input parameters (otherwise set as default values)    
if nargin<6, para=[20 50 0.25 0.20 1]; end
if nargin<5, Ub=[]; end
if nargin<4, Lb=[]; end
if nargin<3,
    disp('Usuage: FA_mincon(@cost, @constraint, u0, Lb, Ub, para)');
end

% n=number of fireflies
% MaxGeneration=number of pseudo time steps
% ------------------------------------------------
% alpha=0.25;      % Randomness 0--1 (highly random)
% betamn=0.20;     % minimum value of beta
% gamma=1;         % Absorption coefficient
% ------------------------------------------------
n=para(1);  MaxGeneration=para(2); 
alpha=para(3); betamin=para(4); gamma=para(5);

% Total number of function evaluations
NumEval=n*MaxGeneration;

% Check if the upper bound and lower bound are of the same size
if length(Lb) ~=length(Ub),
    disp('Simple bounds/limits are improper!');
    return
end

% Calculate dimension
d=length(u0);

% Initial values of an array
zn=ones(n,1)*10^100;
% ------------------------------------------------
% generating the initial locations of n fireflies
[ns,Lightn]=init_ffa(n,d,Lb,Ub,u0);

% Iterations or pseudo time marching
for k=1:MaxGeneration,     %%%%% start iterations

% This line of reducing alpha is optional
 alpha=alpha_new(alpha,MaxGeneration);
    
% Evaluate new solutions (for all n fireflies)
for i=1:n,
   zn(i)=Fun(fhandle,nonhandle,ns(i,:));
   Lightn(i)=zn(i);
end

% Ranking the fireflies by their light intensity/objectives
[Lightn,Index]=sort(zn);
ns_tmp=ns; 
for i=1:n,
 ns(i,:)=ns_tmp(Index(i),:);
end

%% Find the current best 
nso=ns; Lighto=Lightn;
nbest=ns(1,:); Lightbest=Lightn(1);

% For output only 
fbest=Lightbest;

% For debug and display, you can uncomment the following line
% nbest, fval=Lightn(1)

% Move all fireflies to the better locations
[ns]=ffa_move(n,d,ns,Lightn,nso,Lighto,nbest,Lightbest,alpha,betamin,gamma,Lb,Ub);


end   %%%%% end of iterations

% ----------------------------------------------------------------------
% ----- All the subfunctions are listed here ---------------------------
% The initial locations of n fireflies
function [ns,Lightn]=init_ffa(n,d,Lb,Ub,u0)
  % if there are bounds/limits,    
if length(Lb)>0,
   for i=1:n,
   ns(i,:)=Lb+(Ub-Lb).*rand(1,d);
   end
else
   % generate solutions around the random guess 
   for i=1:n,
   ns(i,:)=u0+randn(1,d);
   end
end

% initial value before function evaluations
Lightn=ones(n,1)*10^100;

% Move all fireflies toward brighter ones
function [ns]=ffa_move(n,d,ns,Lightn,nso,Lighto,nbest,Lightbest,alpha,betamin,gamma,Lb,Ub)
% Scaling of the system
scale=abs(Ub-Lb);

% Updating fireflies
for i=1:n,
% The attractiveness parameter beta=exp(-gamma*r)
   for j=1:n,
      r=sqrt(sum((ns(i,:)-ns(j,:)).^2));
      % Update moves
      if Lightn(i)>Lighto(j), % Brighter and more attractive
      % Here betamin is necessary. If betamin is too small (say 0)
      % then, the movement towards the global best is too slow
      beta0=1;     beta=(beta0-betamin)*exp(-gamma*r.^2)+betamin;
      ns(i,:)=ns(i,:).*(1-beta)+nso(j,:).*beta+alpha.*(rand(1,d)-0.5).*scale;
      end
   end % end for j
   
end % end for i

% Check if the updated solutions/locations are within limits
[ns]=findlimits(n,ns,Lb,Ub);

% This function is optional, as it is not part of the original FA 
% The main idea to reduce randomness is to increase the convergence, 
% however, if you reduce randomness too quickly, then premature 
% convergence can occur. So use with care.
function alpha=alpha_new(alpha,NGen)
% alpha_n=alpha_0(1-delta)^NGen=0.005
% alpha_0=0.9
delta=1-(0.005/0.9)^(1/NGen);
alpha=(1-delta)*alpha;

% Make sure the fireflies are within the bounds/limits
function [ns]=findlimits(n,ns,Lb,Ub)
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

% -----------------------------------------
% d-dimensional objective function
function z=Fun(fhandle,nonhandle,u)
% Objective
z=fhandle(u);

% Apply nonlinear constraints by penalty method
% Z=f+sum_k=1^N lam_k g_k^2 *H(g_k) where lam_k >> 1 
z=z+getnonlinear(nonhandle,u);

function Z=getnonlinear(nonhandle,u)
Z=0;
% Penalty constant >> 1
lam=10^15; lameq=10^15;
% Get nonlinear constraints
[g,geq]=nonhandle(u);

% Apply all inequality constraints as a penalty function 
for k=1:length(g),
    Z=Z+ lam*g(k)^2*getH(g(k));
end
% Apply all equality constraints (when geq=[], length->0)
for k=1:length(geq),
   Z=Z+lameq*geq(k)^2*geteqH(geq(k));
end


% Test if inequalities hold so as to get the value of the Index function
% H(g) which is something like Index functions as in interior-point methods
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

%% =========== End of Firefly Algorithm implementation ===================
%% -----------------------------------------------------------------------

