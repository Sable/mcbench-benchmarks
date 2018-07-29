function [MSC]=coherence_MVDR(x1,x2,L,K);

%% This program computes the coherence function between 2 signals 
%% x1 and x2 with the MVDR method.
%% This algorithm is based on the paper by the same authors:
%% J. Benesty, J. Chen, and Y. Huang, "A generalized MVDR spectrum," 
%% IEEE Signal Processing letters, vol. 12, pp. 827-830, Dec. 2005.

%% x1, first signal vector of length n
%% x2, second signal vector of length n
%% L is the length of MVDR filter or window length
%% K is the resolution (the higher K, the better the resolution)

%initialization
xx1     = zeros(L,1);
xx2     = zeros(L,1);
r11     = zeros(L,1);
r22     = zeros(L,1);
r12     = zeros(L,1);
r21     = zeros(L,1);

%construction of the Fourier Matrix
F       = zeros(L,K);
l       = [0:L-1]';
f       = exp(2*pi*l*j/K);
for k = 0:K-1
    F(:,k+1) = f.^k;
end
F       = F/sqrt(L);

%number of samples, equal to the lenght of x1 and x2
n       = length(x1);

for i = 1:n
    xx1 = [x1(i);xx1(1:L-1)];
    xx2 = [x2(i);xx2(1:L-1)];
    r11 = r11 + xx1*conj(xx1(1));
    r22 = r22 + xx2*conj(xx2(1));
    r12 = r12 + xx1*conj(xx2(1));
    r21 = r21 + xx2*conj(xx1(1));
end
r11 = r11/n;
r22 = r22/n;
r12 = r12/n;
r21 = r21/n;
%
R11 = toeplitz(r11);
R22 = toeplitz(r22);
R12 = toeplitz(r12,conj(r21));
%
%for regularization
Dt1     = 0.01*r11(1)*diag(diag(ones(L)));
Dt2     = 0.01*r22(1)*diag(diag(ones(L)));
%
Ri11    = inv(R11 + Dt1);
Ri22    = inv(R22 + Dt2);
Rn12    = Ri11*R12*Ri22;
%
Si11    = real(diag(F'*Ri11*F));
Si22    = real(diag(F'*Ri22*F));
S12     = diag(F'*Rn12*F);
%
%Magnitude squared coherence function
MSC     = real(S12.*conj(S12))./(Si11.*Si22);