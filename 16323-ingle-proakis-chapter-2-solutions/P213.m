clear;  clc;
%P2.13
nx = 0:3;       % Index for sequence x(n)
x = 1:4;        % Sequence x(n) = {1,2,3,4}
nh = 0:2;       % Index for impulse h(n)
h = 3:-1:1;     % Sequence h(n) = {3,2,1}
[y,ny] = conv_m(x,nx,h,nh); % Linear Convolution y(n) = h(n)*x(n)
htilde = [h';zeros(size(x)-[0,1])'];
%m = 0:length(htilde)-1;
Hcol = zeros(size(x)+size(h)-[1,1])';
H = htilde;
for k = 1:length(x)-1,
    Hcol=circshift(htilde,k);
    H=[H,Hcol];
end
ytilde = H*x';  %Performs convolution using Toeplitz matrix