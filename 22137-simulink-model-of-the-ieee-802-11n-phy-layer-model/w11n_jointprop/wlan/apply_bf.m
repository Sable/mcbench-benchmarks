function [out_vec] = apply_bf(bf_and_txdata)
% apply_bf  User-defined function for applying beamform matrices.
% Input: 'bf_and_params'
%    - first element is clock parameter
%    - remaining elements are tx data to beamform 
% Output: 'out_vec'
%    - x*4*NST elements are beamformed tx output data.
global bf_matrices;

% Initialize vectors
Clk = bf_and_txdata(1);
tx_data = bf_and_txdata(2:end);

% Init. beamforming matrices
if (Clk==0)
    % Reset BF matrices (no beamforming)
    bf_matrices = repmat(eye(4),[1 1 57]);
end

%%%% Beamform Tx data symbols...
idx = 0;
out_vec = zeros(size(tx_data));
nsymdata = (length(tx_data)/4/57);
for n=1:nsymdata
    for k=1:57
        out_vec(idx+(1:4)) = bf_matrices(:,:,k)*tx_data(idx+(1:4));
        idx = idx + 4;
    end
end
