function [t, st] = bpf(f, sf, BL, BH)
% Band Pass Filter at frequency domain
%
% Phymhan Studio, $ 18-May-2013 21:19:42 $

df = f(2)-f(1);
hf = zeros(size(f));

%ideal BPF
bf = floor(BL/df):floor(BH/df);
bf1 = floor(length(f)/2)+bf;
bf2 = floor(length(f)/2)-bf;
if length(bf1) > length(f)/2
    hf(:) = 1;
else
    hf(bf1) = 1;
    hf(bf2) = 1;
end

[t, st] = f2t(f, hf.*sf);
st = real(st); %?

end
