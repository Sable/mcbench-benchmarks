function [ f_k ] = fK( deltap,deltas )
%fK compute f_k from deltap and deltas
%   
% inputs
%   deltap: passband ripple (linear scale)
%   deltas: stopband ripple (linear scale)
%
% output
%   f_k: value of function

% define K value
    K=deltap/deltas;
    f_k=0.51244*log10(K)+11.01217;
end