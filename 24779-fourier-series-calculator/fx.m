function y = fx(x)
i = find((x > -pi) & (x <= 0));
y = 2*x;
y(i) = 0;
y(1) = y(end);