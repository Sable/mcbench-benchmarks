% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Performs cleaning of a matrix with an extra row and column of zeros
% corresponding to the outlier assignments
% 
% Input:
%   S: matrix of benefit coefficients (with extra row and column)
% 
% Output:
%   Sd: discrete {0,1}-match matrix
% 

function Sd = clean_sinkhorn(S)

S = S - min(S(:)); % translate so that min is zero
S(end,end) = 0;  
fils = size(S,1)-1;
cols = size(S,2)-1;
Sd = zeros(fils,cols);

while sum(S(:)) > 0
    [v i] = max(S(:));
    [f,c] = ind2sub(size(S),i);
    if f <= fils, S(f,:) = 0; end
    if c <= cols, S(:,c) = 0; end
    if f <= fils && c<= cols, Sd(f,c) = 1; end
end

