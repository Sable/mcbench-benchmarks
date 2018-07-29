
%% Function Serial to Parallel I/P msg and No. of Parallel Channels

function p_data = s2p(s_data,N)
    l = length(s_data);
    mode = mod(l,N);
    if mode ~= 0
        z_add = zeros(1,N-mode);
        data = [s_data z_add];
    else
        data = s_data;
    end
    
    M = length(data)/N;
    p_data = reshape(data,N,M);
end