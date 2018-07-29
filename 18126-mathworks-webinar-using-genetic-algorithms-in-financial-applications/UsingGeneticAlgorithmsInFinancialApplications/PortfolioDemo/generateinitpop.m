function initPop = generateinitpop(n,k)

initPop = zeros(n-k+1,n);

for i=1:n-k+1
    initPop(i,i:i+k-1) = 1;
end
