function x = ACR(p,n,alpha);
%ACR Upper percentiles critical value for test of single multivariate normal outlier.
% From the method given by Wilks (1963) and approaching to a F distribution
% function by the Yang and Lee (1987) formulation, we provide an m-file to
% get the critical value of the maximun squared Mahalanobis distance to detect
% outliers from a normal multivariate sample.
%
% Syntax: function x = ACR(p,n,alpha) 
%   $$ The function's name is giving as a gratefull to Dr. Alvin C. Rencher for his
%      unvaluable contribution to multivariate statistics with his text 'Methods of 
%      Multivariate Analysis'.$$
%      
%     Inputs:
%          p - number of independent variables.
%          n - sample size.
%      alpha - significance level (default = 0.05).
%
%     Output:
%          x - critical value of the maximun squared Mahalanobis distance.
%
% We can generate all the critical values of the maximun squared Mahalanobis
% distance presented on the Table XXXII of by Barnett and Lewis (1978) and 
% Table A.6 of Rencher (2002). Also with any given significance level (alpha).
%
% Example: For p = 3; n = 25; alpha=0.01;
%
% Calling on Matlab the function: 
%                ACR(p,n,alpha)
%
% Answer is:
%
%     13.1753
%
%  Created by A. Trujillo-Ortiz, R. Hernandez-Walls, A. Castro-Perez and K. Barba-Rojo
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  Copyright. August 20, 2006.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A., R. Hernandez-Walls, A. Castro-Perez and K. Barba-Rojo. (2006).
%    ACR:Upper percentiles critical value for test of single multivariate normal outlier.
%    A MATLAB file. [WWW document]. URL http://www.mathworks.com/matlabcentral/
%    fileexchange/loadFile.do?objectId=12161
%
%  References:
%  Barnett, V. and Lewis, T. (1978), Outliers on Statistical Data.
%           New-York:John Wiley & Sons.
%  Rencher, A. C. (2002), Methods of Multivariate Analysis. 2nd. ed.
%            New-Jersey:John Wiley & Sons. Chapter 13 (pp. 408-450).
%  Wilks, S. S. (1963), Multivariate Statistical Outliers. Sankhya, 
%            Series A, 25: 407-426.
%  Yang, S. S. and Lee, Y. (1987), Identification of a Multivariate
%            Outlier. Presented at the Annual  Meeting of the American
%            Statistical Association, San Francisco, August 1987.
%

if nargin < 3,
   alpha = 0.05; %(default)
end; 

if (alpha <= 0 | alpha >= 1)
   fprintf('Warning: significance level must be between 0 and 1\n');
   return;
end;

if nargin < 2, 
   error('Requires at least two input arguments.');
   return;
end;

a = alpha;
Fc = finv(1-a/n,p,n-p-1); %F distribution critical value with p and n-p-1 degrees of freedom using the Bonferroni correction. 
ACR = (p*(n-1)^2*Fc)/(n*(n-p-1)+(n*p*Fc)); % = ((-1*((1/(1+(Fc*p/(n-p-1))))-1))*((n-1)^2))/n;
x = ACR;

return,