% LINEAR MIXED INTEGER PROGRAM SOLVER
%   This program solves mixed integer problems with a branch and bound
%   method. It is highly recommended to use a different solver than linprog
%   for solving the lp-relaxations. There are three good alternatives
%   available online with pre-compiled mex files:
%   1. CLP by the COIN-OR project. 
%         MEX interface can be found at: 
%         http://control.ee.ethz.ch/~joloef/clp.php
%   2. BPMPD by Csaba Mészáros
%         MEX interface can be found at: 
%         http://www.pserc.cornell.edu/bpmpd/
%   3. QSOPT by David Applegate, William Cook, Sanjeeb Dash, and Monika Mevenkamp
%         MEX interface can be found at: 
%         http://control.ee.ethz.ch/~joloef/mexqsopt.msql
%   To use another solver specify options.solver = 'clp','bp' or 'qsopt';
%   see mipoptions
%
%   Functions:
%       miprog - Solve the linear mip problem
%       mipoptions - Loads default options, see source for explanation
%       lpr - Solves the lp relaxation
%       miptest - Runs a tiny test problem
%   Other:
%       testproblem.mat - Contains a small testproblem
%
%   Further work:
%   Add heuristics to create a good initial integer solution
%   Add cuts to the problem (branch and cut method)
%
%   Some testing with the problem shows that it works well with up to 
%   around 30 integer variables and 10000 lp variables if you use qsopt or
%   clp. However, the performance is far from that of commercial solvers;
%   this program is intended for educational purposes.
%
%   Thomas Trötscher 2009
        