function x = sart_solve(A,b,n_it)
N = size(A,2);
x = zeros(N,1);
Z1 = sum(A,1);
Z2 = sum(A,2);
lambda = 0.1;
cnt = 0;
for ki = 1:n_it
    cnt = cnt+1;
    if cnt >= n_it/10
        fprintf('\nIteration %d\r',ki);
        cnt = 0;
    end
    for kj = 1:N
        x(kj) = x(kj)+lambda*sum((b-A*x)./Z2.*A(:,kj),1)/Z1(kj);
    end
end
end
