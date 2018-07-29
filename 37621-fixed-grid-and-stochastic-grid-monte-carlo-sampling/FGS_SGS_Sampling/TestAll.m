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

S = 100; K = 100; r = 0.03; sigma = 0.2;
T = 1; a = 0.2; b = 0.25; lambda = 0.5;
NSim = 1000; Nt = 1; n_max = 10;
y = MC_merton_fgs(S,r,sigma,T, a,b,lambda,NSim,Nt);
c1 = exp(-r*T)* mean(max(y - K,0)); p1 = exp(-r*T)*mean(max(K-y,0));
y = MC_merton_sgs(S,r,sigma,T, a,b,lambda,NSim);
c2 = exp(-r*T)* mean(max(y - K,0)); p2 = exp(-r*T)*mean(max(K-y,0));
[c, p] = MertonPrice(S,K,sigma,r,T,a,b,lambda,n_max);

strcat('c= ', num2str(c), '; c1= ', num2str(c1), '; c2= ', num2str(c2))
strcat('p= ', num2str(p), '; p1= ', num2str(p1), '; p2= ', num2str(p2))