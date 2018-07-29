% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Returns discrete {0,1} matrix with the highest coefficients in each row
% and column from matrix M
% 
% Input
%   M: matrix of coefficients
% 
% Output
%   R: discrete {0,1} output matrix with 
% 

function R = clean(M)

    M = M - min(M(:)); % translate so that the new min is zero
    fils = size(M,1);
    cols = size(M,2);
    R = zeros(size(M));
    
    while sum(M(:)) > 0
        [v i] = max(M(:));
        [f,c] = ind2sub(size(M),i);
        R(i) = 1;
        M(f,:) = zeros(1,cols);
        M(:,c) = zeros(fils,1);
    end

