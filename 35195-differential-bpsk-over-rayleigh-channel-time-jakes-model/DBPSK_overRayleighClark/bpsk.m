%% generate random bpsk symbols
% N: number of symbols
% out: BPSK symbols +1 or -1 
function out=bpsk(N)
    out=sign(rand(1,N)-.5);
end