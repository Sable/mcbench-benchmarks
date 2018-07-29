function [Wx,Wy,MSE]=trainMLP(p,H,m,mu,alpha,X,D,epochMax,MSETarget)
% The matrix implementation of the Backpropagation algorithm for two-layer
% Multilayer Perceptron (MLP) neural networks.
%
% Author: Marcelo Augusto Costa Fernandes
% DCA - CT - UFRN
% mfernandes@dca.ufrn.br
%
% Input parameters:
%   p: Number of the inputs.
%   H: Number of hidden neurons
%   m: Number of output neurons
%   mu: Learning-rate parameter
%   alpha: Momentum constant
%   X: Input matrix.  X is a (p x N) dimensional matrix, where p is a number of the inputs and N is a training size.
%   D: Desired response matrix. D is a (m x N) dimensional matrix, where m is a number of the output neurons and N is a training size.
%   epochMax: Maximum number of epochs to train.
%   MSETarget: Mean square error target.
%
% Output parameters:
%   Wx: Hidden layer weight matrix. Wx is a (H x p+1) dimensional matrix.
%   Wy: Output layer weight matrix. Wy is a (m x H+1) dimensional matrix.
%   MSE: Mean square error vector. 

[p1 N] = size(X);
bias = -1;

X = [bias*ones(1,N) ; X];

Wx = rand(H,p+1);
WxAnt = zeros(H,p+1);
Tx = zeros(H,p+1);
Wy = rand(m,H+1);
Ty = zeros(m,H+1);
WyAnt = zeros(m,H+1);
DWy = zeros(m,H+1);
DWx = zeros(H,p+1);
MSETemp = zeros(1,epochMax);


for i=1:epochMax
    
k = randperm(N);
X = X(:,k);
D = D(:,k);

V = Wx*X;
Z = 1./(1+exp(-V));

S = [bias*ones(1,N);Z];
G = Wy*S;

Y = 1./(1+exp(-G));

E = D - Y;

mse = mean(mean(E.^2));
MSETemp(i) = mse;
disp(['epoch = ' num2str(i) ' mse = ' num2str(mse)]);
if (mse < MSETarget)
    MSE = MSETemp(1:i);
    return
end
 

df = Y.*(1-Y);
dGy = df .* E;

DWy = mu/N * dGy*S';
Ty = Wy;
Wy = Wy + DWy + alpha*WyAnt;
WyAnt = Ty;

df= S.*(1-S);

dGx = df .* (Wy' * dGy);
dGx = dGx(2:end,:);
DWx = mu/N* dGx*X';
Tx = Wx;
Wx = Wx + DWx + alpha*WxAnt;
WxAnt = Tx;
end

MSE = MSETemp;
end



