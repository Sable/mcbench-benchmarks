clear
clc
n = 9;
%x = testmat(n)';
x = rand(n);
figure('name','original x');
imagesc(x)
%imagesc(x(:))
colormap gray
fprintf('original matrix x:\r')
%disp(x)
[W,p,~] = build7(x,0:18:179);
fprintf('weighting factor matrix W:\r')
%disp(W)
fprintf('p:\r')
%disp(p)
x_sol = lsqr(W,p,1e-6,1000);
%x_sol = myart_solve(W,p,1000);
y = reshape(x_sol,[n n]);
fprintf('solution y:\r')
%disp(y)
figure('name','solution(lsqr)');
imagesc(y)
%imagesc(y(:))
colormap gray
diff_var = var(x(:)-y(:));
fprintf('\nVariance: %f\r',diff_var);
