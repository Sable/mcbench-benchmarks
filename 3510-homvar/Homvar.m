function [Homvar] = Homvar(X,alpha)
%HOMVAR gives several homoscedasticity tests as Bartlett, Cochran, Brown-Forsythe, Levene,
%O'Brien and Welch to choose from any of the following functions: Btest, Cochtest, BFtest,
%Levenetest, OBrientest and Wtest.
%
%Homogeneity of variances test's menu.
%
%   Syntax: function [Homvar] = Homvar(X,alpha) 
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
%             Homvar(X)
%
%       Answer is:
%
%  Homoscedasticity tests menu:
%  1) Bartlett
%  2) Cochran
%  3) Brown-Forsythe
%  4) Levene
%  5) O'Brien
%  6) Welch
%  Which test do you want?: 2
% 
%  The number of samples are: 4
%
% -----------------------------
%  Sample    Size      Variance
% -----------------------------
%    1        5         9.3920
%    2        5         8.5650
%    3        4         7.6567
%    4        5         8.3880
% -----------------------------
% 
%  Cochran's Test for Equality of Variances C=0.2762
%  Probability associated to the Cochran's statistic = 0.4719
%  The associated probability for the Cochran' test is equal or larger than 0.05
%  So, the assumption of homoscedasticity was met.
%

%  Created by A. Trujillo-Ortiz and R. Hernandez-Walls
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  May 15, 2003.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A. and R. Hernandez-Walls. (2003). Homvar: Homogeneity of variances
%    tests menu. A MATLAB file. [WWW document]. URL http://www.mathworks.com/matlabcentral/
%    fileexchange/loadFile.do?objectId=3510&objectType=FILE
%
%  References:
% 
%  Zar, J. H. (1999), Biostatistical Analysis (2nd ed.).
%           NJ: Prentice-Hall, Englewood Cliffs. p. 202-203. 
%

if nargin < 2, 
    alpha = 0.05; 
end 

if nargin < 1, 
   error('Requires at least one input argument.'); 
end 

disp('Homoscedasticity tests menu:')
disp('1) Bartlett')
disp('2) Cochran')
disp('3) Brown-Forsythe')
disp('4) Levene')
disp('5) O''Brien')
disp('6) Welch')
option=input('Which test do you want?: ');
disp(' ')
switch  option
case 1,
   %option1: Bartlett's test
   Btest(X,alpha);
case 2,
   %option2: Cochran's test
   Cochtest(X,alpha);
case 3,
   %option3: Brown-Forsythe's test
   BFtest(X,alpha);
case 4,
   %option4: Levene's test
   Levenetest(X,alpha);
case 5,
   %option5: O'Brien's test
   OBrientest(X,alpha);
case 6,
   %option6: Welch's test
   Wtest(X,alpha);
end

