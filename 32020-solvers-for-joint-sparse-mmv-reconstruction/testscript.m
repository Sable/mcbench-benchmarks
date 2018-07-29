clear all
clc

% s - number of sparse coefficients
% N - length of each input vector
% n - length of output vector
% r - number of measurements

s = 15; N = 100; n = 60; r = 10;

t = randperm(N);
X0 = zeros(N,r);

for i = 1:r
    X0(t(1:s),i) = randn(s,1);
end

M = randn(n,N); Mop = opMatrix(M);
Sop = opDCT(N);

S = max(svd(M));

%%
F = opFoG(Mop, Sop);

for i = 1:r
    Y(:,i) = F(X0(:,i),1);
end

X = UnconSynthMMV(Y, F, 1e-6, 10, S);
norm(X0-X,'fro')/norm(X0,'fro')

X = SynthMMV(Y, F, 1e-6, S);
norm(X0-X,'fro')/norm(X0,'fro')

%%
for i = 1:r
    Z0(:,i) = Sop(X0(:,i),2);
    Y(:,i) = Mop(Z0(:,i),1);
end

Z = UnconAnaMMV(Y, M, Sop, 1e-6, 10, S, 1);
norm(Z0-Z,'fro')/norm(Z0,'fro')

Z = AnaMMV(Y, M, Sop, 1e-6, S, 1);
norm(Z0-Z,'fro')/norm(Z0,'fro')