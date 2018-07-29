function [t, st] = lpf(f, sf, B)
% Low Pass Filter at frequency domain
%
% Phymhan Studio, $ 18-May-2013 19:31:21 $

df = f(2)-f(1);
hf = zeros(size(f));

%ideal LPF
bf = (-floor(B/df):floor(B/df))+floor(length(f)/2);
if bf(1) < 1
    bf = 1:length(hf);
end
hf(bf) = 1;

[t, st] = f2t(f, hf.*sf);
st = real(st); %?

end
