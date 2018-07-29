% ASTROTIK by Francesco Santilli
%
% Usage: x = regulafalsi(F,x1,x2)
%
% where: F = function handle F(x) (monotone, finite)
%        x1 = lower bound
%        x2 = upper bound
%        x = zero of F(x)
%
% note: F(x1)*F(x2) <= 0

function x = regulafalsi(F,x1,x2)

    if ~(nargin == 3)
        error('Wrong number of input arguments.')
    end
    
    check(x1,0)
    check(x2,0)
    
    if ~(isa(F,'function_handle'))
        error('Wrong class of input arguments.')
    end
    
    if x2 <= x1
        error('x2 must be strictly major than x1.')
    end

    y1 = feval(F,x1);
    y2 = feval(F,x2);
    
    if y1 == 0
        x = x1;
        return
    elseif y2 == 0
        x = x2;
        return
    end
    
    if (y1>0 && y2>0) || (y1<0 && y2<0)
        error('F(x1) and F(x2) must be discordant.')
    end
    
    s = sign(y2);
    x = x1;
    x0 = (x1+x2)/2;

    while ((abs(x-x0) / max(abs(x0),eps)) > eps ) && (y1~=y2)
        x = x0;
        x0 = (y2*x1-y1*x2) / (y2-y1);
        y0 = feval(F,x0);
        if y0*s < 0
            x1 = x0;
            y1 = y0;
        else
            x2 = x0;
            y2 = y0;
        end
    end
    x = x0;
    
end