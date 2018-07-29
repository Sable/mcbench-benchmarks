function [time, iters, nvals,NonZs] = TestBFMOTrand(nsamp,sp);
% Tests onBellman-Ford-Moore Shortest Path algorith with random sparse
% matrices and random sparsity.
%
% Derek O'Connor 20 Jan, 13 Sep 2012

nsamp = 1;  % No sampling yet
nvals = round(logspace(5,6.5,10))';

time  = zeros(length(nvals),1);
iters = zeros(length(nvals),1);
NonZs = zeros(length(nvals),1);


for s = 1:nsamp    
    for k = 1:length(nvals)
        n = nvals(k);
        r = 1+floor(rand*n); 
        spa = 2+floor(rand*sp); 
        G = sprand(n,n,spa/n);
        NonZs(k) = nnz(G);
        ts = tic;
        [~,~,iter] = BFMSpathOT(G,r);
        tf = toc(ts);
        time(k) = time(k)+tf;
        iters(k) = iter;
        disp([n spa NonZs(k) iter tf]);
    end
end
figure
subplot(2,2,1);plot(nvals,time);
subplot(2,2,2);plot(NonZs,time);
subplot(2,2,3);plot(nvals,iters);
subplot(2,2,4);plot(NonZs,iters);

end
