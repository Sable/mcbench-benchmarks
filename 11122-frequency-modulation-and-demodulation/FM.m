function y = FM(x,beta)

[r, c] = size(x);
if r*c == 0
    y = [];
    return;
end;
if (r == 1)
    x = x(:);
    len = c;
else
    len = r;
end;

Df = 2*pi*beta*100;

x = interp(x,20);
x = x*Df;

Fs = 20*8000;
Fc = 40000;
t = (0:1/Fs:((size(x,1)-1)/Fs))';
t = t(:, ones(1, size(x, 2)));

    x = 2 / Fs * pi * x;
    x = [zeros(1, size(x, 2)); cumsum(x(1:size(x,1)-1, :))];
    y = cos(2 * pi * Fc * t + x );
   plot(y)
