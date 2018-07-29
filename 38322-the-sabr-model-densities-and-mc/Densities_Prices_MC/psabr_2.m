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

function y = psabr_2(a,b,r,n,f,k,t)
% SABR risk neutral density calculated from option prices
% calculated by density extrapolation technique sprice_2(...)
% as proposed by Kainth et al. using no specific cut off point

    eps = 1e-003;
    y1 = sprice_2(a,b,r,n,f,k+eps,t,-1);
    y2 = sprice_2(a,b,r,n,f,k,t,-1);
    y3 = sprice_2(a,b,r,n,f,k-eps,t,-1);
    y = (y1-2*y2+y3)/eps^2;
end