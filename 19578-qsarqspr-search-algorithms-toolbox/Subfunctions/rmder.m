function [COEF] = rmder(P, Vec, Mat)

% rmder returns a vector containing the relative standard deviation of the regression coefficients. The
%                            constant of the regression is not included
%
%           
%      Input: 
%             P             Property vector
%             Vec           Descriptors vector
%             Mat           Descriptors matrix
%             
%
%     Returns:
%          
%            COEF           Vector containing the standard deviation for
%                            the regression coefficients without the constant
%
%           
%
%
% Andrew G. Mercader, Pablo R. Duchowicz
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

   

%  Calculate residuals and standard error
%  --------------------------------------

    residuals = P - P_hat;

           S_err = sqrt(residuals' * residuals / (n - k - 1) );
    
%  Calculate the standard deviation  for the regression coefficients
%  -----------------------------------------------------------------------------

    covariance = XTXI .* S_err^2;
    
    C = sqrt(diag(covariance, 0));
    Er = abs(C./Coefficients)*100;



COEF=[[Er]'];
COEF(1)=[];







