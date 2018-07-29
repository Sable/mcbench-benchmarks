function [DagosPtest] = DagosPtest(X,alpha)
% D'Agostino-Pearson's K2 test for assessing normality of data using skewness and kurtosis.
%
%   Syntax: function [DagosPtest] = DagosPtest(X,alpha) 
%      
%     Inputs:
%          X - data vector. 
%       alpha - significance level (default = 0.05).
%
%     Outputs:
%          - Whether or not the normality is met.
%
%
%    Example: From the example 6.8 of Zar (1999, p.89), we are interested to test 
%             whether or not the data are normally distributed using the D'Agostino-
%             Pearson test with a significance level = 0.05.
%
%                       x       Frequency
%                   ----------------------
%                      63           2
%                      64           2
%                      65           3
%                      66           5
%                      67           4
%                      68           6
%                      69           5
%                      70           8
%                      71           7
%                      72           7
%                      73          10
%                      74           6
%                      75           3
%                      76           2
%                   ----------------------
%                                       
%           Data matrix must be:
%      X=[63;63;64;64;65;65;65;66;66;66;66;66;67;67;67;67;68;68;68;68;68;68;69;69;69;69;69;
%      70;70;70;70;70;70;70;70;71;71;71;71;71;71;71;72;72;72;72;72;72;72;73;73;73;73;73;73;
%      73;73;73;73;74;74;74;74;74;74;75;75;75;76;76];
%
%     Calling on Matlab the function: 
%             DagosPtest(X)
%
%       Answer is:
%
% D'Agostino-Pearson's test to assessing normality: X2= 3.1397, df= 2
% Probability associated to the Chi-squared statistic = 0.2081
% The sampled population is normally distributed.   
%
%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  September 11, 2003.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). DagosPtest: D'Agostino-Pearson's K2 test for 
%    assessing normality of data using skewness and kurtosis. A MATLAB file. [WWW document]. URL 
%    http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=3954&objectType=FILE
%
%  References:
% 
%  Zar, J. H. (1999), Biostatistical Analysis (2nd ed.).
%           NJ: Prentice-Hall, Englewood Cliffs. p. 89. 
%

if nargin < 2,
   alpha = 0.05;
end 

if (alpha <= 0 | alpha >= 1)
   fprintf('Warning: significance level must be between 0 and 1\n');
   return;
end

if nargin < 1, 
   error('Requires at least one input argument.');
   return;
end;

X = sort(X);
X = X(:);
n = length(X);

[c,v]=hist(X,X);  %record of data in a frequency table form
nc=find(c~=0);
c=[v(nc) c(nc)'];

x = c(:,1);
f = c(:,2);
s1 = f'*x;
s2 = f'*x.^2;
s3 = f'*x.^3;
s4 = f'*x.^4;
SS = s2-(s1^2/n);
v = SS/(n-1);
k3 = ((n*s3)-(3*s1*s2)+((2*(s1^3))/n))/((n-1)*(n-2));
g1 = k3/sqrt(v^3);
k4 = ((n+1)*((n*s4)-(4*s1*s3)+(6*(s1^2)*(s2/n))-((3*(s1^4))/(n^2)))/((n-1)*(n-2)*(n-3)))-((3*(SS^2))/((n-2)*(n-3)));
g2 = k4/v^2;
eg1 = ((n-2)*g1)/sqrt(n*(n-1));  %measure of skewness
eg2 = ((n-2)*(n-3)*g2)/((n+1)*(n-1))+((3*(n-1))/(n+1));  %measure of kurtosis

A = eg1*sqrt(((n+1)*(n+3))/(6*(n-2)));
B = (3*((n^2)+(27*n)-70)*((n+1)*(n+3)))/((n-2)*(n+5)*(n+7)*(n+9));
C = sqrt(2*(B-1))-1;
D = sqrt(C);
E = 1/sqrt(log(D));
F = A/sqrt(2/(C-1));
Zg1 = E*log(F+sqrt(F^2+1));

G = (24*n*(n-2)*(n-3))/((n+1)^2*(n+3)*(n+5));
H = ((n-2)*(n-3)*abs(g2))/((n+1)*(n-1)*sqrt(G));
J = ((6*(n^2-(5*n)+2))/((n+7)*(n+9)))*sqrt((6*(n+3)*(n+5))/((n*(n-2)*(n-3))));
K = 6+((8/J)*((2/J)+sqrt(1+(4/J^2))));
L = (1-(2/K))/(1+H*sqrt(2/(K-4)));
Zg2 = (1-(2/(9*K))-L^(1/3))/sqrt(2/(9*K));

K2 = Zg1^2 + Zg2^2;  %D'Agostino-Pearson statistic
X2 = K2;  %approximation to chi-distribution
df = 2;  %degrees of freedom

P = 1-chi2cdf(X2,df);  %probability associated to the chi-squared statistic
fprintf('D''Agostino-Pearson''s test to assessing normality: X2= %3.4f, df=%2i\n', X2,df);
fprintf('Probability associated to the chi-squared statistic = %3.4f\n', P);
fprintf('With a given significance = %3.3f\n', alpha);
if P >= alpha;
   disp('The sampled population is normally distributed.');
else
   disp('The sampled population is not normally distributed.');
end

return,