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

function cvec = objfCVaR(beta, q, N)
% *****************************************************************
% Computes vector c of the linear objective function f(x) = c'*x of the
% C-VaR Optimization problem 
% see: Uryasev, Rockafellar: Optimization of Conditional Value-at-Risk
% (1999)
% *****************************************************************
% Input:
%--------------------------------------------------------------------------
% beta -> confidence level
% q -> number of random vectors X1,...,Xq
% N -> nr of elements in vector Xi, i=1,...,q
%
% Output:
%--------------------------------------------------------------------------
% cvec -> vector c of linear objective function f(x) = c'*x
% *************************************************************************

cvec = [1, zeros(1,N), 1/(1-beta)*1/q*ones(1,q)];