% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Sinkhorn normalization (without outliers)
% 
% Input
%   S: matrix of correspondence indicators
%   max_its,thresh: convergence parameters
% 
% Output
%   S_out: bi-normalized matrix of correspondence indicators
% 

function S_out = norm_sinkhorn(S,max_its,thresh)

S_ant = rand(size(S));
C = abs(S_ant - S);
its = 0;
while its <= max_its && max(C(:)) > thresh
    S_ant = S;
    den_S = repmat(sum(S,2),1,size(S,2));
    S = S ./ (den_S + realmin);
    den_S = repmat(sum(S),size(S,1),1);
    S = S ./ (den_S + realmin);
    C = abs(S_ant - S);
    its = its + 1;
end
den_S = repmat(sum(S,2),1,size(S,2));
S = S ./ (den_S + realmin);

S_out = S;

