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



function result = xstar(ival, cp, a, b, iter, Grid_k, ...
    model, V, t, r, q, strike, varargin)

cfvals = exp(feval(@CF, model, pi * Grid_k * diag(1./ (b-a)), t,r,q,varargin{:}));

x = ival;
eps = 1e-6;

for n = 1:iter  
    exp_t = exp( 1i * pi * Grid_k * diag((x - a) ./ (b - a)) );
    vec = real( cfvals .* exp_t ) .* V;
    vec(1,:) = 0.5*vec(1,:);
    
    g = (exp(-r * t) * sum(vec, 1)') ...
            - cp .* strike .* (exp(x) - 1);
    
    vec = imag(cfvals .* Grid_k .* exp_t) .* V;
    vec(1,:) = 0.5*vec(1,:);
    
    dg = - exp(-r * t) .* pi ./ (b - a) .* sum(vec, 1)' - cp .* strike .* exp(x);
    
    x = x - (g ./ dg);
    if abs(g) < eps
        break;
    end
end

result = x;

end