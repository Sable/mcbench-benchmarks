% Bonferroni-Holm (1979) correction for multiple comparisons.  This is a
% sequentially rejective version of the simple Bonferroni correction for multiple
% comparisons and strongly controls the family-wise error rate at level alpha.
%
% It works as follows:
% 1) All p-values are sorted in order of smallest to largest. m is the
%    number p-values.
% 2) If the 1st p-value is greater than or equal to alpha/m, the procedure
%    is stopped and no p-values are significant.  Otherwise, go on.
% 3) The 1st p-value is declared significant and now the second p-value is
%    compared to alpha/(m-1). If the 2nd p-value is greater than or equal 
%    to alpha/(m-1), the procedure is stopped and no further p-values are 
%    significant.  Otherwise, go on. 
% 4) Et cetera.
%
% As stated by Holm (1979) "Except in trivial non-interesting cases the 
% sequentially rejective Bonferroni test has strictly larger probability of
% rejecting false hypotheses and thus it ought to replace the classical 
% Bonferroni test at all instants where the latter usually is applied."
%
%
% function [corrected_p, h]=bonf_holm(pvalues,alpha)
%
% Required Inputs:
%  pvalues - A vector or matrix of p-values. If pvalues is a matrix, it can
%            be of any dimensionality (e.g., 2D, 3D, etc...).
%
% Optional Input:
%  alpha   - The desired family-wise alpha level (i.e., the probability of
%            rejecting one of more null hypotheses when all null hypotheses are
%            really true). {default: 0.05}
%
% Output:
%  corrected_p  - Bonferroni-Holm adjusted p-values. Any adjusted p-values
%                 less than alpha are significant (i.e., that null hypothesis 
%                 is rejected).  The adjusted value of the smallest p-value
%                 is p*m.  The ith smallest adjusted p-value is the max of
%                 p(i)*(m-i+1) or adj_p(i-1).  Note, corrected p-values can
%                 be greater than 1.
%  h            - A binary vector or matrix of the same dimensionality as
%                 pvalues.  If the ith element of h is 1, then the ith p-value
%                 of pvalues is significant.  If the ith element of h is 0, then
%                 the ith p-value of pvalues is NOT significant.
%
% Example:
% >>p=[.56 .22 .001 .04 .01]; %five hypothetical p-values
% >>[cor_p, h]=bonf_holm(p,.05)
% cor_p =
%    0.5600    0.4400    0.0050    0.1200    0.0400
% h =
%     0     0     1     0     1
% 
% Conclusion: the third and fifth p-values are significant, but not the
% remaining three.
%
% Reference:
% Holm, S. (1979) A simple sequentially rejective multiple test procedure.
% Scandinavian Journal of Statistics. 6, 65-70.
%
%
% For a review on contemporary techniques for correcting for multiple
% comparisons that are often more powerful than Bonferroni-Holm see:
%
%   Groppe, D.M., Urbach, T.P., & Kutas, M. (2011) Mass univariate analysis 
% of event-related brain potentials/fields I: A critical tutorial review. 
% Psychophysiology, 48(12) pp. 1711-1725, DOI: 10.1111/j.1469-8986.2011.01273.x 
% http://www.cogsci.ucsd.edu/~dgroppe/PUBLICATIONS/mass_uni_preprint1.pdf
%
%
% Author:
% David M. Groppe
% Kutaslab
% Dept. of Cognitive Science
% University of California, San Diego
% March 24, 2010


function [corrected_p, h]=bonf_holm(pvalues,alpha)

if nargin<1,
    error('You need to provide a vector or matrix of p-values.');
else
    if ~isempty(find(pvalues<0,1)),
        error('Some p-values are less than 0.');
    elseif ~isempty(find(pvalues>1,1)),
        fprintf('WARNING: Some uncorrected p-values are greater than 1.\n');
    end
end

if nargin<2,
    alpha=.05;
elseif alpha<=0,
    error('Alpha must be greater than 0.');
elseif alpha>=1,
    error('Alpha must be less than 1.');
end

s=size(pvalues);
if isvector(pvalues),
    if size(pvalues,1)>1,
       pvalues=pvalues'; 
    end
    [sorted_p sort_ids]=sort(pvalues);    
else
    [sorted_p sort_ids]=sort(reshape(pvalues,1,prod(s)));
end
[dummy, unsort_ids]=sort(sort_ids); %indices to return sorted_p to pvalues order

m=length(sorted_p); %number of tests
mult_fac=m:-1:1;
cor_p_sorted=sorted_p.*mult_fac;
cor_p_sorted(2:m)=max([cor_p_sorted(1:m-1); cor_p_sorted(2:m)]); %Bonferroni-Holm adjusted p-value
corrected_p=cor_p_sorted(unsort_ids);
corrected_p=reshape(corrected_p,s);
h=corrected_p<alpha;


