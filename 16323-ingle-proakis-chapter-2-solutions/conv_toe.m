%P2.14a
function [ytilde,H]=conv_toe(h,x)
% Linear Convolution using Toeplitz Matrix
% ----------------------------------------
% [ytilde,H] = conv_toe(h,x)
% ytilde = output sequence in column vector form
% H = Toeplitz matrix corresponding to sequence h so that y = Hx
% h = Impulse response sequence in row vector form
% x = input sequence in row vector form
%
htilde = [h';zeros(size(x)-[0,1])'];
Hcol = zeros(size(x)+size(h)-[1,1])';
H = htilde;
for k = 1:length(x)-1,
    Hcol=circshift(htilde,k);
    H=[H,Hcol];
end             %Calculates Toeplitz Matrix
ytilde = H*x';  %Performs convolution using Toeplitz matrix