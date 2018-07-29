% Formulate the bounds, equality, and inequality constraints for the 
% hydroelectric dam optimization problem.
%
% Copyright (c) 2012, MathWorks, Inc.
%
%% Linear constraints are of the form:  A*x <= b
%
% Bounds are of the form LB <= x <= UB
%
% The hydroelectric dam problem has 4 linear inequality constraints and 2 
% bound constraints:
%
%  1)  0 < Turbine Flow < 25,000 CFS
%  2)  0 < Spill Flow
%  3)  Max change in Turbine and Spill Flow < 500 CFS
%  4)  Combined Turbine and Spill Flow > 500 CFS
%  5)  50000 < Reservoir Storage < 100000 Acre-Feet
%  6)  The final reservoir level must equal the initial level (90000 AF)

%% Define Bounds
% Bounds are of the form LB <= x <= UB
%
% lower bound is 0, upper bound is only defined on turbine flow
LB = zeros(2*N,1);     % must have positive flow
UB = [25000*ones(N,1); % maximum turbine flow of 25,000 CFS
      Inf(N,1)];       % no bound on spill flow
  
%% Constraint 3: Minimum Project Flow
% Miniumum Project Flow is 500
% turbineFlow(t) + spillFlow(t) >= 500
% -turbineFlow(t) - spillFlow(t) <= -500
ot = ones(N,1);
b = -500*ot;
A = spdiags([-ot -ot],[0 N],N,N*2);

%% Constraint 4: Change in Project Flow
% Linear constraints are of the form:  A*x <= b
%
% Maximum change in project flow is +/- 500.  This constraint is
% represented as:
%
%   -500 <= change <= 500 (i.e. abs(change) <= 500)
%
% turbineFlow(t)+spillFlow(t)-turbineFlow(t-1)-spillFlow(t-1)  <= 500
% 1*x(turbIndex)+1*x(spillIndex)-1*x(turbIndex-1)-1*x(spillIndex-1) <= 500

% constraints for +500
A2 = spdiags([ot ot -ot -ot],[0 N -1 N-1],N,N*2);
b2 = 500*ot;

% remove the initial starting condition
A2(1,:) = [];
b2(1,:) = [];

% now add constraints for the -500 condition
A = [A; A2; -A2];
b = [b; b2; b2];

%% Constraint 5 & 6: Reservoir Storage Constraints
% Reservoir storage constraints
% 50000 <= Stor(t) <= 100,000 AF
% Stor(t) = s0+sum(inFlow(1:t))-sum(spillFlow(1:t))-sum(turbineFlow(1:t))
c = stor0 + C2A*cumsum(inFlow); % Convert CFS to AF
b = [b; 100000-c; -50000+c];
s = -C2A*sparse(tril(ones(N)));
s = [s s];
A = [A; s; -s];

%% Define Equality Constraints
% Reservoir storage must be 90,000 AF at the end of the period
Aeq = ones(1,2*N);
beq = sum(inFlow);
