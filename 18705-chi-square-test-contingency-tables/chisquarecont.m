function [p,x2] = chisquarecont(contab)

%
% CHISQUARECONT takes as input a 2x2 matrix that represents a 2x2 contingency table and
% calculates the probability of obtaining the observed and each of the more extreme tables
% based on the pearson chi square test which is based on the chi square distribution. The
% chi square test might become unreliable when the total number of expected frequencies
% (cell values in the contingency table) are not large enough (the total is smaller than
% 20 or a cell contains a value lower than 5). In such cases, the Fisher exact test should
% be used instead.
% 
% Usage : p = chisquarecont(contab)
%         [p,x2] = chisquarecont(contab) 
%
% Input  : contab -> a 2x2 contigency table created from the frequency data
% Output : p      -> The p-value of the test (the probability of obtaining the observed
%                    and each of the more extreme tables)
%          x2     -> The value for the chi square statistic
%
% The following example was taken from http://cnx.org/content/m13488/latest/
%
% The frequency matrix in this case is:
%
% |---------------------------------------------------------------------------------|
% |             | Alzheimer during  5-year NO | Alzheimer during 5-year YES | Total | 
% |---------------------------------------------------------------------------------|
% |Estrogen YES |              147            |               9             |  156  |
% |---------------------------------------------------------------------------------|
% |Estrogen  NO |              810            |              158            |  968  |
% |---------------------------------------------------------------------------------|
% |Total        |              957            |              167            | 1124  |
% |---------------------------------------------------------------------------------|
%
% so we get contab = [147 9;810 158];
%
% Now, executing [p x2] = chisquarecont(contab) will return:
%
% p = 5.8359e-004
% 
% x2 = 11.8276
% 
% The following interpretation of the result is taken from http://cnx.org/content/m13488/latest/
% 
% The calculated value of  x2=11.8276 exceeds the value of the chi square cumulative 
% distribution function (10.83) required for significance at the 0.001 level (we found
% p=5.8359e-004<0.001), hence we can say that the observed result is significant beyond 
% the 0.001 level. That is: if the null hypothesis were true if estrogen supplementation
% were unrelated to the onset of Alzheimer's disease in post-menopausal women the 
% likelihood of obtaining a differential onset rate as great as the one observed (158 
% versus 9), by mere chance coincidence, would be smaller than one-tenth of one percent.
% The investigators can therefore reject the null hypothesis with a high degree of 
% confidence.
%
% To execute this function, you need the Statistics Toolbox. 
%
% See also CHI2CDF
%
% Author     : Panagiotis Moulos (pmoulos@eie.gr)
% Created on : February 11, 2008
%

% Check input arguments
if ~all(size(contab)==[2 2])
    error('ChiSquareCont:BadInput','You must provide a 2x2 table as input!')
end

% Issue a warning statement if the total frequencies are <20 or a cell value is <5.
if sum(sum(contab))<20 || ~all(all(contab>5))
    wmsg=['The contigency table contains a cell with value<5 or the total sum of values is <20. ',...
         'You should consider using the Fisher exact test instead.'];
    warning('ChiSquareCont:Unreliable',wmsg);
end

% Calculate expected values
e=zeros(1,4);
tot=sum(sum(contab));
e(1)=(contab(1,1)+contab(1,2)).*(contab(1,1)+contab(2,1))/tot;
e(2)=(contab(1,1)+contab(1,2)).*(contab(1,2)+contab(2,2))/tot;
e(3)=(contab(2,1)+contab(2,2)).*(contab(1,1)+contab(2,1))/tot;
e(4)=(contab(2,1)+contab(2,2)).*(contab(1,2)+contab(2,2))/tot;

% Calculate chi square statistic
o=reshape(contab',1,4);
x2=sum((o-e).^2./e);

% Find p-value (1 degree of freedom)
p=1-chi2cdf(x2,1);
