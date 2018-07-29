function  [S_err] = rms(P, Vec, Mat)

% rms evaluates selection of descriptors using multiple linear regression analysis.
%
%           
%	   Input: 
%             P             Property vector
%             Vec           Descriptors vector
%             Mat           Descriptors matrix
%
%     Returns:
%          
%             S_err           standard error
%           
%
%
% Andrew G. Mercader
% INIFTA, La Plata, Argentina
% Created: 30 Jan 2007


if (nargin < 3)
   error('rms requires at least 3 input variables. Type ''help rms''.');
end


% Exctracts from descriptor matrix the matrix corresponding to the given
% set of descriptors 
% ---------------------------------------------------------------------------- 
    X = Mat(:,Vec);
% Check that independent (X) and dependent (Y) data have compatible dimensions
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
    

    




