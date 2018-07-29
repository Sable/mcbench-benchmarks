% 
% Smooth point-set registration method using neighboring constraints
% -------------------------------------------------------------------
% 
% Authors: Gerard Sanromà, René Alquézar and Francesc Serratosa
% 
% Contact: gsanorma@gmail.com
% Date: 15/02/2012
% 
% Sinkhorn normalization (with outliers)
% 
% Input
%   S_in: matrix of correspondence indicators
%   max_its,thresh: convergence parameters
%   vnull: optional parameter to set the benefit values of the null
%   assignments
% 
% Output
%   S: bi-normalized matrix of correspondence indicators (without extras)
%   S_full: full bi-normalized matrix of correspondence indicators
%          including extra row and column of null-assignments
% 

function [S S_full] = norm_sinkhorn_null(S_in,max_its,thresh,vnull)
% 
% % 
% 
if nargin < 4
    vnull = 1;
    if nargin < 3
        thresh = 0.05;
        if nargin < 2
            max_its = 30;
        end
    end
end
% 
% Add Slacks
S = [[S_in vnull*ones(size(S_in,1),1)];[vnull*ones(1,size(S_in,2)) 0]];
% Iterate
S_ant = rand(size(S));
C = abs(S_ant - S);
its = 0;
while its <= max_its && max(C(:)) > thresh
    S_ant = S;
    % Normalization rows
    den_S = sum(S(1:end-1,:),2);
    S(1:end-1,:) = S(1:end-1,:) ./ repmat(den_S,1,size(S,2));
    % Null scale factor columns
    S(end,1:end-1) = S(end,1:end-1) ./ ...
        repmat(mean(den_S),1,size(S,2)-1);
    % Normalization columns
    den_S = sum(S(:,1:end-1));
    S(:,1:end-1) = S(:,1:end-1) ./ repmat(den_S,size(S,1),1);
    % Null scale factor rows
    S(1:end-1,end) = S(1:end-1,end) ./ ...
        repmat(mean(den_S),size(S,1)-1,1);
    % Convergence
    C = abs(S_ant - S);
    its = its + 1;
end
% Normalization rows
den_S = sum(S(1:end-1,:),2);
S(1:end-1,:) = S(1:end-1,:) ./ repmat(den_S,1,size(S,2));
% Null scale factor columns
S(end,1:end-1) = S(end,1:end-1) ./ ...
    repmat(mean(den_S),1,size(S,2)-1);
% 
S_full = S;
S = S(1:end-1,1:end-1);
