function [h,p,sigPairs] = ttest_bonf(x,pairs,alpha,tail)
%TTEST_BONF Hypothesis test: Isolate differences in
%   Repeated-Measures Analysis of Variance.
%
%   [H,P,SIGPAIRS] = TTEST_BONF(X,PAIRS,ALPHA,TAIL) performs a
%   set of Bonferroni corrected t-tests to determine which pairs of
%   treatments could have the same mean.
%
%   X is a matrix of size NUMSUBJECTS rows and NUMTREATMENTS
%   columns. 
%
%   PAIRS is a Nx2 matrix of pair-wise comparisons that should be
%   tested. Example: PAIRS=[ 1 2
%                            2 3
%                            3 4 ], 
%   will perform 3 t-tests. The first will test the means
%   of columns 1 and 2 of matrix X. The second tests the means of
%   columns 2 and 3 of matrix X. The last tests the means of
%   columns 3 and 4 of matrix X.
%   PAIRS = nchoosek(1:NUMTREATMENTS, 2) by default. This tests all
%   possible pairwise combinations of the columns of X.
%  
%   
%   The null hypothesis is: "means of two treatments are equal".
%   For TAIL =  0  the alternative hypothesis is: "means are not equal."
%   For TAIL =  1, alternative: "mean of X is greater than mean of Y."
%   For TAIL = -1, alternative: "mean of X is less than mean of Y."
%   TAIL = 0 by default.
%
%   ALPHA is desired experiment-wise significance level (ALPHA =
%   0.05 by default). The Bonferroni criteria effectively divides
%   ALPHA by the number of t-tests being performed.
%
%   P is the p-value, or the probability of observing the given result
%     by chance given that the null hypothesis is true. Small values
%     of P cast doubt on the validity of the null hypothesis.
%
%   H=0 => "Do not reject null hypothesis at significance level of alpha."
%   H=1 => "Reject null hypothesis at significance level of alpha."
%
%   SIGPAIRS contains the rows of PAIRS which fail the t-test
%       comparison.
%
%   References:
%      [1] S.A. Glantz, "Primer of BioStatistics",
%      McGray-Hill, 1992, pp 309-310. 

%   Oct 31, 2003
%   Adapted loosely from MATLAB's ttest2.m function by:
%
%         Guy Shechter
%         Lab of Cardiac Energetics, NHLBI, NIH, DHHS
%         Bethesda, Maryland, USA
%         guy at jhu dot edu

  
  
  if nargin < 1, 
    error('Requires at least one input arguments'); 
  end
  
  [m1 n1] = size(x);
  
  if nargin < 2, 
    pairs = nchoosek(1:n1,2);
  elseif isempty(pairs)
    pairs=nchoosek(1:n1,2);
  elseif max(pairs(:))>n1
    error('PAIRS contains an illegal entry');
  end    

  if (m1 == 1 & n1 == 1) 
    error('Requires matrix first  inputs.');
  end
  
  if nargin < 4, 
    tail = 0; 
  end 
  
  if nargin < 3, 
    alpha = 0.05; 
  end 

  if (prod(size(alpha))>1), error('ALPHA must be a scalar.'); end
  if (alpha<=0 | alpha>=1), error('ALPHA must be between 0 and 1.'); end

  df_btw_subjects = size(x,1)-1;
  df_treatments   = size(x,2)-1;
  
  df_residual = df_btw_subjects*df_treatments;
  grandmean = mean(x(:));
  ss_subjects=0;

  for isub=1:m1
    ss_subjects = ss_subjects + sum(   ( x(isub,:)-mean(x(isub,:))).^2);
  end
  ss_treatment =  m1*sum( ( mean(x)-grandmean ).^2);
  ssres = ss_subjects-ss_treatment;
  msres = ssres/df_residual;


  for q=1:size(pairs,1)
    t(q) = ( mean(x(:,pairs(q,1))) - mean( x(:,pairs(q,2))))./ ...
	   sqrt(2*msres/m1);
  end

  % Find the p-value for the tail = 1 test.
  p  = 1 - tcdf(t,df_residual);
  % Adjust the p-value for other null hypotheses.
  if (tail == 0)
    for q=1:length(p)
      p(q) = 2 * min(p(q), 1-p(q));
    end
  end

  % Determine if the actual significance exceeds the desired significance
  h=(p<= (alpha/size(pairs,1)));
  
  if (nargout>2), 
    sigPairs = pairs(h,:);
  end

  return
