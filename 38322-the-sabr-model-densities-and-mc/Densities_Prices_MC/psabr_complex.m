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

function y = psabr_complex(a,b,r,n,f,k,t)
% sabr risk neutral density using Benhamou et al. pricing formula

    eps = 1e-006;
    
    y1 = sabr_complex(f,k+eps,t,a,b,r,n);
    y2 = sabr_complex(f,k,t,a,b,r,n);
    y3 = sabr_complex(f,k-eps,t,a,b,r,n);
    y = (y1-2*y2+y3)/eps^2;
    y(isnan(y)) = 0;
end
