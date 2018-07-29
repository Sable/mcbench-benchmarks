function pixels = getpixels(data, n)

x = data(1);
y = data(2);
m = floor(n/2);

[i0, j0] = toindex(x, y);
r = repmat(-m:m, n, 1);
i = i0 + r;
j = j0 + r';
pixels = [i(:) j(:)];