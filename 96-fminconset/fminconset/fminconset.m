function [x,h,exitflag,output,lambda,grad,hessian] = fminconset(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options,set,Jmin,varargin);
%function [h,x,exitflag,output,lambda,grad,hessian] 
%     = fminconset(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options,set,Jmin,p1,p2,p3 ...);
%
% Solves constrained minimization problems where some of the variables are
% restricted to discrete values.
%
% The first 10 arguments are as for fmincon (see FMINCON for details):
%
% The following 2 arguments are special for FMINCONSET:
%
% Jmin      function value of best feasible solution found so far (used to cut the
%           search tree whenever a higher value is found). Default=Inf.
%
% set       Cell array of allowed set values for each entry in x.
%           Empty cell if the entry is without set constraint.
%		      Example: for x(1) in {0.1, 0.5, 0.8}, x(2) free and 
%			   x(3) in {3.1, 4.0} then 
%			   set={[0.1 0.5 0.8],[],[3.1 4]} 
%
% p1,p2,p3 ...	Passed to FUN and NONLCON as additional arguments (as for FMINCON)
%
% Output as for FMINCON:
%
% x		Optimal value of x
% h		Minimum function value
% ... etc as for FMINCON
% the values are from the call of FMINCON that gave the optimal feasible solution.
%
% Algorithm:
%
% Implements a 'branch-and-bound' method on top of FMINCON and thus the
% Optimization Toolbox is required.
% The function calls itself recursively.
%
% The method is intended for problems that are basically continous, with
% some variables constrained to sets of standard values.

% Made 1992 by:
%	Ingar Solberg
%	Institutt for teknisk kybernetikk
%	Norges Tekniske Høgskole
%	N-7034 Trondheim
%	Norway
%
% Authors address from 1993:
% Ingar Solberg               Phone: +47 75179152
% Elkem Aluminium Mosjøen     Fax:   +47 75179676
% N-8655 Mosjøen              E-mail: Ingar.Solberg@elkem.no
% Norway

% revised from the use of CONSTR to the use of FMINCON 1999.

% Applies a strategy where the problem is recursively divided into two
% subproblems by setting upper and lower bounds on the set-constrained
% variables.

% global spor; % for testing

% Solve problem without set constraints
[x,h,exitflag,output,lambda,grad,hessian] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon,options,varargin{:});
[n,m]=size(set);


% spor = [spor; exitflag -h x'];	% for testing

% check if improvement
if h>=Jmin
  h = inf;	% No improvement, no further search along this branch.
  return
end

% check if the solution is feasible (except set constraints)
if exitflag < 0
     h=inf;	% Infeasible, no further search along this branch. 
     return;
elseif exitflag == 0
     disp(['exitflag =',sprintf('%d ',exitflag),' at x= ',sprintf('%e ',x)]);
end

% check if all set constraints are satisfied
k=0;
for i=1:m			% check x-vector
  if ~isempty(set{i})	% set constraints applies?
      % Is it too far away from all values of the set?
    if ~any(abs(x(i) - set{i}) < optimget(options,'TolX'))
      k=i;	% Violation of this set constraint.
      break; % Go and split for this x-component
    end
  end
end

if k>0		% some set constraint violated => recursive search needed
  above=min(find(set{k}>x(k)));	% index of smallest set element above x(k)
  below=max(find(set{k}<x(k))); % index of largest set element below x(k)

% Solve first subproblem if it exists
  if ~isempty(below)
    ub1=ub;
    ub1(k)=set{k}(below);	% new upper bound on x(k) for 1. subproblem
    % rather than setting lower and upper bound equal the addition of an extra linear constraint is recommended
    % in the manual for FMINCON.
    if ub1(k)==lb(k)
       Aeq1 = [Aeq; full(sparse(1,k,1,1,size(x,1)))];beq1=[beq;ub1(k)];ub1(k)=inf;lb(k)=-inf;
    else
       Aeq1 = Aeq; beq1 = beq;
    end
    [x1,h1,exitflag1,output1,lambda1,grad1,hessian1] = fminconset(fun,x,A,b,Aeq1,beq1,lb,ub1,nonlcon,options,set,Jmin,varargin{:});
    if h1<Jmin
      Jmin=h1;	% Best so far
    end
  else
    h1=inf;
  end

% Solve second subproblem if it exists
  if ~isempty(above)
    lb1=lb;
    lb1(k)=set{k}(above);	% new lower bound on x(k) for 2. subproblem
    % rather than setting lower and upper bound equal the addition of an extra linear constraint is recommended
    % in the manual for FMINCON.
    if lb1(k)==ub(k)
       Aeq2 = [Aeq; full(sparse(1,k,1,1,size(x,1)))];beq2=[beq;lb1(k)];lb1(k)=-inf;ub(k)=inf;
    else
       Aeq2 = Aeq; beq2 = beq;
    end
    [x2,h2,exitflag2,output2,lambda2,grad2,hessian2] = fminconset(fun,x,A,b,Aeq2,beq2,lb1,ub,nonlcon,options,set,Jmin,varargin{:});
  else
    h2=inf;
  end

  if h1<h2	% Return the best solution
    h=h1;x=x1;exitflag=exitflag1;output=output1;lambda=lambda1;grad=grad1;hessian=hessian1;
  else
    h=h2;x=x2;exitflag=exitflag2;output=output2;lambda=lambda2;grad=grad2;hessian=hessian2;
  end
% spor =[spor;exitflag h x']; % for testing
end 