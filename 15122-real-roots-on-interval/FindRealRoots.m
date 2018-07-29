function roots=FindRealRoots(funhandle,a,b,n)

% Finds all the real roots of the function 'funhandle' over the interval
% [a,b] by a Chebyshev polynomial approximation method using n polynomials.
% Plots out the original function and the Chebyshev expansion, so that if
% the approximation is poor then a higher valuer of n can be used.
% 
% This version 26th May 2007 by Stephen Morris, 
% Nightingale-EOS Ltd., St. Asaph, Wales.


tic
% We begin by obtaining the Chebyshev coefficients for the function
c=chebft(funhandle,a,b,n);

% Define A as the Frobenius-Chebyshev companion matrix. This is based
% on the form given by J.P. Boyd, Appl. Num. Math. 56 pp.1077-1091 (2006).
A=zeros(n-1);   % "n-1" because Boyd's notation includes the zero-indexed
A(1,2)=1;       % elements whereas Matlab's of course does not allow this. 
                % In other words, to replicate Boyd's N=5 matrix we need to 
                % set n=6.
for j=2:n-2     
    for k=1:n-1 
        if j==k+1 || j==k-1 
            A(j,k)=0.5;     
        end
    end
end
for k=1:n-1
    A(n-1,k)=-c(k)/(2*c(n));  % c(1) in our notation is c(0) in Boyd's
end
A(n-1,n-2)=A(n-1,n-2)+0.5;
% Now we have the companion matrix, we can find its eigenvalues using the
% MATLAB built-in function.
eigvals=eig(A);

% We're only interested in the real elements of the matrix:
realvals=(arrayfun(@(x) ~any(imag(x)),eigvals)).*eigvals;

% Of course these are the roots scaled to the canonical interval [-1,1]. We
% need to map them back onto the interval [a,b]; we widen the interval just
% a fraction to make sure that we don't miss any that are right on the
% edge.
rangevals=nonzeros((arrayfun(@(x) abs(x)<=1.001, realvals)).*realvals);
roots=sort((rangevals.*0.5*(b-a)) + (0.5*(b+a)));

disp(['Time taken=' num2str(toc)])

% As a sanity check we'll plot out the original function and its Chebyshev
% approximation: if they don't match then we know to call the routine again
% with a larger 'n'.
grid=linspace(a,b);
for icount=1:length(grid);
    fungrid(icount)=funhandle(grid(icount));
end
chebgrid=Chebyshev(a,b,c,grid);
plot(grid,fungrid,'color',[1 0 0]);
line(grid,chebgrid,'color',[0 0 1]);
line(grid,zeros(1,length(grid)),'linestyle','--')

    function c=chebft(funhandle,a,b,n)
        
        % Based on the routine given in Numerical Recipes section 5.6;
        % calculates the Chebyshev coefficients necessary to approximate
        % funhandle over the interval [a,b]
        f=zeros(1,n);
        c=f;
        
        bma=0.5*(b-a);
        bpa=0.5*(b+a);
        for k=1:n;                       % We can't vectorize this loop 
            y=cos(pi.*(k-0.5)./n);       % with confidence because we can't 
            f(k)=funhandle((y*bma)+bpa); % depend on funhandle being a 
        end                              % vector function.
        for j=1:n
            k=1:n;                       % We can safely vectorize this
            runtot=(f(k).*cos((pi*(j-1)).*((k-0.5)/n)));
            c(j)=sum(runtot)*2/n;
        end
        % We need this extra statement to bring Boyd's notation and that of
        % Numerical Recipes into line.
        c(1)=c(1)/2;
        
    end
        
end

% This function is only used by the plot-and-check routine, and is not
% required for the root-finding itself.
function F=Chebyshev(a,b,c,xdata)

% Evaluate the function approximated by the Chebyshev coefficents
% c, defined over the range [a,b], at a vector of points xdata
% whose values are all contained within [a,b].
%
% This is the method using Clenshaw's recurrence formula, simply taken from
% Numerical Recipes section 5.6 and vectorized.

y=(2.*xdata-a-b)./(b-a);   % This is the change-of-variable to map the 
y2=2.*y;                   % interval [a,b] onto [-1,1].
d=zeros(1,length(xdata));
dd=d;
for j=length(c):-1:2
    sv=d;
    d=(y2.*d)-dd+c(j);
    dd=sv;
end
% As we have already halved the value of c(1), to bring the notations of
% J.P. Boyd and Numerical Recipes into agreement, we change the next
% statement to reflect this.
F=(y.*d)-dd+c(1);

end
