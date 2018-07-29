function g
% Example on how to use SIMPS minimizer

m=3;                 % Dimension of matrix A
                     % (argument of target function)
n=m^2;               % Total number of components of A


fargs={};            % Various parameters to be passed to target
                     % function, in lieu of using global variables
%fargs={1};
%fargs={1,2};
%[fminA,fconstrA]=fun(A,fargs{:})  % Target function...

vlb=-n+zeros(1,n);   % Vector of lower bounds
vub=n+zeros(1,n);    % Vector of upper bounds

C=magic(m)*(rand(m)-0.5);          % Initial guess

options(1)=1;        % To display intermediate results use 1,
                     % otherwise use 0 (default)
options(2)=1e-3;     % Relative x-tolerance
options(3)=1e-3;     % Relative f-tolerance
options(14)=50*n;    % Max. number of f-evaluations per internal
                     % simplex calls
%ix=1:n;             % Minimize against all variables
ix=[1:n-2 n];        % Minimize only against selected variables,
                     % i.e. keep A(n-1)=A(n-1,n) fixed
[A,optionsA]=simps('fun',C,ix,options,vlb,vub,fargs{:});
%[A,optionsA]=simps('fun',C);      % Use dafaults...
fcallsA=optionsA(10);
fminA=optionsA(8);

% Compare to Matlab's CONSTR minimizer (OPTIM toolbox required)
options(1)=1;
options(2)=1e-6;
options(3)=1e-6;
options(14)=300*n;
[B,optionsB]=constr('fun',C,options,vlb,vub,[],fargs{:});
fcallsB=optionsB(10);
fminB=optionsB(8);

fcallsA, fminA
fcallsB, fminB

return
