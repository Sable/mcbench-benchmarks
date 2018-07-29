%TEST   Simple test of EXPMV_TSPAN.

n = 10;
A = -gallery('poisson',n);
b = linspace(-1,1,n^2)';

t0 = 0; tmax = 1;
q = 9;

[X,tvals,mv] = expmv_tspan(A,b,t0,tmax,q);

fprintf('Relative differences between vectors from EXPM and EXPMV_TSPAN.\n')
fprintf('Should be of order %9.2e.\n', eps/2)
Y = zeros(size(X));
for i = 1:length(tvals)
    Y(:,i) = expm(full(tvals(i)*A))*b;
    fprintf('%2.0f:  %9.2e\n', i, norm(Y(:,i)-X(:,i),1)/norm(X(:,i),1) )
end
