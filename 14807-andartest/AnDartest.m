function [AnDartest] = AnDartest(x,alpha)
%ANDARTEST Anderson-Darling test for assessing normality of a sample data.
% The Anderson-Darling test (Anderson and Darling, 1952) is used to test if 
% a sample of data comes from a specific distribution. It is a modification
% of the Kolmogorov-Smirnov (K-S) test and gives more weight to the tails
% than the K-S test. The K-S test is distribution free in the sense that the
% critical values do not depend on the specific distribution being tested.
% The Anderson-Darling test makes use of the specific distribution in calculating
% critical values. This has the advantage of allowing a more sensitive test
% and the disadvantage that critical values must be calculated for each
% distribution.
% The Anderson-Darling test is only available for a few specific distributions.
% The test is calculated as: 
%              
%        AD2 = integral{[F_o(x)-F_t(x)]^2/[F_t(x)(1-F_t(x)0]}dF_t(x)
%
%        AD2a = AD2*a
%
% Note that for a given distribution, the Anderson-Darling statistic may be
% multiplied by a constant, a (which usually depends on the sample size, n).
% These constants are given in the various papers by Stephens (1974, 1977a,
% 1977b, 1979, 1986). This is what should be compared against the critical 
% values. Also, be aware that different constants (and therefore critical 
% values) have been published. You just need to be aware of what constant 
% was used for a given set of critical values (the needed constant is typically
% given with the critical values). 
% The critical values for the Anderson-Darling test are dependent on the 
% specific distribution that is being tested. Tabulated values and formulas
% have been published for a few specific distributions (normal, lognormal, 
% exponential, Weibull, logistic, extreme value type 1). The test is a one-sided
% test and the hypothesis that the distribution is of a specific form is 
% rejected if the test statistic, AD2a, is greater than the critical value. 
% Here we develop the m-file for detecting departure from normality. It is 
% one of the most powerful statistics for test this.
%
% Syntax: function AnDartest(X) 
%      
%     Input:
%          x - data vector
%      alpha - significance level (default = 0.05)
%
%     Output:
%            - Complete Anderson-Darling normality test
%
% Example: From the Table 1 base data of secondary coating diameter, SCD 
%    (micrometers) for an optical fiber manufacturing and testing [Application
%    and acceptance sampling in testing of optical fiber (Bhaumik and Bhargava,
%    2005)], taked from Internet: 
%    http://www.sterliteoptical.com/pdf/ProdWithContents/Application%20of%
%    20acceptance%20sampling%20in%20testing%20of%20optical%20fiber.pdf
%    The measurements of the sample are analyzed for the normality using the
%    Anderson-Darling test with a significance of 0.05.
%    
% Data vector is:
%  x=[245.3;245.6;245.0;244.7;244.6;244.6;245.9;245.2;245.5;246.1;246.5;246.7; 
%  246.0;245.8;245.3;245.3;246.0;245.5;246.7;245.3;245.8;245.8;245.2;245.7;
%  244.8;246.7;246.5;245.5;246.0;244.8;244.8;244.4;244.8;245.6;245.5;244.0;
%  245.2;244.8;245.4;246.1;245.9;245.6;245.2];
%
% Calling on Matlab the function: 
%            AnDartest(x)
%
% Answer is:
%
% Sample size: 43
% Anderson-Darling statistic: 0.2858
% Anderson-Darling adjusted statistic: 0.2912
% Probability associated to the Anderson-Darling statistic = 0.6088
% With a given significance = 0.050
% The sampled population is normally distributed.
% Thus, this sample have been drawn from a normal population with a mean & variance = 245.4814    0.4139
%
% Created by A. Trujillo-Ortiz, R. Hernandez-Walls, K. Barba-Rojo and 
%             A. Castro-Perez
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
% Copyright. April 20, 2007.
%
% To cite this file, this would be an appropriate format:
% Trujillo-Ortiz, A., R. Hernandez-Walls, K. Barba-Rojo and A. Castro-Perez. (2007).
%   AnDartest:Anderson-Darling test for assessing normality of a sample data. 
%   A MATLAB file. [WWW document]. URL http://www.mathworks.com/matlabcentral/
%   fileexchange/loadFile.do?objectId=14807
%
% References:
%  Anderson, T. W. and Darling, D. A. (1952), Asymptotic theory of certain 
%      'goodness-of-fit' criteria based on stochastic processes. Annals of
%      Mathematical Statistics, 23:193-212. 
%  Stephens, M. A. (1974), EDF Statistics for goodness of fit and some 
%      comparisons. Journal of the American Statistical Association, 
%      69:730-737.
%  Stephens, M. A. (1976), Asymptotic Results for goodness-of-fit statistics
%      with unknown parameters. Annals of Statistics, 4:357-369.
%  Stephens, M. A. (1977a), Goodness of fit for the extreme value distribution.
%      Biometrika, 64:583-588.
%  Stephens, M. A. (1977b), Goodness of fit with special reference to tests
%      for exponentiality. Technical Report No. 262, Department of Statistics,
%      Stanford University, Stanford, CA.
%  Stephens, M. A. (1979), Tests of fit for the logistic distribution based
%      on the empirical distribution function. Biometrika, 66:591-595.
%  Stephens, M. A. (1986), Tests based on EDF statistics. In: D'Agostino,
%      R.B. and Stephens, M.A., eds.: Goodness-of-Fit Techniques. Marcel 
%      Dekker, New York. 
%

switch nargin
    case{2}
        if isempty(x) == false && isempty(alpha) == false
            if (alpha <= 0 || alpha >= 1)
                fprintf('Warning: Significance level error; must be 0 < alpha < 1 \n');
                return;
            end
        end
    case{1}
        alpha = 0.05;
    otherwise 
        error('Requires at least one input argument.');
end

n = length(x);

if n < 7,
    disp('Sample size must be greater than 7.');
    return,
else
    x = x(:);
    x = sort(x);
    fx = normcdf(x,mean(x),std(x));
    i = 1:n;
    
    S = sum((((2*i)-1)/n)*(log(fx)+log(1-fx(n+1-i))));
    AD2 = -n-S;
    
    AD2a = AD2*(1 + 0.75/n + 2.25/n^2); %correction factor for small sample sizes: case normal
    
    if (AD2a >= 0.00 && AD2a < 0.200);
        P = 1 - exp(-13.436 + 101.14*AD2a - 223.73*AD2a^2);
    elseif (AD2a >= 0.200 && AD2a < 0.340);
        P = 1 - exp(-8.318 + 42.796*AD2a - 59.938*AD2a^2);
    elseif (AD2a >= 0.340 && AD2a < 0.600);
        P = exp(0.9177 - 4.279*AD2a - 1.38*AD2a^2);
    else (AD2a >= 0.600 && AD2a <= 13);
        P = exp(1.2937 - 5.709*AD2a + 0.0186*AD2a^2);
    end
end

disp(' ')
fprintf('Sample size: %i\n', n);
fprintf('Anderson-Darling statistic: %3.4f\n', AD2);
fprintf('Anderson-Darling adjusted statistic: %3.4f\n', AD2a);
fprintf('Probability associated to the Anderson-Darling statistic = %3.4f\n', P);
fprintf('With a given significance = %3.3f\n', alpha);
if P >= alpha;
   disp('The sampled population is normally distributed.');
   s = [mean(x),var(x)];
   fprintf('Thus, this sample have been drawn from a normal population with a mean & variance = %6.4f  %8.4f\n',s);
else
   disp('The sampled population is not normally distributed.');
end

return,