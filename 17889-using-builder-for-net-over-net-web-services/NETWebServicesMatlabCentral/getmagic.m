function m = getmagic(n)
msg = sprintf('Request received, magic square of size %d', n);
disp(msg);
m = magic(n);
