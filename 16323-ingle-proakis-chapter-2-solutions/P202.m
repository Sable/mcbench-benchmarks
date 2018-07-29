clear; clc;
% P2.2
x = [1,-2,4,6,-5,8,10];
n = [-4:2];
subplot(3,2,1); stem(n,x); title('Original Sequence');

% P2.2a
[x11,n11] = sigshift(x,n,-2);
[x12,n12] = sigshift(x,n,4);
[x1,n1] = sigadd(3*x11,n11,x12,n12);
[x1,n1] = sigadd(x1,n1,-2*x,n);
subplot(3,2,2); stem(n1,x1); title('Sequence in Problem 2.2a');

% P2.2b
[x21,n21] = sigshift(x,n,-5);
[x22,n22] = sigshift(x,n,-4);
[x2,n2] = sigadd(5*x21,n21,4*x22,n22);
[x2,n2] = sigadd(x2,n2,3*x,n);
subplot(3,2,3); stem(n2,x2); title('Sequence in Problem 2.2b');

% P2.2c
[x31,n31] = sigshift(x,n,-4);
[x32,n32] = sigshift(x,n,1);
[x33,n33] = sigmult(x31,n31,x32,n32);
[x31,n31] = sigfold(x,n);    [x31,n31] = sigshift(x31,n31,2);
[x32,n32] = sigmult(x31,n31,x,n);
[x3,n3] = sigadd(x33,n33,x32,n32);
subplot(3,2,4); stem(n3,x3); title('Sequence in Problem 2.2c');

% P2.2d
[x41,n41] = sigshift(x,n,-2);
x42 = cos(0.1*pi*n);
[x42,n42] = sigmult(x42,n,x41,n41);
x43 = 2*exp(0.5*n);
[x41,n41] = sigmult(x43,n,x,n);
[x4,n4] = sigadd(x42,n42,x41,n41); 
subplot(3,2,5); stem(n4,x4); title('Sequence in Problem 2.2d');

% P2.2e
x5 = zeros(size(n));
for k = 1:5,
    [x51,n51] = sigshift(x,n,k);
    x52 = n.*x51;
    x5 = sigadd(x5,n51,x52,n51);
end
subplot(3,2,6); stem(n51,x5); title('Sequence in Problem 2.2e');

%colordef white             % Default Color Scheme