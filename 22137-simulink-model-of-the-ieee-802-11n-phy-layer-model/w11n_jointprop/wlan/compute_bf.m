function [out_vec] = compute_bf(ch_and_params)
% compute_bf  User-defined function for computing beamform matrices.
% Input: 'ch_and_params'
%    - first elements are MIMO parameters (STBC, Nss, etc.)
%    - next 16*NST elements are channel estimates.
%    - remaining elements not used
% Output: 'detout'
%    - 4x4*NST elements are detector outputs.
global bf_matrices;

% Initialize vectors
Clk = ch_and_params(1);
STBC = ch_and_params(2);
Nss  = ch_and_params(3);
Nsts = Nss + STBC;
Nltf = Nsts;
if (Nsts==3) % use 4 TRN symbols for NSTS=3
   Nltf = 4;
end
Nrx  = ch_and_params(4);
ch_est  = ch_and_params(4+(1:16*56));

% Init. beamforming matrices
if (Clk==0)
    % Reset BF matrices (no beamforming)
    bf_matrices = repmat(eye(4),[1 1 57]);
end

%%%% Start BF after Rx second packet...
if (Clk > 1)
    %%%% Form channel matrix
    idx = 0;
    H = zeros(4,4,56);
    for c=1:4
        for r=1:4
            H(r,c,:) = ch_est(idx+(1:56));
            idx=idx+56;
        end
    end
    H = H(1:Nrx,1:Nsts,:);  %% channel matrix is Nrx x Nsts

    %%%% Compute beamforming matrices
    idx = 0;
    for k=1:56
        % Compute SVD's
        [U,S,V] = svd(H(:,:,k),0);
        r = size(V,1);  c = size(V,2);
        % Update BF matrices
        if (k <= 28)
            bf_matrices(1:r,1:c,k) = bf_matrices(1:r,1:c,k) * V;
        else
            bf_matrices(1:r,1:c,k+1) = bf_matrices(1:r,1:c,k+1) * V;
        end
    end
end

% Always return true (BF status)...
out_vec = 1;
