function [ dinf ] = Dinfinity( deltap,deltas )
%Dinfinity: compute Dinfinity for optimal FIR lowpass filter
% inputs:
%   deltap: passband ripple (linear scale)
%   deltas: stopband ripple (linear scale)
%
% ouput:
%   dinf: evaluation of Dinfinity

% compute Dinfinity
    log_deltap=log10(deltap);
    log_deltas=log10(deltas);
    dinf=(5.309e-3*log_deltap^2+7.114e-2*log_deltap-0.4761)*log_deltas - ...
        (2.66e-3*log_deltap^2+0.5941*log_deltap+0.4278);
end

