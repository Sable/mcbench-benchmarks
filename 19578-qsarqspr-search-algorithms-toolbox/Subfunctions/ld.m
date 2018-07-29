function  [lindep] = ld(P, Vec, Mat)

% ld tests the lineal dependence of the descriptors in Vec including the
% regression constant
%  

%   Input: 
%             P             Property vector
%             Vec           Initial descriptors vector
%             Mat           Descriptors matrix with descriptors pool
%             
%
%     Returns:
%          
%            lindep            if there is a linear dependence lindep = 100
%                               otherwise lindep = 0

% Pablo R. Duchowicz; Andrew G. Mercader
% INIFTA, La Plata, Argentina
% Created: 12 Nov 2007


if (nargin < 3)
   error('ld requires at least 3 input variables. Type ''help ld''.');
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


    
lindep=0;

nu=k+1;

if (rank(X)<nu)
    lindep = 100;
end;
        
