function rnd = nonParamRnd(h,n)
% Syntax: r = nonParamRnd(h,n) 
%
% generates n random numbers from a non-parametric probability 
% distribution described by histogram h.
% 
% Example: 
% h = rand(1,20); bins = [1:2:2*length(h)]/(2*length(h));
% q = nonParamRnd(h,1e5); u = hist(q,bins);
% bar(bins, u/sum(u)); hold on; plot(bins, h/sum(h),'r','LineWidth',3);
%
% zimmerk@cmp.felk.cvut.cz (2006)

h0 = cumsum(h); h0 = h0 / max(h0); 
r1 = rand(1,n); hh0 = [0 h0];
[r c] = find(diff(repmat(hh0,n,1)>repmat(r1',1,length(hh0)),1,2)');
binSize = 1/length(h0); rnd = ((r-1) + rand(n,1))*binSize;