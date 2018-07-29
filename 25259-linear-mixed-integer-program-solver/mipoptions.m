function o = mipoptions()
%MIPOPTIONS
% Returns default options struct for miprogram
% options = mipoptions()
%
% The default values are shown first, then an explanation and optional
% values.
%
% options.display = 'iter';
% Algorithm display [iter,improve,final,off]
%
% options.iterplot = false;
% Plot upper and lower bounds on objective function value while iterating
% [true,false]
%
% options.solver = 'linprog';
% LP solver (the user must make sure the lp solver is on the matlab path)
% It is highly recommended NOT to use linprog which comes with MATLAB
% [bp,linprog,clp,qsopt]
%
% options.Delta = 1e-8;
% Stopping tolerance of the gap (f_integer-f_lp)/(f_integer+f_lp)
%
% options.maxNodes = 1e5;
% Maximum number of nodes in the branch and bound tree to visit
%
% options.branchMethod = 3;
% 1 - depth first, 2 - breadth first, 3 - lowest cost, 4 - highest cost
%
% options.branchCriteria = 1; 
% 1 - most fractional, 2 - least fractional, 3 - highest cost, 4 - lowest cost
%
% options.intTol = 1e-6;
% Integer tolerance
%
%                 
% See Also:
% miprog
%
% Thomas Trötscher 2009
%

%Algorithm display (iter,improve,final,off)
o.display = 'iter';

%Plot upper and lower bounds on objective function value while iterating
o.iterplot = false;

%LP solver (the user must make sure the lp solver is on the matlab path)
% It is highly recommended NOT to use linprog which comes with MATLAB
% Mex interfaces for the other solvers are available online - just google it
% [bp,linprog,clp,qsopt]
o.solver = 'linprog';

%Branch and bound specific options
o.Delta = 1e-8; %Stopping tolerance of the gap (f_integer-f_lp)/(f_integer+f_lp)
o.maxNodes = 1e5; %Maximum number of nodes in the branch and bound tree to visit
o.branchMethod = 3; %1 - depth first, 2 - breadth first, 3 - lowest cost, 4 - highest cost
o.branchCriteria = 1; %1 - most fractional, 2 - least fractional, 3 - highest cost, 4 - lowest cost
o.intTol = 1e-6; %Integer tolerance