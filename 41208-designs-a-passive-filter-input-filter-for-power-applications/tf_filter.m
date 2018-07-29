function [H, Z] = tf_filter( Lvec,Cvec, Ldvec, Rdvec , w)
% [H, Z] = tf_filter( Lvec,Cvec, Ldvec, Rdvec , w)
% computes the transfer-function and output impedance
% of a L-R damped filter with an arbitrary number of stages.
%
% input:
% Lvec, Vec, Ldvec, Rdvec - the components of the filter at every stage.
% w - frequency vector [rad/sec]
% output:
% H - the trasfer function H, as a function of w. complex number
% Z - the output impedace, as a function of w. complex number.

H = 1;
Z = 0;

NS = length(Lvec);  % number of stages
s = j*w;

for n = 1:NS
    L = Lvec(n);
    C = Cvec(n);
    Ld = Ldvec(n);
    Rd = Rdvec(n);
    
    den = (1+s*C.*Z).*(Rd+s*(L+Ld)) + s*C.*(s*L*Rd + (s.^2)*L*Ld);
    H = H .* (Rd+s*(L+Ld)) ./ den;
    Z = (s*L*Rd+(s.^2)*L*Ld + Z.*(Rd+s*(L+Ld))) ./ den;
    if isnan(H)
        H = 1;   Z=0;
    end
end

end

