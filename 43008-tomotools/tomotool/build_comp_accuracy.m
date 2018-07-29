clear
clc
n = 97;
ang = 0:6:179;
%x = testmat(n)';
x = rand(n);
figure('name','original x');
imagesc(x)
colormap gray
[W7,p7,~] = build7(x,ang);
[W8,p8,~] = build8(x,ang);
x_sol7 = lsqr(W7,p7,1e-6,1000);
x_sol8 = lsqr(W8,p8,1e-6,1000);
y7 = reshape(x_sol7,[n n]);
y8 = reshape(x_sol8,[n n]);
figure('name','7')
imagesc(y7)
colormap gray
figure('name','8')
imagesc(y8)
colormap gray
diff_var7 = var(x(:)-y7(:));
fprintf('\nVariance7: %f\r',diff_var7);
diff_var8 = var(x(:)-y8(:));
fprintf('\nVariance8: %f\r',diff_var8);
