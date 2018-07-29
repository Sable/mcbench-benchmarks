function [h,p,s] = triplestest(X, alpha)
% TRIPLESTEST - non-parameteric triples test for distributional symmetry (skewness)
%
%   H = TRIPLESTEST(X) performs the non-parametric triples test for
%   symmetry (skewness) of the null hypothesis that the data in X comes
%   from a symmetrical distribution with an unknown median. The test
%   involves the examination of subsets of three variables from X (triples)
%   to determine the likelihood that the distribution is skewed. H==0
%   indicates that the null hypothesis cannot be rejected at the 5%
%   significance level. H==1 indicates that the null hypothesis can be
%   rejected at the 5% level.
%
%   H = TRIPLESTEST(X,ALPHA) performs the test at the significance level
%   (100*ALPHA)%.  ALPHA must  be a scalar between 0 and 1.
%
%   [H,P] = TRIPLESTEST(...) returns the p-value, i.e., the probability of
%   observing the given result, or one more extreme, by chance if the null
%   hypothesis is true.  Small values of P cast doubt on the validity of
%   the null hypothesis.
%
%   [H,P,STATS] = TRIPLESTEST(...) returns a structure STATS with the
%   following fields:
%      'N'       -- number of observations
%      'Ntriples -- number of triples = (N*(N-1)*(N-2))/6
%      'T'       -- statistic (# right - # left triples)
%      'S2'      -- variance
%      'z'       -- test statistic (z-score)
%      'median'  -- median value
%
%   Example:
%
%   % Temperature measurements were obtained by 27 weather stations on a
%   % sunny day in September. Note that temparature is not measured on an
%   % rational scale (a change from 10 to 30 degrees Celsius does not
%   % represent a threefold increase in heat! To see this, express the
%   % temperature in Fahrenheit: 50 to 86 degrees F). The temperatures (in
%   % degrees C) were as follows:
%
%       TEMP = [ 14.9 21.9 21.7 21.4 16.6 23.0 13.7 19.3 15.8 ...
%                16.5 12.3 19.4 22.6 17.3 13.4 14.9 14.5 14.8 ...
%                23.1 13.4 23.1 13.1 14.2 14.1 12.3 17.1 15.4 ] ;
%
%   % A histogram does suggest that the distribution is asymmetric:
%
%        bar(10:2:30,histc(TEMP,10:2:30),'histc') ;
%
%   % To calculate the probablity that the distribution is indeed assymetric
%   % around its median, we apply the triplestest:
%
%        [H, P, S] = triplestest(TEMP)
%        hold on ; plot(S.median([1 1]),[0 10],'r-') ; hold off ; 
%
%   % which yields H = 1 so that we could reject the null-hypothesis that the
%   % temperatures were symmetrically distributed with a significance level
%   % of P = 0.049.
%
%   Notes:
%   - The triples test is more powerful than most alternatives, and yields
%     satisfactory results for samples greater than about 20.
%   - Parametric estimations of distributional (a-)symmetry (such as the
%     3rd central moment) requires a data set that is measured on a
%     rational scale, whereas the non-parametric triples-test can also
%     handle data measured on an ordinal or interval scale (like
%     temperatures).
%   - The triples test is based on the fact that for symmetrical
%     distributions the number of leftward triples equals the number of
%     rightward triples. A leftward or rightward triple is defined as the
%     mean of the triple being smaller or larger than the median of the
%     triple, respectively.
%
%  See also SKEWNESS, KURTOSIS, MOMENT (Statistics Toolbox)

% Source: Siegel & Castellan, 1988, "Non-parametric statistics for the
%         behavioral sciences", McGraw-Hill, New York

% for Matlab R14
% version 2.1 (may 2008)
% (c) Jos van der Geest
% email: jos@jasen.nl

% History:
% 1.0 (mar 2008) - created
% 2.0 (mar 2008) - added help text
% 2.1 (may 2008) - small corrections to comments and help
% 2.2 (may 2012) - made several corrections (thanks to Bogdan)
%                  1) multiply p-values by 2 to reflect two-sided test
%                  2) included median in output STATS

error(nargchk(1,2,nargin)) ;

if ~isnumeric(X) || ~isreal(X),
    error('Data vector X should be a array of doubles.') ;
end

if nargin == 1,
    alpha = 0.05 ;
elseif ~isscalar(alpha) || alpha <= 0 || alpha >= 1
    error('triplestest:BadAlpha','ALPHA must be a scalar between 0 and 1.') ;
end

N = numel(X) ; % number of observations

if N < 6,
    warning('triplestest:NotEnoughData','Too few data points (should be more than 5)') ;
    p = NaN ;
    h = NaN ;
    s.N = N ;
    return
elseif N < 20,
    warning('triplestest:FewData','Less than 20 data points. Test may be inaccurate.') ;
end

X = sort(X(:)) ;

% pre-allocation
T = 0 ;
Tx = zeros(N,1) ;
Txy = zeros(N-1,N) ;

% These nested for-loops are faster than the vectorized solution with NCHOOSEK ...
for i=1:(N-2),
    for j=(i+1):N-1,
        for k = (j+1):N,
            % [X(i) X(j) X(k)] form a triple [T1, T2, T3]
            % since X is sorted these triple values are in order
            % for each triple we calculate whether it is a leftward triple (T2
            % is closer to T1 than to T3), a rightward triple (T2 is closer
            % to T3 than to T1) or none. 
            % This bowls down to the following formula:

            RL = sign(X(i) + X(k) - X(j) - X(j)) ;
            % RL: -1 = leftward triple (LT)
            %      0 = symmetric
            %      1 = rightward triple (RT)

            if RL,
                % assymetric triples should be considered
                % number of RTs minus number of LTs
                T = T + RL ;

                % #RTs - #LTs involving value X(x)
                Tx([i,j,k]) = Tx([i,j,k]) + RL ;

                % #RTs - #LTs involving values X(x) and X(y)
                Txy(i,[j k]) = Txy(i,[j k]) + RL ;
                Txy(j,k)     = Txy(j,k)     + RL ;
            end
        end
    end
end

% calculate variance. Use intermediate variables for clarity
Bx = sum(Tx.^2) ;
Bxy = sum(Txy(:).^2) ;
N12 = (N-1) * (N-2) ;
N012 = N * N12 ;
N34 = (N-3) * (N-4) ;
S2 = (N34 * Bx / N12) + ((N-3)*Bxy/(N-4)) + (N012/6) ;
S2 = S2 - ((1-((N34*(N-5)) / N012)) * T.^2) ;

% test statistic
z = T / sqrt(S2) ;

% significance level
p = 0.5 * erfc(-z ./ sqrt(2)) ;
p = 2 * min(p, 1-p) ; % two-sided ! ##check

% can we reject H0 "data is symmetric"?
h = p < alpha ;

if nargout==3,
    % additional output
    s.N = N ;
    s.Ntriples = N012/6 ;
    s.T = T ;
    s.Var = S2 ;
    s.z = z ;
    n = floor(numel(X)/2) ;
    if 2*n ~= numel(X),
        s.median = (X(n) + X(n+1))/2 ;
    else
        s.median = X(n) ;
    end
end

