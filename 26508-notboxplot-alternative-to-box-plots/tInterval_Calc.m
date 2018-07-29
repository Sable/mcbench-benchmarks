function tint=tInterval_Calc(vect, CI)
% tInterval_Calc - confidence interval based on the t-distribution
%
% function tint=tInterval_Calc(vect, CI)
%
% Purpose
% Calculate the t-interval about the mean to a given confidence
% level (CI). Note that nans do not contribute to the calculation
% of the sample size and are ignored for the SD calculation. Output
% of this function has been checked against  known working code
% written in R. 
%
% Inputs
% - vect: Calculates the two-tailed 95% t confidence limits for the mean.
%
% - CI [optional]: a p value for a different 2-tailed interval. e.g. 0.01
%
% Example - plot a 1% interval [rather than the default %5]
% r=randn(1,30);
% T=tInterval_calc(r,0.01);
% hist(r)
% hold on
% plot(mean(r), mean(ylim),'r*')
% plot([mean(r)-T,mean(r)+T], [mean(ylim),mean(ylim)],'r-')
% hold off
%
% Rob Campbell - 12/03/08
%
% Also see - SEM_calc, tinv

error(nargchk(1,2,nargin))

if isvector(vect)
  vect=vect(:);
end


if nargin==1
  CI = 0.025; %If no second argument, work out a 2-tailed 5% t-interval
  stdCI=tinv(1-CI, length(vect)-1);
elseif nargin==2
  CI = CI/2 ; %Convert to 2-tail
  stdCI=tinv(1-CI, length(vect)-1); %Based on the t distribution
end

if stdCI==0
  error('Can''t find confidence iterval for 0 standard deviations!')
end
  

tint =  ( (nanstd(vect)) ./ sqrt(sum(~isnan(vect))) ) * stdCI ;    

