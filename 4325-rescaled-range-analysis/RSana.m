function [logRS,logERS,V]=RSana(x,n,method,q)
%Syntax: [logRS,logERS,V]=RSana(x,n,method,q)
%____________________________________________
%
% Performs R/S analysis on a time series.
%
% logRS is the log(R/S).
% logERS is the Expectation of log(R/S).
% V is the V statistic.
% x is the time series.
% n is the vector with the sub-periods.
% method can take one of the following values
%  'Hurst' for the Hurst-Mandelbrot variation.
%  'Lo' for the Lo variation.
%  'MW' for the Moody-Wu variation.
%  'Parzen' for the Parzen variation.
% q can be either
%  a (non-negative) integer.
%  'auto' for the Lo's suggested value.
%
%
% References:
%
% Peters E (1991): Chaos and Order in the Capital Markets. Willey
%
% Peters E (1996): Fractal Market Analysis. Wiley
%
% Lo A (1991): Long term memory in stock market prices. Econometrica
% 59: 1279-1313
%
% Moody J, Wu L (1996): Improved estimates for Rescaled Range and Hurst
% exponents. Neural Networks in Financial Engineering, eds. Refenes A-P
% Abu-Mustafa Y, Moody J, Weigend A: 537-553, Word Scientific
%
% Hauser M (1997): Semiparametric and nonparametric testing for long
% memory: A Monte Carlo study. Empirical Economics 22: 247-271
%
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% 45110 - Dourouti
% Ioannina
% Greece
%
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% 1 Jan 2004.

if nargin<1 | isempty(x)==1
   error('You should provide a time series.');
else
   % x must be a vector
   if min(size(x))>1
      error('Invalid time series.');
   end
   x=x(:);
   % N is the time series length
   N=length(x);
end

if nargin<2 | isempty(n)==1
   n=1;
else
   % n must be either a scalar or a vector
   if min(size(n))>1
      error('n must be either a scalar or a vector.');
   end
   % n must be integer
   if n-round(n)~=0
       error('n must be integer.');
   end
   % n must be positive
   if n<=0
      error('n must be positive.');
   end
end

if nargin<4 | isempty(q)==1
   q=0;
else
    if q=='auto'
        t=autocorr(x,1);
        t=t(2);
        q=((3*N/2)^(1/3))*(2*t/(1-t^2))^(2/3);
    else
        % q must be a scalar
        if sum(size(q))>2
            error('q must be scalar.');
        end
        % q must be integer
        if q-round(q)~=0
            error('q must be integer.');
        end
        % q must be positive
        if q<0
            error('q must be positive.');
        end
    end
end


for i=1:length(n)
    
    % Calculate the sub-periods
    a=floor(N/n(i));
    
    % Make the sub-periods matrix
    X=reshape(x(1:a*n(i)),n(i),a);
    
    % Estimate the mean of each sub-period
    ave=mean(X);
    
    % Remove the mean from each sub-period
    cumdev=X-ones(n(i),1)*ave;
    
    % Estimate the cumulative deviation from the mean
    cumdev=cumsum(cumdev);
    
    % Estimate the standard deviation
    switch method
    case 'Hurst'
        % Hurst-Mandelbrot variation
        stdev=std(X);
    case 'Lo'
        % Lo variation
        for j=1:a
            sq=0;
            for k=0:q
                v(k+1)=sum(X(k+1:n(i),j)'*X(1:n(i)-k,j))/(n(i)-1);
                if k>0
                    sq=sq+(1-k/(q+1))*v(k+1);
                end
            end
            stdev(j)=sqrt(v(1)+2*sq);
        end
    case 'MW'
        % Moody-Wu variation
        for j=1:a
            sq1=0;
            sq2=0;
            for k=0:q
                v(k+1)=sum(X(k+1:n(i),j)'*X(1:n(i)-k,j))/(n(i)-1);
                if k>0
                    sq1=sq1+(1-k/(q+1))*(n(i)-k)/n(i)/n(i);
                    sq2=sq2+(1-k/(q+1))*v(k+1);
                end
            end
            stdev(j)=sqrt((1+2*sq1)*v(1)+2*sq2);
        end
    case 'Parzen'
        % Parzen variation
        if mod(q,2)~=0
            error('For the "Parzen" variation q must be dived by 2.');
        end
        for j=1:a
            sq1=0;
            sq2=0;
            for k=0:q
                v(k+1)=sum(X(k+1:n(i),j)'*X(1:n(i)-k,j))/(n(i)-1);
                if k>0 & k<=q/2
                    sq1=sq1+(1-6*(k/q)^2+6*(k/q)^3)*v(k+1);
                elseif k>0 & k>q/2
                    sq2=sq2+(1-(k/q)^3)*v(k+1);
                end
            end
            stdev(j)=sqrt(v(1)+2*sq1+2*sq2);
        end
    otherwise
        error('You should provide another value for "method".');
    end
    
    % Estiamte the rescaled range
    rs=(max(cumdev)-min(cumdev))./stdev;
    
    clear stdev
    
    % Take the logarithm of the mean R/S
    logRS(i,1)=log10(mean(rs));
    
    if nargout>1
        
        % Initial calculations fro the log(E(R/S))
        j=1:n(i)-1;
        s=sqrt((n(i)-j)./j);
        s=sum(s);
        
        % The estimation of log(E(R/S))
        logERS(i,1)=log10(s/sqrt(n(i)*pi/2));
        
        % Other estimations of log(E(R/S))
        %logERS(i,1)=log10((n(i)-0.5)/n(i)*s/sqrt(n(i)*pi/2));
        %logERS(i,1)=log10(sqrt(n(i)*pi/2));
        
    end
    
    if nargout>2
        % Estimate V
        V(i,1)=mean(rs)/sqrt(n(i));
    end

end