% dispSymbolicHessianMatrix calculates the symbolic Hessian matrix for our
% Hydroelectric Dam Optimization problem.  No substitutions are performed
% in generating the Hessian, which allows us to inspect the it in pure
% symbolic form.

% Copyright (c) 2012, MathWorks, Inc.

%%
N = 3;

% Create symbolic variables
X = sym('x',[2*N,1]);   % turbine flow and spill flow
F = sym('F',[N,1]);     % flow into the reservoir
P = sym('P',[N,1]);     % price
s0 = sym('s0');         % initial storage
c1 = sym('c1');
c2 = sym('c2');
c3 = sym('c3');
c4 = sym('c4');

%%
% Total out flow equation
TotFlow = X(1:N)+X(N+1:end);

%%
% Storage Equations
S = cell(N,1);
S{1} = s0 + c1*(F(1)-TotFlow(1));

for ii = 2:N
    S{ii} = S{ii-1} + c1*(F(ii)-TotFlow(ii));
end

%%
% K factor equation
k = c2*([s0; S(1:end-1)]+ S)/2+c3;

%%
% MWh equation
MWh = k.*X(1:N)/c4;

%%
% Revenue equation
R = P.*MWh;

%%
% Total Revenue (Minus sign changes from maximization to minimization)
totR = -sum(R);

%%
% Gradient
grad = jacobian(totR,X).';

%%
% Hessian
Hess = jacobian(grad,X);

disp(' ')
disp('(c1*c2/c4) * ')
disp(' ')
disp(Hess/(c1*c2/c4))