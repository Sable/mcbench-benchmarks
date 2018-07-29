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



function phi = cf_cgmy(u,T,t_star,r,d, C, G, M, Y)
% characteristic function of the CGMY model
    m = -C*gamma(-Y)*((M-1)^Y-M^Y+(G+1)^Y-G^Y);
    tmp = C*(T-t_star)*gamma(-Y)*((M-1i*u).^Y-M^Y+(G+1i*u).^Y-G^Y);
    phi = exp(1i*u*((r-d+m)*(T-t_star)) + tmp);
end