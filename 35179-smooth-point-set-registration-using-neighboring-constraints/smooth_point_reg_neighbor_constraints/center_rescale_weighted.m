% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Centers and rescales input graphs according to the coefficients of the
% match matrix. It follows the ansatz by Softassign Procrustes.
% 
% Input
%   g_M,g_D: 2D coordinates of the model and data graph nodes
%   S: matrix of matching coefficients
% 
% Output
%   g_Mc,g_Dc: centered and rescaled coordinates of the model and data
%              graphs' nodes
% 

function [g_Mc g_Dc] = center_rescale_weighted(g_M,g_D,S)
% Softassign Procrustes (Rangarajan)
% Update centroids and variances (eq.(5))
m_M = sum(g_M.*repmat(sum(S)',1,2))/(sum(S(:))+eps);
m_D = sum(g_D.*repmat(sum(S,2),1,2))/(sum(S(:))+eps);
r_M = g_M - repmat(m_M,size(g_M,1),1);
r_D = g_D - repmat(m_D,size(g_D,1),1);
v_M = sum(diag(r_M*r_M').*sum(S)');%/sum(S(:));
v_D = sum(diag(r_D*r_D').*sum(S,2));%/sum(S(:));
% Center and rescale
g_Mc = r_M/(sqrt(v_M)+eps);
g_Dc = r_D/(sqrt(v_D)+eps);

