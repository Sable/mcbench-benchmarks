% The XOR Example - Batch-Mode Training
%
% Author: Marcelo Augusto Costa Fernandes
% DCA - CT - UFRN
% mfernandes@dca.ufrn.br

p = 2;
H = 4;
m = 1;

mu = .75;
alpha = 0.001;

epoch = 4000;
MSEmin = 1e-20;

X = [0 0 1 1;0 1 0 1];
D = [0 1 1 0];

[Wx,Wy,MSE]=trainMLP(p,H,m,mu,alpha,X,D,epoch,MSEmin);

semilogy(MSE);

disp(['D = [' num2str(D) ']']);

Y = runMLP(X,Wx,Wy);

disp(['Y = [' num2str(Y) ']']);

