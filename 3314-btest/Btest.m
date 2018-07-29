function [Btest] = Btest(X,alpha)
%Bartlett's Test for Homogeneity of Variances.
%
%   Syntax: function [Btest] = Btest(X,alpha) 
%      
%     Inputs:
%          X - data matrix (Size of matrix must be n-by-2; data=column 1, sample=column 2). 
%       alpha - significance level (default = 0.05).
%     Outputs:
%          - Sample variances vector.
%          - Whether or not the homoscedasticity was met.
%
%    Example: From the example 10.13 of Zar (1999, p. 202-203), to test the Bartlett's
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
%             BFtest(X)
%
%       Answer is:
%
% The number of samples are: 4
%
% ----------------------------
% Sample    Size      Variance
% ----------------------------
%   1        5         9.3920
%   2        5         8.5650
%   3        4         7.6567
%   4        5         8.3880
% ----------------------------
%   
% Bartlett's Test for Equality of Variances X2=0.0328, df= 3, F= 0.0109, df1= 3, df2=14
% Probability associated to the Chi-squared statistic = 0.9984
% The associated probability for the Chi-squared test is equal or larger than 0.05
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
%  April 20, 2003.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). Btest: Bartlett's test for 
%    homogeneity of variances. A MATLAB file. [WWW document]. URL http://www.mathworks.com/
%    matlabcentral/fileexchange/loadFile.do?objectId=3314&objectType=FILE
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

n=[];s2=[];
indice=X(:,2);
for i=1:k
   Xe=find(indice==i);
   eval(['X' num2str(i) '=X(Xe,1);']);
   eval(['n' num2str(i) '=length(X' num2str(i) ') ;']);
   eval(['s2' num2str(i) '=(std(X' num2str(i) ').^2) ;']);
   eval(['xn= n' num2str(i) ';']);
   eval(['xs2= s2' num2str(i) ';']);
   n=[n;xn];s2=[s2;xs2];
end

fprintf('-----------------------------\n');
disp(' Sample    Size      Variance')
fprintf('-----------------------------\n');
for i=1:k
   fprintf('   %d       %2i         %.4f\n',i,n(i),s2(i))
end
fprintf('-----------------------------\n');
disp(' ')

%Bartlett's Procedure.
deno=sum(n)-k;
suma=0;
for i=1:k
   eval(['suma =suma + (n' num2str(i) '-1)*s2' num2str(i) ';']);
end
Sp=suma/deno;
Falta=0;
for i=1:k
   eval(['Falta =Falta + (n' num2str(i) '-1)*log(s2' num2str(i) ');']);
end
B=((sum(n)-k)*log(Sp))-Falta;
suma1=0;
for i=1:k
   eval(['suma1=suma1 + 1/(n' num2str(i) '-1);']);
end
suma2=0;
for i=1:k
   eval(['suma2=suma2 + 1/((n' num2str(i) '-1)^2);']);
end
C=1+((1/(3*(k-1)))*(suma1-(1/deno)));
X2=B/C; %Chi-squared-statistic.
v=k-1; %degrees of freedom.
F=X2/v; %F-statistic.
P = 1 - chi2cdf(X2,v);  %probability associated to the Chi-squared-statistic.
df=v;
df1=v;df2=sum(n)-k-1;

fprintf('Bartlett''s Test for Equality of Variances X2=%3.4f, df=%2i, F=%7.4f, df1=%2i, df2=%2i\n', X2,df,F,df1,df2);
fprintf('Probability associated to the Chi-squared statistic = %3.4f\n', P);

if P >= alpha;
  fprintf('The associated probability for the Chi-squared test is equal or larger than% 3.2f\n', alpha);
  fprintf('So, the assumption of homoscedasticity was met.\n');
else
  fprintf('The associated probability for the Chi-squared test is smaller than% 3.2f\n', alpha);
  fprintf('So, the assumption of homoscedasticity was not met.\n');
end