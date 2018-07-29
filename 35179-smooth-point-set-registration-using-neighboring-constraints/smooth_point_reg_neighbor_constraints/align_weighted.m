% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Performs rigid alignment (without reflection) of gM to gD using the
% correspondence weights from matrix W.
% 
% Input:
%   gD,gM: 2D coordinates of data and model point-sets
%   W: correspondence weights between gD and gM
% 
% Output:
%   new_gM: transformed point-set
% 

function new_gM = align_weighted(gD,W,gM)

g_M_aux = W*gM; 

[U,T,V] = svd(gD'*g_M_aux);
if round(det(U*V')) == -1  % eliminate reflections
    T = eye(size(U));
    T(end,end) = -1;
    r_est = V*T*U';
else
    r_est = V*U';
end
new_gM = gM*r_est;

