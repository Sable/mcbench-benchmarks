% Black-Scholes implied vol
%
% sigma=impvol(C,S,K,r,t,T,q,tol)
%
% C: call price (scalar or vector)
% S: Stock price (scalar or vector)
% K: Strike price (scalar or vector)
% r: Interest rate (scalar or vector)
% t: Time now (scalar or vector)
% T: Maturity date (scalar or vector)
% [q]: Dividend yield (scalar or vector). Default=0;
% [tol]: Tolerance. Default=1e-6

function sigma=impvol(C,S,K,r,t,T,q,tol)

T=T-t;

if nargin<8
    tol=1e-6;
end

if nargin<7 || isempty(q)
    q=0;
end

F=S*exp((r-q).*T);
G=C.*exp(r.*T);

alpha=log(F./K)./sqrt(T);
beta=0.5*sqrt(T);

% Now we need to solve G=F Phi(d1)- K Phi(d2) where
% d1=alpha/sigma+beta and d2=alpha/sigma-beta

a=beta.*(F+K);
b=sqrt(2*pi)*(0.5*(F-K)-G);
c=alpha.*(F-K);

disc=max(0,b.^2-4*a.*c);

sigma0=(-b+sqrt(disc))./(2*a);

sigma=NewtonMethod(sigma0);

    function s1=NewtonMethod(s0)
        
        s1=s0;
        count=0;
        f=@(x) call(S,K,r,x,0,T,q)-C;
        fprime=@(x) call_vega(S,K,r,x,0,T,q);
        
        max_count=1e3;
        
        while max(abs(f(s1)))>tol && count<max_count
            count=count+1;
            
            s0=s1;
            s1=s0-f(s0)./fprime(s0);
        end
        
        if max(abs(f(s1)))>tol
            disp('Newton method did not converge')
        end
    end

end