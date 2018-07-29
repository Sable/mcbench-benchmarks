function [A,B] = kmo(X)
%KMO Kaiser-Meyer-Olkin Measure of Sampling Adequacy.
% Factor analysis can be used as a guide to how coherently a set of variables
% relate to a hypothesized underlying dimension that they are all being used
% to measure. External validity analysis assesses whether the scale that has
% been constructed performs as theoretically expected in correlation with
% other variables to which it is expected to be related.
% There are some assumptions about the characteristics of factors that are
% extracted and defined that are unobserved common dimensions that may be
% listed to account for the correlations among observed variables. Sampling
% adequacy predicts if data are likely to factor well, based on correlation
% and partial correlation. Is used to assess which variables to drop from the
% model because they are too multicollinear.
% It has been suggested that inv(R) should be a near-diagonal matrix in order
% to successfully fit a factor analysis model.  To assess how close inv(R)
% is to a diagonal matrix, Kaiser (1970) proposed a measure of sampling
% adequacy, now called KMO (Kaiser-Meyer-Olkin) index. The common part, called
% the image of a variable, is defined as that part which is predictable by
% regressing each variable on all other variables.
% The anti-image is the specific part of the variable that cannot be predicted.
% Examining the anti-image of the correlation matrix. That is the negative of the
% partial correlations, partialling out all other variables.
% There is a KMO statistic for each individual variable and their sum is
% the overall statistic. If it is not > 0.6 drop the indicator variables with
% the lowest individual statistic value until the overall one rises above 0.6:
% factors which is meritorious. The diagonal elements on the Anti-image 
% correlation matrix are the KMO individual statistics for each variable. A KMO
% index <= 0.5 indicates the correlation matrix is not suitable for factor
% analysis.
%
% Syntax: function kmo(X) 
%      
%     Input:
%          X - Input matrix can be a data matrix (size n-data x p-variables)
%     Output(s):
%            - Kaiser-Meyer-Olkin Index.
%            - Degree of Common Variance Report (shared by a set of variables
%              and thus assesses the degree to which they measure a common
%              underlying factor).
%        optional(s):
%            - Anti-image Covariance Matrix.
%            - Anti-image Correlation Matrix
%
%  Example: From the example given on the web page
%  http://www.ncl.ac.uk/iss/statistics/docs/factoranalysis.html
%  We are interested to calculate the Kaiser-Meyer-Olkin measure of sampling
%  adequacy in order to see if proceeds a satisfactory factor analysis to
%  investigate the reasons why customers buy a product such as a particular
%  brand of soft drink (e.g. coca cola). Several variables were identified
%  which influence customer to buy coca cola. Some of the variables identified
%  as being influential include availability of product (X1), cost of product
%  (X2), experience with product (X3), popularity of product (X4), prestige
%  attached to product (X5), quality of product (X6), quantity of product (X7),
%  and respectability of product (X8). From this, you designed a questionnaire
%  to solicit customers' view on a seven point scale, where 1 = not important
%  and 7 = very important. The results from your questionnaire are show on the
%  table below. Only the first twelve respondents (cases) are used in this
%  example. 
%
%  Table 1: Customer survey
%  --------------------------------------------------
%     X1    X2    X3    X4    X5    X6    X7    X8   
%  --------------------------------------------------
%      4     1     4     5     2     3     6     7
%      4     2     7     6     6     3     3     4
%      6     4     3     4     2     5     7     7
%      5     3     5     4     3     4     6     7
%      5     2     4     5     2     5     5     6
%      6     3     3     5     4     4     7     7
%      6     2     4     4     4     3     4     5
%      4     1     3     4     3     3     5     6
%      5     3     4     3     4     3     6     6
%      5     4     3     4     4     4     6     7
%      6     2     4     4     4     3     7     5
%      5     2     3     3     3     3     7     6  
%  --------------------------------------------------
%
% Data matrix must be:
%  X=[4 1 4 5 2 3 6 7;4 2 7 6 6 3 3 4;6 4 3 4 2 5 7 7;5 3 5 4 3 4 6 7;
%  5 2 4 5 2 5 5 6;6 3 3 5 4 4 7 7;6 2 4 4 4 3 4 5;4 1 3 4 3 3 5 6;
%  5 3 4 3 4 3 6 6;5 4 3 4 4 4 6 7;6 2 4 4 4 3 7 5;5 2 3 3 3 3 7 6];
%
%  Calling on Matlab the function: 
%            kmo(X)
%
%  Answer is:
%
%  Kaiser-Meyer-Olkin Measure of Sampling Adequacy: 0.4172
%  The KMO test yields a degree of common variance unacceptable (Don't Factor).
%
%
%  Created by A. Trujillo-Ortiz, R. Hernandez-Walls, A. Castro-Perez, 
%             K. Barba-Rojo and A. Otero-Limon
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%
%  Copyright. October 10, 2006.
%
% To cite this file, this would be an appropriate format:
% Trujillo-Ortiz, A., R. Hernandez-Walls, A. Castro-Perez, K. Barba-Rojo 
%   and A. Otero-Limon (2006). kmo:Kaiser-Meyer-Olkin Measure of Sampling
%   Adequacy. A MATLAB file. [WWW document]. URL http://www.mathworks.com/
%   matlabcentral/fileexchange/loadFile.do?objectId=12736
%
%  References:
%  Rencher, A. C. (2002), Methods of Multivariate Analysis. 2nd. ed.
%            New-Jersey:John Wiley & Sons. Chapter 13 (pp. 408-450).
%

error(nargchk(1,1,nargin));
msg = nargoutchk(1, 2, nargout);

X = corrcoef(X);

iX = inv(X);
S2 = diag(diag((iX.^-1)));
AIS = S2*iX*S2; %anti-image covariance matrix
IS = X+AIS-2*S2; %image covariance matrix
Dai = diag(diag(sqrt(AIS)));
IR = inv(Dai)*IS*inv(Dai); %image correlation matrix
AIR = inv(Dai)*AIS*inv(Dai); %anti-image correlation matrix
a = sum((AIR - diag(diag(AIR))).^2);
AA = sum(a);
b = sum((X - eye(size(X))).^2);
BB = sum(b);
MSA = b./(b+a); %measures of sampling adequacy
AIR = AIR-eye(size(AIR))+diag(MSA);
%Examine the anti-image of the correlation matrix. That is the negative of the partial correlations,
%partialling out all other variables.
N = BB;
D = AA+BB;
kmo = N/D;

disp(' ')
fprintf('Kaiser-Meyer-Olkin Measure of Sampling Adequacy: %3.4f\n', kmo);
if (kmo >= 0.00 && kmo < 0.50);
    disp('The KMO test yields a degree of common variance unacceptable (Don''t Factor).')
elseif (kmo >= 0.50 && kmo < 0.60);
    disp('The KMO test yields a degree of common variance miserable.')
elseif (kmo >= 0.60 && kmo < 0.70);
    disp('The KMO test yields a degree of common variance mediocre.')
elseif (kmo >= 0.70 && kmo < 0.80);
    disp('The KMO test yields a degree of common variance middling.')
elseif (kmo >= 0.80 && kmo < 0.90);
    disp('The KMO test yields a degree of common variance meritorious.')
else (kmo >= 0.90 && kmo <= 1.00);
    disp('The KMO test yields a degree of common variance marvelous.')
end

if nargout == 1;
    disp(' ')
    disp('A = Anti-image covariance matrix.');    
    A = AIS;
elseif nargout > 1;
    disp(' ')
    disp('A = Anti-image covariance matrix.');
    A = AIS;
    disp('B = Anti-image correlation matrix.');
    B = AIR;
end

return,