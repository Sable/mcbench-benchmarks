function [B,L,var,fac,E] = FA(X,s)
% FA Factor analysis (principal factoring technique)
%
% The reason to favour this method opposite to maximum likelihood 
% (Statistics toolbox) is no distributional assumptions. In comparison to
% SPSS program, this provides the same results. We expect identical
% numerical solution, especially advantage of singular value decomposition.
% Initial estimates of communalities are set as squared multiple
% correlations. In iteration process (convergence criterium 0.001, limit
% for iteration 75), communalities are set to one if Heywood case occurs. 
% The loadings are rotated (normalized varimax rotation, convergence 
% criterium 0.00001, iteration limit 35). Estimate of rotated factors is
% based on regression approach.
% 
% [B,L,var,fac,E] = FA(X,s)
%
% Inputs: 
%   X is the data matrix (columns as variables, X must have more
%     than one row and more than one column).
%
%   s is the number of extracted factors (if this parameter is
%     not included, number is chosen by principal component 
%     criterion with eigenvalues greater than or equal to one).
%
% Results: 
%   B is the matrix of factor loadings (unrotated), last column
%     of matrix B indicates an extraction estimate of 
%     communalities.
%
%   L is the varimax rotated loadings matrix.
%
%   var describes the variability proportions, last item is
%     the cumulative variance proportion.
%
%   fac is the matrix of factors.
%   
%   E is the matrix of specific variances.
%
% Example: From the data containing temperature, relative humidity, wind
% speed, radiation, NO/NO2 ratio and ozone gained in boundary layer
%  [B,L,var] = FA(X,3)
%   The number of factors extracted: 3
%   Factorial number of iterations: 14
%   Rotational number of iterations: 5
%
%     B =
%        -0.962    0.145    0.088    0.954
%         0.964   -0.065   -0.230    0.986
%        -0.551    0.189    0.061    0.343
%        -0.557    0.422   -0.444    0.685
%         0.718    0.649    0.238    0.994
%        -0.975   -0.077    0.081    0.963
%
%     L =
%        -0.850   -0.308   -0.370
%         0.913    0.322    0.220
%        -0.516   -0.087   -0.262
%        -0.291   -0.083   -0.771
%         0.297    0.948    0.087
%        -0.807   -0.495   -0.258
%
%     var =
%         0.441    0.226    0.154    0.821
%
% The biggest values of rotated loadings points dependence of tempetature,
% relative humidity, wind speed and ozone in the first factor and NO/NO2 
% ratio with ozone in another.
%
% Communalities show the biggest relation of NO/NO2 ratio to the others. Be
% careful, variances need not be in decreasing order.
%
% For citation ensue following format: Malec L., Skacel F., Trujillo-Ortiz
% A.(2007). FA: Factor analysis by principal factoring. A MATLAB file. 
% [WWW document]. URL http://www.mathworks.com/matlabcentral/fileexchange/
% loadFile.do?objectId=14115
%
% Golub G. H., Van Loan C. F.: Matrix Computations. The Johns Hopkins
% University Press, Baltimore 1996.
% Harman H. H.: Modern Factor Analysis. The University of Chicago Press,
% Chicago 1976.
% Krzanowski W. J.: Principles of Multivariate Analysis. Oxford University
% Press, Oxford 2003.
%
% Copyright. February 26, 2007.


[m,n] = size(X);

if nargin==2 && n<s
  error 'The number of factors requested(s) is too large'
end

% Variables standardization and evaluation of correlation matrix.
e = ones(m,1);
X = (X - e * mean(X)) ./ (e * std(X));
R = cov(X);

% Maximization of variance of original variables.
a = svd(R,0);

% Number of factors according roots of principal components.
if nargin<2
   f = a>=1;
   s = sum(f);
end

fprintf ('The number of factors extracted: %.i\n', s);

% Communality estimation by coefficients of multiple correlation.
c = ones(n,1) - 1 ./ diag(R \ diag(ones(n,1)));
g = [];

% Iteration cycle which maximizes factors correlations.
for k = 1:75
    [U,D,V] = svd(R - diag(diag(R)) + diag(c),0);
    N = V * sqrt(D(:,1:s));
    p = c;
    c = sum(N.^2,2);
    g = [g find(c>1)']; % Heywood case in communality estimates.
    c(g) = 1;
    if max(abs(c - p))<0.001
       break
    end
end

fprintf ('Factorial number of iterations: %.i\n', k);

% Evaluation of factor loadings and communalities estimations.
B = [N c];

% Normalization of factor loadings.
h = sqrt(c);
N = N ./ repmat(h,1,s);

% Initial choice of eigenvalues and loadings labelling.
L = N;
z = 0;

% Iteration cycle maximizing variance of individual columns.
for l = 1:35
    [A,S,M] = svd(N' * (n * L.^3 - L * diag(sum(L.^2))),0);
    L = N * A * M';
    b = z;
    z = sum(diag(S));
    if abs(z - b)<0.00001
       break
    end    
end

fprintf ('Rotational number of iterations: %.i\n', l);

% Unnormalization of factor loadings.
L = L .* repmat(h,1,s);

% Factors computation by regression and variance proportions.
t = sum(L.^2) / n;
var = [t sum(t)];
fac = X * (R \ diag(ones(n,1))) * L;

% Evaluation of given factor model variance specific matrix. 
r = diag(R) - sum(L.^2,2);
E = R - L * L' - diag(r);

