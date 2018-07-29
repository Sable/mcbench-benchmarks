% Schwefel test function which has n decision variables, has several local optima.
%hasone global optimum. all decision variables are bounded in [-500
% 500].
% is x=[1 1 ...1]   with f(x)=0

function schwefel=test5(x)
schwefel=418.9829*numel(x)-sum(x.*sin(sqrt(abs(x))));