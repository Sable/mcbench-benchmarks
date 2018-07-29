% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Heuristic to filter-out outlier points (useful in the Chui dataset)
% also used by Zheng and Doermann PAMI'06. Robust point matching for
% nonrigid shapes by preserving local neighbourhood structures (check their
% code for details).
% 
% Input
%   gM,gD: 2D point-sets
% 
% Output:
%   inl: indices of inlier points
% 

function inl = label_outl_chui(gM,gD)

lM = length(gM);

Dst = dist_matrix(gD,gD);
Dst = sort(Dst,2);
muDst = mean(Dst(:,1:6),2);
[v,I] = sort(muDst);
inl = I(1:lM)';
