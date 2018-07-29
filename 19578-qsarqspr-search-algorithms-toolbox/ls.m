function Resls = ls(P, Vec, Mat)

% Resls is a matrix containing the number of the descriptors in the first row 
% (NaN represents the regression constant in the first place, and Not Available in any other place)
% In the second row, R, S, F, the average of the squared residuals, AIC and FIT. 
% In the third row the regression coefficients. In the fourth row the errors in the coefficients.
% In the fifth row the relative errors in the coefficients. 
% The final rows contains the P-values
% 
%
%           
%	   Input: 
%             P             Property vector
%             Vec           Descriptor number vector 
%             Mat           Descriptors matrix with descriptors pool
%             
%
%     Returns:
%          
%            Res           Multi-linear regression result matrix
%
%           
%
%
% Andrew G. Mercader
% INIFTA, La Plata, Argentina
% Created: 30 Jan 2007


if (nargin < 3)
   error('rmder requires at least 3 input variables. Type ''help rmder''.');
end


% Exctracts from descriptor matrix the matrix corresponding to the given
% set of descriptors 
% ---------------------------------------------------------------------------- 
    X = Mat(:,Vec);
% Check that independent (X) and dependent (P) data have compatible dimensions
% ---------------------------------------------------------------------------- 
     [n_x, k] = size(X);
[n_y,columns] = size(P);

if n_x ~= n_y, 
    error('The number of rows in P must equal the number of rows in Mat.'); 
end 

if columns ~= 1, 
    error('P must be a vector, not a matrix'); 
end

n = n_x;
      
%  Solve for the regression coefficients using ordinary least-squares
%  ------------------------------------------------------------------
      X = [ ones(n,1) X ]   ; 
        
      
XTXI = X' * X;    
if rcond(XTXI) < 1e-25
    S_err = 10000000;
    return;
end
 
 XTXI = inv(XTXI); 
      Coefficients = XTXI * X' * P ;
      
   
%  Calculate the fitted regression values
%  --------------------------------------

    P_hat = X * Coefficients;

%  Calculate R-squared
%  -------------------
% The calculation used for R-squared and the F-statistic here are based
% on the total, un-corrected sum of the squares as describe by Neter and
% Myers. Note that the meaning of R-squared changes for the case of
% regression without a y-intercept. This approach will yield the same
% results as SysStat, SAS, SPSS and BMDP but will differ from that of
% Excel, Quattro Pro, and the MATLAB regress.m function (for the case of
% no y-intercept in the model -- all packages including this one will
% agree for the case of linear regression with a
% y-intercept). Essentially, it is wise to find a way to
% keep the y-intercept (even if it is near zero) in the model to analyze
% it in a meaningful way that everyone can understand.


   RSS = norm(P_hat - mean(P))^2;   % Regression sum of squares.
   TSS = norm(P - mean(P))^2;       % Total sum of squares (regression plus residual).
   R_sq = RSS / TSS;                % R-squared statistic.
   R_ = (R_sq)^0.5;                       % R.


% $$$ % Alternative calculation of R-squared
% $$$ % ====================================
% $$$ % The follwing equation is from Judge G, et al. "An Introduction to the theory
% $$$ % and practice of econometrics", New York : Wiley, 1982. It is the
% $$$ % squared (Pearson) correlation coefficient between the predicted and
% $$$ % dependent variables. It is the same equation regardless of whether an
% $$$ % intercept is included in the model; however, it may yield a negative
% $$$ % R-squared for a particularily bad fit.
% $$$ covariance_P_hat_and_P = (P_hat - mean(P_hat))' * (P - mean(P));
% $$$ covariance_P_hat_and_P_hat = (P_hat - mean(P_hat))' * (P_hat - mean(P_hat));
% $$$ covariance_P_and_P = (P - mean(P))' * (P - mean(P));
% $$$ R_sq = (covariance_P_hat_and_P / covariance_P_hat_and_P_hat) * ...
% $$$        (covariance_P_hat_and_P / covariance_P_and_P);   

%  Calculate residuals and standard error
%  --------------------------------------

    residuals = P - P_hat;

           S_err = sqrt(residuals' * residuals / (n - k - 1) );
           Ave_res= (residuals' * residuals)/n;
    
%  Calculate the standard deviation  for the regression coefficients
%  -----------------------------------------------------------------------------

    covariance = XTXI .* S_err^2;
    
    C = sqrt(diag(covariance, 0));
    Er = abs(C./Coefficients)*100;

    
    
    % (n.b. Need to perform a 2-tailed t-test)
    % ****************************************
    
      p_value = 2 * (1 - tcdf(abs(Coefficients./C), (n - (k + 1))));
    

    Coef_stats = [ Coefficients, C, (Coefficients./C), p_value];


% Estimator of error variance.
% ----------------------------

     SSR_residuals = norm(P - P_hat)^2;
     TSS = norm(P - mean(P))^2;     % Total sum of squares (regression plus residual).

     F_val = (TSS - SSR_residuals) / k / ( SSR_residuals / (n - (k + 1)));

     F_val = [F_val (1 - fcdf(F_val, k, (n - (k + 1)))) ];

% AIC and FIT
  % ----------------------------
 
  AIC=sum(residuals.*residuals)*(n + k + 1)/(n-k-1)^2;
  
  FIT=R_^2*(n-k-1)/((n+k^2)*(1-R_^2));
   


% Results
% ----------------------------

for i=1:k+1
    Res1(i)=NaN;
end

Res1(1)=R_;
Res1(2)=S_err;
Res1(3)=F_val(1);
Res1(4)=Ave_res;
Res1(5)=AIC;
Res1(6)=FIT;

[n_r, n_c] = size(Res1);

for i=1:n_c
    Vec1(i)=NaN;
   Coefficients1(i)=NaN;
    C1(i)=NaN;
    Er1(i)=NaN;
    p_value1(i)=NaN;
end
 
for i=1:k+1
    Coefficients1(i)=Coefficients(i);
    C1(i)=C(i);
    Er1(i)=Er(i);
    p_value1(i)=p_value(i);
    
 end

 for i=1:k
    Vec1(i+1)=Vec(i);
 end

Resls =[Vec1; Res1; Coefficients1;C1;Er1;p_value1];








