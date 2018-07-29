%% find histogram of an image
function hnorm = find_hist(I, nbin);

[sx sy] = size(I);
h = zeros(256,1);
minn = double(min(min(I)));
maxx = double(max(max(I)));
n1bins = maxx-minn+1;
n = hist(double(I),double(n1bins));
if sx>1 & sy>1
    n1 = sum(n,2);
else
    n1 = n;
end
h(minn+1:maxx+1) = n1;

dist_bin = 256/nbin; % distance between bins
hgram = zeros(nbin,1);
for i = 1:nbin
    hgram(i,1) = sum(h((i-1)*dist_bin+1:i*dist_bin,1));
end

hnorm = hgram/(sx*sy);