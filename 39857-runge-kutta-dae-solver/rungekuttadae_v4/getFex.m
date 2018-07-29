function [fAndg] = getFex(y, para)
%getFex Easy access to the evaluation of the li,ki of the user function
% (meaning f and g of the rungekutta scheme).
%
%INPUT  vector  y     Flat solution of the newton algorithm.
%       struct  para  Internal rungekutta parameter.
%
%OUTPUT matrix f    fAndg(i,idxFlatDynamic) = f(li,ki),
%                   fAndg(i,idxFlatAlgebraic) = g(li, ki).
%
%AUTHOR Stefan Schießl
%DATE   13.08.2012

    fex = para.fex;
    cE = para.countEquations;
    cP = para.countPoints;
    cEP = para.countEquationsTimesPoints; 
    s = para.s;
    
    % Precalculate f for every ki, li
    fAndg = zeros(s, cEP);
    for i=1:s
        tmpfex = fex(reshape(y((i-1)*cEP+1:i*cEP), cE, cP));
        fAndg(i,:) = tmpfex(:);
    end
end