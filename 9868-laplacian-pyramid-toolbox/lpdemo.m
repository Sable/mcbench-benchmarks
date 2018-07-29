% LPDEMO
% Demo of the Laplacian pyramid functions

x = imread('cameraman.tif');
x = double(x)/256;

% Laplacian decomposition using 9/7 filters and 5 levels
pfilt = '9/7';
n = 5;
y = lpd(x, '9/7', n);

% Display output
figure(1)
colormap(gray)
nr = floor(sqrt(n+1));
nc = ceil((n+1)/nr);
for l = 1:n+1
    subplot(nr, nc, l); 
    imageshow(y{l});
end

% Reconstruction
xr = lpr(y, pfilt);

% Show perfect reconstruction
figure(2)
colormap(gray)
subplot(1,2,1), imageshow(x, [0, 1]);
subplot(1,2,2), imageshow(xr, [0, 1]);
title(sprintf('SNR = %.2f dB', SNR(x, xr)))

% Reconstruction with only R percent of most significant coefficients
r = input('Enter the percentage of retained coefficients (say 10): ');
if isempty(r)
    r = 10;
end

if ~isnumeric(r) | (r < 0) | (r > 100)
    error('Please enter a number between 0 and 100');
end

% Put all coefficients in one column vector for processing
[c, s] = lp2vec(y);

% Sort the coefficient in the order of magnitude
csort = sort(abs(c));
csort = flipud(csort);

% Threshold to retain only R percent of most significant coefficients
nc = sum(prod(s, 2));
m = round(nc/100*r);
thresh = csort(m);
cr = c .* (abs(c) >= thresh);

% Reconstruction
y = vec2lp(cr, s);
xr = lpr(y, pfilt);

figure(2)
colormap(gray)
subplot(1,2,1), imageshow(x, [0, 1]);
subplot(1,2,2), imageshow(xr, [0, 1]);
title(sprintf('Reconstruction with %.1f%% of coefs\nSNR = %.2f dB', ...
    r, SNR(x, xr)));

% Now compare with the old reconstruction method
input('Press Enter key to continue...');

xr1 = lpr_old(y, pfilt);
subplot(1,2,1), imageshow(xr1, [0, 1]);
title(sprintf('Reconstruction using the old method\nSNR = %.2f dB', ...
    SNR(x, xr1)));