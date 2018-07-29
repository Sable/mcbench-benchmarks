function [signal] = GenSig(n, k)

p = randperm(n); p = p(1:k);
signal = zeros(n,1);
signal(p) = randn(k,1);