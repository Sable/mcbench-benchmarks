function [H, pValue, CM_limiting_stat] = cmtest2(x1 , x2 , alpha)
%CMTEST2 Two-sample Cramer-von Mises goodness-of-fit hypothesis test.
%   H = CMTEST2(X1,X2,ALPHA,TAIL) performs a Cramer-von Mises (K-S) test
%   to determine if independent random samples, X1 and X2, are drawn from
%   the same underlying continuous population. ALPHA is an optional
%   scalar input, which represents the desired significance level (default
%   = 0.05).
%   H indicates the result of
%   the hypothesis test:
%      H = 0 => Do not reject the null hypothesis at significance level ALPHA.
%      H = 1 => Reject the null hypothesis at significance level ALPHA.
%
%   Let F1(x) and F2(x) be the empirical distribution functions from sample
%   vectors X1 and X2, respectively. The 2-sample C-M test hypothesis and
%   test statistic is:
%
%   Null Hypothesis: F1(x) = F2(x) for all x
%	 Alternative:		F1(x) not equal to F2(x).
%   The test statistics is similar to T = ||F1(x) - F2(x)||_2 (L-2 norm of the difference)
%
%   The decision to reject the null hypothesis occurs when the P-value, 
%   equals or exceeds the significance level, ALPHA.
%   
%   The P-value computed here is the probability of the statistic T being
%   smaller or equal than its observed value To, under the null hypothesis
%   of both samples coming from the same underlying distribution. If the
%   this probability is small, it means that the observed value is
%   extraordinarily small. A small value of the statistic means that we
%   will have to accept Ho.
% 
%   X1 and X2 are row or column vectors of lengths N1 and N2, respectively,
%   and represent random samples from some underlying distribution(s).
%   Missing observations, indicated by NaN's (Not-a-Number), are ignored.
%
%   [H,P] = CMTEST2(...) also returns the asymptotic P-value P.
%
%   [H,P,CMSTAT] = CMTEST2(...) also returns the C-M test statistic CMSTAT  
%
%   The asymptotic P-value becomes very accurate for large sample sizes, and
%   is believed to be reasonably accurate for sample sizes N1 and N2 such
%   that (N1 + N2) >= 17.
%
%   See also KSTEST2, KSTEST, LILLIETEST, CDFPLOT.
%
%
% CopyLeft 2005 Juan Cardelino
%
% References:
%	(1) Anderson, T.W., "On the distribution of the two Sample Cramer-von Mises Criterion",
%			The Annals of Mathematical Statistics, Vol. 33, No. 3, Sep. 1962, pp. 1148-1159.
%	(2) Andersion, T.W.; Darling, D.A "Asymptotic Theory of Certain 'Goodness of Fit' Criteria 
%			Bases on Stochastic Processes"
%
% Last modification: 2009.05.23 Juan Cardelino

if nargin < 2
	error('stats:cmtest2:TooFewInputs','At least 2 inputs are required.');
end

% vebosity of display
verbose=0;

%
% Ensure each sample is a VECTOR.
%

[rows1 , columns1]  =  size(x1);
[rows2 , columns2]  =  size(x2);

if (rows1 ~= 1) & (columns1 ~= 1)
	error('stats:cmtest2:VectorRequired','Sample X1 must be a vector.');
end


if (rows2 ~= 1) & (columns2 ~= 1)
	error('stats:cmtest2:VectorRequired','Sample X2 must be a vector.');
end

%
% Remove missing observations indicated by NaN's, and
% ensure that valid observations remain.
%

x1  =  x1(~isnan(x1));
x2  =  x2(~isnan(x2));
x1  =  x1(:);
x2  =  x2(:);

if isempty(x1)
	error('stats:cmtest2:NotEnoughData',...
		'Sample vector X1 is composed of all NaN''s.');
end

if isempty(x2)
	error('stats:cmtest2:NotEnoughData',...
		'Sample vector X2 is composed of all NaN''s.');
end

%
% Ensure the significance level, ALPHA, is a scalar
% between 0 and 1 and set default if necessary.
%

if (nargin >= 3) & ~isempty(alpha)
	if prod(size(alpha)) > 1
		error('stats:cmtest2:BadAlpha',...
			'Significance level ALPHA must be a scalar.');
	end
	if (alpha <= 0 | alpha >= 1)
		error('stats:cmtest2:BadAlpha',...
			'Significance level ALPHA must be between 0 and 1.');
	end
else
	alpha  =  0.05;
end


%
% Calculate F1(x) and F2(x), the empirical (i.e., sample) CDFs.
%

binEdges    =  [-inf ; sort([x1;x2]) ; inf];

binCounts1  =  histc (x1 , binEdges);
binCounts2  =  histc (x2 , binEdges);

sumCounts1  =  cumsum(binCounts1)./sum(binCounts1);
sumCounts2  =  cumsum(binCounts2)./sum(binCounts2);

sampleCDF1  =  sumCounts1(1:end-1);
sampleCDF2  =  sumCounts2(1:end-1);
N1=length(x1);
N2=length(x2);
N=N1+N2;

if verbose
	fprintf('m1: %4.3f M1: %4.3f m2: %4.3f M2: %4.3f \n',min(sampleCDF1),max(sampleCDF1),min(sampleCDF2),max(sampleCDF2));
end

%
% Compute the test statistic of interest.
%
CMstatistic  =  N1*N2/N^2*sum((sampleCDF1 - sampleCDF2).^2);

% table of the limiting distribution, taken from (2)
z=[
	0.00000 0.02480 0.02878 0.03177 0.03430 0.03656 0.03865 0.04061 0.04247 0.04427 0.04601 0.04772 0.04939 0.05103 0.05265 0.05426 0.05586 0.05746 0.05904 0.06063 0.06222 0.06381 0.06541 0.06702 0.06863 ...
	0.07025 0.07189 0.07354 0.07521 0.07690 0.07860 0.08032 0.08206 0.08383 0.08562 0.08744 0.08928 0.09115 0.09306 0.09499 0.09696 0.09896 0.10100 0.10308 0.10520 0.10736 0.10956 0.11182 0.11412 0.11647 ...
	0.11888 0.12134 0.12387 0.12646 0.12911 0.13183 0.13463 0.13751 0.14046 0.14350 0.14663 0.14986 0.15319 0.15663 0.16018 0.16385 0.16765 0.17159 0.17568 0.17992 0.18433 0.18892 0.19371 0.19870 0.20392 ...
	0.20939 0.21512 0.22114 0.22748 0.23417 0.24124 0.24874 0.25670 0.26520 0.27429 0.28406 0.29460 0.30603 0.31849 0.33217 0.34730 0.36421 0.38331 0.40520 0.43077 0.46136 0.49929 0.54885 0.61981 0.74346 ...
	1.16786 ]';
Pz=[0:0.01:0.99 0.999]';

% for i=1:length(z)
% fprintf('%6.5f,',z(i));
% end
% fprintf('\n')

%keyboard

% Compute the asymptotic P-value approximation and accept or
% reject the null hypothesis on the basis of the P-value.
% we are using the approximated value given by the estimated mean and
% variance of the limiting distribution, see (1)


% compute parameters of the statistic's distribution
T_mean =1/6+1/6/(N);
T_var  =1/45*(N+1)/N^2 * ( 4*N1*N2*N-3*(N1^2+N2^2)-2*N1*N2 ) / (4*N1*N2);
% translate the T statistic into the limiting distribution
CM_limiting_stat =  ( CMstatistic - T_mean ) / sqrt(45*T_var) + 1/6; 
% interpolate
if CM_limiting_stat > z(end)
	pValue=1;
elseif CM_limiting_stat < z(1)
	pValue=0;
else
	pValue = interp1(z,Pz,CM_limiting_stat,'linear');
end
% test the hypothesis
H  =  alpha > 1-pValue;

if verbose
	fprintf('CM_stat: %6.5f CM_lim_stat: %6.5f\n',CMstatistic,CM_limiting_stat);
	fprintf('T_mean: %4.3f T_var: %4.3f \n',T_mean,T_var);
end
