% -------------------------------------------------------------------------
% noise.m
% Function describing white noise with high frequency cutt-off.
% Dependencies:
% -------------------------------------------------------------------------

function F = noise(t)

global p w

f = zeros(length(p),length(t));

for i = 1:length(p)
    for j = 1:length(t) 
        f(i,j) = sin(w(i)*t(j)+p(i))';
    end
end

F = sqrt(2/length(p))*sum(f);
