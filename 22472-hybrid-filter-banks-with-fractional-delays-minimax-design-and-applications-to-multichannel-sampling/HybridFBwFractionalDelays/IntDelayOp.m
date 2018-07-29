function sys = IntDelayOp(m)
%
% INTDELAYOP: Integer Delay Operator. IntDelayOp delays the i-th channel of
% a digital LTI system by m(i) samples. 
%
% Usage:    sys = IntDelayOp(m)
%
% INPUT 
%       m is a vector of delays, m = (m0, m1, m2,..., mN)
%
% OUTPUT 
%       sys: the delay operator in system format

den0 = [1 zeros(1,m(1)+1)];
num0 = [1 0];
sys = tf(num0, den0, -1);

for i = 2:length(m)

    deni = [1 zeros(1,m(i)+1)];
    numi = [1 0];
    sysi = tf(numi, deni, -1);

    sys = append(sys, sysi);    
end

