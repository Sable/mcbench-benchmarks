function y = mvcoprnd(family,theta,m,n,nu)
%MVCOPRND Random numbers from multivariate copula.
%   Y = MVCOPRND(FAMILY,THETA,M,N,NU) returns an M-by-N matrix of random numbers
%   generated from multivariate copula determined by FAMILY, with parameter THETA
%   (and NU for Student copula). FAMILY is 'Clayton', 'Frank', 'Gumbel', 'Gauss'
%   or 't'. Each column of Y comes from the Uniform(0,1) marginal distribution.
%
%   MVCOPRND uses Conditional method and Marshall-Olkin's method for Archimedean
%   copulas (Clayton, Frank, Gumbel). Second method performs better.
%
%   Written by Robert Kopocinski, Wroclaw University of Technology,
%   for Master Thesis: "Simulating dependent random variables using copulas.
%   Applications to Finance and Insurance".
%   Date: 2007/05/12
%
%   References:
%      [1]  Marshall, A. and Olkin, I. (1988) Families of Multivarite Distributions, 
%           Journal of the American Statistical Association, 83(403):834-841.
%      [2]  Cherubini, U. and Luciano, E. and Vecchiato, W. (2004) Copula Methods in Finance,
%           "John Wiley & Sons", New York.

if nargin < 4
    error('archrnd:TooFewInputs','Requires four input arguments.');
end



switch family
    case 'clayton'
        if theta < 0
            error('archrnd:BadClaytonParameter', ...
                  'THETA must be nonnegative for the Clayton copula.');
        end
        if theta == 0
            y = rand(m,n); %independence
        else
            % uses Marshall-Olkin's method
            gamma = gamrnd(1/theta,1,m,1)*ones(1,n);
            y = (1-log(rand(m,n))./gamma).^(-1/theta);
        end
    case 'frank'
        if theta == 0
            y = rand(m,n); %independence
        else
            if n==2
                % uses Conditional method because it allows theta<0
                x = rand(m,1);
                y1 = rand(m,1);
                y2 = - log( (exp(-theta)-1)*x./((1-x).*exp(-theta*y1)+x) +1 ) / theta;
                y = [y1 y2];
            else
                % uses Marshall-Olkin's method
                if theta < 0
                    error('archrnd:BadFrankParameter', ...
                          'THETA must be nonnegative for multivariate Frank copula.');
                end
                %gamma has logarithmic series distribution
                gamma = floor( 1+log(rand(m,1))./(log(1-exp(-theta*rand(m,1)))));
                y = -log(1-exp(log(rand(m,n))./(gamma*ones(1,n)))*(1-exp(-theta)))/theta ;
            end
        end
    case 'gumbel'
        % uses Marshall-Olkin's method
        if theta < 1
            error('archrnd:BadGumbelParameter', ...
                  'THETA must be greater than or equal to 1 for the Gumbel copula.');
        end
        if theta == 1
            y = rand(m,n); %independence
        else
            %uses positive, scaled by (cos(pi/2/theta))^theta, stable distribution
            V = rand(m,1)*pi-pi/2;
            W = -log(rand(m,1));
            T = V + pi/2;
            gamma = sin(T/theta).^(1/theta).*cos(V).^(-1).*((cos(V-T/theta))./W).^(1-1/theta);
            y = exp( - (-log(rand(m,n))).^(1/theta)./(gamma*ones(1,n))  );
        end
    case 'gauss'
        corrtest(theta); %test if R is a correlation matrix.
        y = normcdf(randn(m,n)*chol(theta));
    case 'student'
        corrtest(theta); %test if R is a correlation matrix.
        s = chi2rnd(nu,m,1);
        y = tcdf(randn(m,n)*chol(theta).*( sqrt(nu./s)*ones(1,n) ),nu);
otherwise
    error('Unrecognized copula type: ''%s''',family);
end
