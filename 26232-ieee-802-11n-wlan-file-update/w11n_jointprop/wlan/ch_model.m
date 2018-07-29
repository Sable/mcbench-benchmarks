function [out_vec] = ch_model(in_vec)
% ch_model.m - Channel model simulation

% Select channel model
if (0)
    out_vec = ch_model_awgn(in_vec);
else
    out_vec = ch_model_tgn(in_vec);
end

