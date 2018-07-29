% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code. 


function [A,b,Aeq,beq,lb,ub] = constCVaR(Sample,mu,Rstar)
% *************************************************************************
% Computes linear constrainst A*x <= b, Aeq*x = beq, lb <= x <= ub of the
% C-VaR Optimization problem 
% see: Uryasev, Rockafellar: Optimization of Conditional Value-at-Risk
% (1999)
% *************************************************************************
% Input:
%--------------------------------------------------------------------------
% Sample -> matrix of realizations of random variables X1,...,Xn
% mu -> vector of first moments of random variables X1,...,Xn
%
% Output:
%--------------------------------------------------------------------------
% A -> matrix on the lefthanside of inequality constraints A*x <= b
% b -> vector on the righthanside of inequality constraints A*x <= b
% Aeq -> matrix on the lefthanside of equality constraints Aeq*x = beq
% beq -> vector on the righthanside of equality constraints Aeq*x = beq
% lb -> vector of lower bounds lb <= x
% ub -> vector of upper bounds x <= ub
% *************************************************************************

[q,N] = size(Sample);

A = zeros(q,1+N+q);
A(1:end,1) = -1;
A(1:end,2:N+1) = -Sample;
A(1:end,N+2:end) = -eye(q);

b = zeros(q,1);

Aeq = zeros(2,1+N+q);
Aeq(1,2:N+1) = -mu';
Aeq(2,2:N+1) = 1;

beq = zeros(2,1);
beq(1) = -Rstar;
beq(2) = 1;

lb = zeros(1+N+q,1);
ub=[Inf;ones(N,1);Inf*ones(q,1)];




