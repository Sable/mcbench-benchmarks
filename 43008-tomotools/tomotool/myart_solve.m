function x = myart_solve(A,b,n_it)
N = size(A,2);
x = zeros(N,1);
ix = (A~=0)';
Z = sum(ix,2)*N;
lambda = 0.1;
cnt = 0;
for ki = 1:n_it
    cnt = cnt+1;
    if cnt >= n_it/10
        fprintf('\nIteration %d\r',ki);
        cnt = 0;
    end
    x = x-lambda*(ix*(A*x-b))./Z;
end
end
