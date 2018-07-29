function [Cochtest]=Cochtest(X,alpha)
%Cochran's test for homogeneity of variances for equal or unequal sample sizes.
%[It calls to the Cochran's cunulative distribution function cochcdf(C,k,v).]
%   The use of the function. Let C is a set of k Chi-squared 
%   distributed sums of squares (or the corresponding variances), 
%   each of v degrees of freedom. To accept at a significance
%   level (alpha) that the maximum variance differ from the other ones, 
%   one should examine:
%   P <= alpha
%   where, P=1-cochpdf(C,k,v) and C=max(s2)/sum(s2).
%
%
%   Syntax: function [Cochtest]=Cochtest(X,alpha) 
%      
%     Inputs:
%          X - data matrix (Size of matrix must be n-by-2; data=column 1, sample=column 2). 
%       alpha - significance level (default = 0.05).
%     Outputs:
%          - Sample variances vector.
%          - Whether or not the homoscedasticity was met.
%
%    Example: From the example 10.13 of Zar (1999, p. 202-203), to test the Cochran's
%             homoscedasticity of data with a significance level = 0.05.
%
%                                 Diet
%                   ---------------------------------
%                       1       2       3       4
%                   ---------------------------------
%                     60.8    68.7   102.6    87.9
%                     57.0    67.7   102.1    84.2
%                     65.0    74.0   100.2    83.1
%                     58.6    66.3    96.5    85.7
%                     61.7    69.8            90.3
%                   ---------------------------------
%                                       
%           Data matrix must be:
%            X=[60.8 1;57.0 1;65.0 1;58.6 1;61.7 1;68.7 2;67.7 2;74.0 2;66.3 2;69.8 2;
%            102.6 3;102.1 3;100.2 3;96.5 3;87.9 4;84.2 4;83.1 4;85.7 4;90.3 4];
%
%     Calling on Matlab the function: 
%             Cochtest(X)
%
%       Answer is:
%
% The number of samples are: 4
%
% Sample    Size      Variance
%   1        5         9.3920
%   2        5         8.5650
%   3        4         7.6567
%   4        5         8.3880
%   
% Cochran's Test for Equality of Variances C = 0.2762
% Probability associated to the Cochran's statistic = 0.4719
% The associated probability for the Cochran' test is equal or larger than 0.05
% So, the assumption of homoscedasticity was met.     
%

%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  April 21, 2003.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). Cochtest: Cochran's test for 
%    homogeneity of variances for equal or unequal sample sizes. A MATLAB file. 
%    [WWW document]. URL http://www.mathworks.com/matlabcentral/fileexchange/
%    loadFile.do?objectId=3292&objectType=FILE 
%
%  References:
% 
%  Zar, J. H. (1999), Biostatistical Analysis (2nd ed.).
%           NJ: Prentice-Hall, Englewood Cliffs. p. 202-203. 
%

if nargin < 2,
   alpha = 0.05;
end 

k=max(X(:,2));
fprintf('The number of samples are:%2i\n\n', k);

n=[];n2=[];s2=[];
indice=X(:,2);
for i=1:k
   Xe=find(indice==i);
   eval(['X' num2str(i) '=X(Xe,1);']);
   eval(['n' num2str(i) '=length(X' num2str(i) ') ;']);
   eval(['n2' num2str(i) '=(length(X' num2str(i) ').^2);']);
   eval(['s2' num2str(i) '=(std(X' num2str(i) ').^2) ;']);
   eval(['xn= n' num2str(i) ';']);
   eval(['xn2= n2' num2str(i) ';']);
   eval(['xs2= s2' num2str(i) ';']);
   n=[n;xn];n2=[n2;xn2];s2=[s2;xs2];
end

disp(' Sample    Size      Variance')
for i=1:k
   fprintf('   %d       %2i         %.4f\n',i,n(i),s2(i))
end
disp(' ')

%Cochran's test procedure.
C=max(s2)/sum(s2); %Cochran's C statistic.
v=k-1;
no=(1/v)*(sum(n)-(sum(n2)/sum(n))); %procedure for equal or unequal sample sizes.
v=round(no)-1; %sample degrees of freedom.
P=1-cochcdf(C,k,v); %probability associated to the Cochran's C statistic.

fprintf('Cochran''s Test for Equality of Variances C = %3.4f\n', C);
fprintf('Probability associated to the Cochran''s statistic = %3.4f\n', P);

if P >= alpha;
  fprintf('The associated probability for the Cochran'' test is equal or larger than% 3.2f\n', alpha);
  fprintf('So, the assumption of homoscedasticity was met.\n');
else
  fprintf('The associated probability for the Cochran''s test is smaller than% 3.2f\n', alpha);
  fprintf('So, the assumption of homoscedasticity was not met.\n');
end
