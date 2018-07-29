function [acapewod] = acapewod(X,alpha)
% ACAPE Canonical Correlation Analysis (CCA) Without Data.
%Computes the interrelationships between two sets of variables made on the same objects.
%The canonical correlation is the maximum correlation between linear functions of the two
%vector variables. Linearity is important because the analysis is performed on the correlation
%matrix which reflect linear relationships. After this there may to locate additional pairs 
%of functions that maximally correlate, subject to the restriction that the functions in each
%new pair must be uncorrelated with all previously located functions in both domains (orthogonal).
%Geometrically, the canonical model can be considered an exploration of the extent to which 
%objects occupy the same relative positions in one measurement space as they do in the other.
%With p predictor and q criterion variables, we have min(p,q) of canonical coefficients.
%A complete procedure follows with a test of significance of canonical correlations through
%the Bartlett's test.
%
%   Syntax: function [acapewod] = acapewod(X,alpha) 
%      
%     Inputs:
%            X - input matrix [covariance or correlation]
%                (Size of matrix must be p+q-by-p+q). 
%        alpha - significance (default = 0.05).
%     Outputs:
%              - Canonical functions.
%              - Correlations between the canonical and original variables.
%              - Proportion of variance extracted.
%              - Redundancy.
%              - Chi-square tests with successive roots removed.
%
%
%    Example: From the example 9.1 of Manly (1994, p. 120), it is of interest to
%             investigate the relationships between 5 genetic (p) and 4 environmental
%             (q) variables for 16 colonies of the butterfly Euphydryas editha in 
%             California and Oregon (q <= p). It is provided the correlation matrix 
%             in the specified order p+q.
%
%          X=[1.0000  0.8548  0.6176  -0.5316  -0.5055  -0.2025  -0.5303  0.2953  0.2212
%           0.8548  1.0000  0.6153  -0.5478  -0.5972  -0.1900  -0.4095  0.1732  0.2462
%           0.6176  0.6153  1.0000  -0.8235  -0.1267  -0.5729  -0.5498  0.5358  0.5933
%          -0.5316 -0.5478 -0.8235   1.0000  -0.2638   0.7270   0.6990 -0.7173 -0.7590      
%          -0.5055 -0.5972 -0.1267  -0.2638   1.0000  -0.4577  -0.1380  0.4383  0.4122
%          -0.2025 -0.1900 -0.5729   0.7270  -0.4577   1.0000   0.5675 -0.8277 -0.9360
%          -0.5303 -0.4095 -0.5498   0.6990  -0.1380   0.5675   1.0000 -0.4787 -0.7046
%           0.2953  0.1732  0.5358  -0.7173   0.4383  -0.8277  -0.4787  1.0000  0.7191
%           0.2212  0.2462  0.5933  -0.7590   0.4122  -0.9360  -0.7046  0.7191  1.0000];
%
%     Calling on Matlab the function: 
%             acapewod(X)
%
%     Answer is:
%
% U-Canonical Functions (left hand).
% --------------------------------------------------------------------------------
% Uvariates =
%    -0.6743   -1.0834   -1.5326    0.2859
%     0.9085    3.0394   -2.0503   -2.3278
%     0.3755    2.2223   -2.2316   -0.8639
%     1.4415    3.4520   -4.9193   -1.9010
%     0.2685    2.9375   -3.6127   -1.1288
% --------------------------------------------------------------------------------
% Functions = columns. On variates, Variate1 = first row and so forth to 4
% 
% V-Canonical Functions (right hand).
% --------------------------------------------------------------------------------
% Vvariates =
%    -0.1147   -0.7881    3.6499    1.5910
%     0.6189    0.9786    0.6035    0.8595
%    -0.6932   -0.5641    0.5631    1.5976
%     0.0467    0.9175    3.6230    0.7394
% --------------------------------------------------------------------------------
% Functions = columns. On variates, Variate1 = first row and so forth to 4
 
% Correlations between the canonical and original variables, battery 1.
% --------------------------------------------------------------------------------
% Battery1 =
%    -0.5679   -0.4328   -0.2221   -0.6563
%    -0.3869   -0.1646    0.1188   -0.8995
%    -0.7031    0.2084    0.0690   -0.4112
%     0.9223   -0.2420   -0.1906    0.2315
%    -0.3610    0.4778   -0.0331    0.7277
% --------------------------------------------------------------------------------
% Canonical = columns. Original, Variate1 = first row and so forth to 4
% 
% Correlations between the canonical and original variables, battery 2.
% --------------------------------------------------------------------------------
% Battery2 =
%     0.7665   -0.6246    0.1351    0.0644
%     0.8527    0.1550   -0.1475    0.4767
%    -0.8609    0.2795   -0.1415    0.4010
%    -0.7804    0.5600    0.1864   -0.2066
% --------------------------------------------------------------------------------
% Canonical = columns. Original, Variate1 = first row and so forth to 4
% 
% Proportion of variance extracted from original
% variables by the new canonical variates.
% -------------------------------------------------
%      U       V
% -------------------------------------------------
%   0.3895  0.6661
%   0.1089  0.2015
%   0.0211  0.0237
%   0.3984  0.1087
% -------------------------------------------------
% Canonical variate 1 = first row and so forth to 4
% 
% Amount of variance in one set of variables
% extracted by the canonical variables of the
% other set of variables (redundancy).
% --------------------------------------------
%      X       Y
% --------------------------------------------
%   0.3011  0.5150
%   0.0607  0.1122
%   0.0036  0.0040
%   0.0188  0.0051
% --------------------------------------------
% Original set = columns.
% 
% Chi-square Tests with Successive Roots Removed.
% -------------------------------------------------------------------------
% Removed    Eigenvalue   CanCor      LW       Chi-sqr.     df       P
% -------------------------------------------------------------------------
%              0.7731     0.8793    0.0795      25.3144     20    0.1897
%    1         0.5570     0.7463    0.3506      10.4824     12    0.5737
%    2         0.1695     0.4117    0.7913       2.3409      6    0.8858
%    3         0.0472     0.2174    0.9528       0.4840      2    0.7851
% -------------------------------------------------------------------------
% With a given significance of: 0.05
% The number of significant canonical correlations were the first: 
% [If P-value >= alpha, it is not significative. Else, it results significative.]
% 
% According to the results, do you want only the significant canonical functions? (y/n): n
%
%
%  Created by A. Trujillo-Ortiz, R. Hernandez-Walls and A. Castro-Perez
%             Facultad de Ciencias Marinas
%             Universidad Autonoma de Baja California
%             Apdo. Postal 453
%             Ensenada, Baja California
%             Mexico.
%             atrujo@uabc.mx
%             And the special collaboration of the post-graduate students of the 2004:1
%             Multivariate Statistics Course: Alejandra Agundez-Amador, Laura Huerta-Tamayo,
%             Elizabeth Romero-Hernandez and Juan Carlos Solis-Bautista.
%
%  Copyright (C) June 10, 2004.
%
%  To cite this file, this would be an appropriate format:
%  Trujillo-Ortiz, A., R. Hernandez-Walls, A. Castro-Perez, A. Agundez-Amador, J.C. Solis-Bautista,
%         E. Romero-Hernandez and L. Huerta-Tamayo. (2004). ACAPEWOD: Canonical Correlation Analysis 
%         Without Data. A MATLAB file. [WWW document]. URL http://www.mathworks.com/matlabcentral/
%         fileexchange/loadFile.do?objectId=5264&objectType=FILE
%
%  References:
% 
%  Cooley, W. W. and Lohnes, P. R. (1971), Multivariate Data Analysis.
%              New-York:John Wiley & Sons, Inc. pp. 168-183. 
%  Johnson, R. A. and Wichern, D. W. (1992), Applied Multivariate Statistical Analysis.
%              3rd. ed. New-Jersey:Prentice Hall. pp. 459-492.
%  Manly, B. J. F. (1994), Multivariate Statistical Methods: A Primer.
%              New-York:Chapman & Hall. pp. 120-124.
%

if nargin < 2, 
    alpha = 0.05; %(default); 
end; 

[r c] = size(X);

if r ~= c, 
   error('Input matrix it is not square.');
   return;
   if [X - X'] ~= zeros(r) %x ~= x'
      error('Input matrix it is not symmetric.');
      return;
       if any(diagX <= 0)
          error('The covariance/correlation matrix must be positive definite.');
          return;
       end;
   end;
end;

%Standardization of any X-input matrix in order to assure a R-correlation matrix of it
%and needed for the procedure.
dX = diag(X);
D = 1./sqrt(dX);
R = X.* (D*D');

va = input('Give me in strict order of matrix the pair of set''s variables [p q] (q<=p): ');
disp(' ')
n = input('Give me the sample size: ');

p = max(va); %predictor variables
q = min(va); %criterion variables

%Subdivition of the correlation matrix.
A = R(1:p,1:p);
B = R(p+1:p+q,p+1:p+q);
C = R(1:p,p+1:p+q);

%Generation of the M-nonsymmetric matrix.
M = inv(B)*C'*inv(A)*C;

%Eigenstructure of matrix M.
[b R2] = eig(M);
[R2 k] = sort(diag(R2));
k = flipud(k);
b = b(:,k);

%Canonical correlation for the pair of canonical variates.
Rc = sqrt(R2);
Rc = flipud(Rc);

T = b'*B*b;
nT = abs(inv(sqrt(T)));

V = b*nT;
U = (inv(A)*C*V)*diag((Rc').^-1);
Uvariates = U;
Vvariates = V;

%Canonical functions.
disp(' ')
disp('U-Canonical Functions (left hand).')
fprintf('--------------------------------------------------------------------------------\');
Uvariates
fprintf('--------------------------------------------------------------------------------\n');
fprintf('Functions = columns. On variates, Variate1 = first row and so forth to %.i\n', q);
disp(' ')
disp('V-Canonical Functions (right hand).')
fprintf('--------------------------------------------------------------------------------\');
Vvariates
fprintf('--------------------------------------------------------------------------------\n');
fprintf('Functions = columns. On variates, Variate1 = first row and so forth to %.i\n', q);

%Correlations between the new canonical variates and the original ones.
%These are commonly known as batteries.
B1 = A*U;
B2 = B*V;
Battery1 = B1;
Battery2 = B2;

disp(' ')
disp('Correlations between the canonical and original variables, battery 1.')
fprintf('--------------------------------------------------------------------------------\');
Battery1
fprintf('--------------------------------------------------------------------------------\n');
fprintf('Canonical = columns. Original, Variate1 = first row and so forth to %.i\n', q);
disp(' ')
disp('Correlations between the canonical and original variables, battery 2.')
fprintf('--------------------------------------------------------------------------------\');
Battery2
fprintf('--------------------------------------------------------------------------------\n');
fprintf('Canonical = columns. Original, Variate1 = first row and so forth to %.i\n', q);

PVe1 = diag((B1'*B1)/p); %proportion of variance extracted from variables by the 1st canonical variates
PVe2 = diag((B2'*B2)/q); %proportion of variance extracted from variables by the 2nd canonical variates
PV = [PVe1 PVe2];

disp(' ')
disp('Proportion of variance extracted from original')
disp('variables by the new canonical variates.')
fprintf('-------------------------------------------------\n');
fprintf('     U       V\n');
fprintf('-------------------------------------------------\n');
fprintf('%8.4f%8.4f\n',[PV(:,1),PV(:,2)].');
fprintf('-------------------------------------------------\n');
fprintf('Canonical variate 1 = first row and so forth to %.i\n', q);

R2 = Rc.^2;
R2 = R2';
Rdx = diag(R2)*PVe1;
Rdy = diag(R2)*PVe2;
Rd = [Rdx Rdy];

disp(' ')
disp('Amount of variance in one set of variables')
disp('extracted by the canonical variables of the')
disp('other set of variables (redundancy).')
fprintf('--------------------------------------------\n');
fprintf('     X       Y\n');
fprintf('--------------------------------------------\n');
fprintf('%8.4f%8.4f\n',[Rd(:,1),Rd(:,2)].');
fprintf('--------------------------------------------\n');
disp('Original set = columns.')

%Bartlett's approximate chi-squared statistic for testing
%the canonical correlation coefficients
i = 0:(q-1);
LL = 1-R2;
LW = fliplr(cumprod(fliplr(LL))); %statistic Wilk's lambda
v = n-1;
df = (p-i).*(q-i); %Chi-square statistic degrees of freedom
X2 = -(v-0.5*(p+q+1)).*log(LW); %approximation Chi-square distribution
P = 1 - chi2cdf(X2,df); %P-value associated to the Chi-square
c = sum([P <= alpha]); %number of significant canonical correlations

disp(' ')
disp('Chi-square Tests with Successive Roots Removed.')
fprintf('-------------------------------------------------------------------------\n');
disp('Removed    Eigenvalue   CanCor      LW       Chi-sqr.     df       P')
fprintf('-------------------------------------------------------------------------\n');
fprintf('%4.i%15.4f%11.4f%10.4f%13.4f%7.i%10.4f\n',[i',R2',Rc,LW',X2',df',P'].');
fprintf('-------------------------------------------------------------------------\n');
fprintf('With a given significance of: %.2f\n', alpha);
fprintf('The number of significant canonical correlations were the first: %.i\n', c);
disp('[If P-value >= alpha, it is not significative. Else, it results significative.]')
disp(' ')

if c >= 1,
   dc = input('According to the results, do you want only the significant canonical functions? (y/n): ','s');
   if dc == 'y'
      Uvariates = U(:,1:c);
      Vvariates = V(:,1:c);
      %Significant canonical functions.
      disp(' ')
      disp('U-Canonical Functions (left hand).')
      fprintf('--------------------------------------------------------------------------------\');
      Uvariates
      fprintf('--------------------------------------------------------------------------------\n');
      fprintf('Functions = columns. On variates, Variate1 = first row and so forth to %.i\n', q);
      disp(' ')
      disp('V-Canonical Functions (right hand).')
      fprintf('--------------------------------------------------------------------------------\');
      Vvariates
      fprintf('--------------------------------------------------------------------------------\n');
      fprintf('Functions = columns. On variates, Variate1 = first row and so forth to %.i\n', q);
      
      %Correlations between the new canonical variates and the original ones.
      %These are commonly known as batteries.
      B1 = A*Uvariates;
      B2 = B*Vvariates;
      Battery1 = B1;
      Battery2 = B2;
      
      disp(' ')
      disp('Correlations between the canonical and original variables, battery 1.')
      fprintf('--------------------------------------------------------------------------------\');
      Battery1
      fprintf('--------------------------------------------------------------------------------\n');
      fprintf('Canonical = columns. Original, Variate1 = first row and so forth to %.i\n', q);
      disp(' ')
      disp('Correlations between the canonical and original variables, battery 2.')
      fprintf('--------------------------------------------------------------------------------\');
      Battery2
      fprintf('--------------------------------------------------------------------------------\n');
      fprintf('Canonical = columns. Original, Variate1 = first row and so forth to %.i\n', q);
   else
   end;
end;