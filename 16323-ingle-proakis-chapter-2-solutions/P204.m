clear; clc;
% P2.4
x = [1,-2,4,6,-5,8,10];
n = [-4:2];

% P2.4a
[x11,n11] = sigshift(x,n,-2);
[x12,n12] = sigshift(x,n,4);
[x1,n1] = sigadd(3*x11,n11,x12,n12);
[x1,n1] = sigadd(x1,n1,-2*x,n);
[xe,xo,m] = evenodd(x1,n1);
figure(1);
subplot(2,2,1); stem(n1,x1,'ko'); title('Original Sequence')
xlabel('n'); ylabel('x(n)');
subplot(2,2,2); stem(m,xe,'ko'); title('Even Part')
xlabel('n'); ylabel('xe(n)');
subplot(2,2,4); stem(m,xo,'ko'); title('Odd Part')
xlabel('n'); ylabel('xo(n)');

% P2.4b
[x21,n21] = sigshift(x,n,-5);
[x22,n22] = sigshift(x,n,-4);
[x2,n2] = sigadd(5*x21,n21,4*x22,n22);
[x2,n2] = sigadd(x2,n2,3*x,n);
[xe,xo,m] = evenodd(x2,n2);
figure(2);
subplot(2,2,1); stem(n2,x2,'ko'); title('Original Sequence')
xlabel('n'); ylabel('x(n)');
subplot(2,2,2); stem(m,xe,'ko'); title('Even Part')
xlabel('n'); ylabel('xe(n)');
subplot(2,2,4); stem(m,xo,'ko'); title('Odd Part')
xlabel('n'); ylabel('xo(n)');

% P2.4c
[x31,n31] = sigshift(x,n,-4);
[x32,n32] = sigshift(x,n,1);
[x33,n33] = sigmult(x31,n31,x32,n32);
[x31,n31] = sigfold(x,n);    [x31,n31] = sigshift(x31,n31,2);
[x32,n32] = sigmult(x31,n31,x,n);
[x3,n3] = sigadd(x33,n33,x32,n32);
[xe,xo,m] = evenodd(x3,n3);
figure(3);
subplot(2,2,1); stem(n3,x3,'ko'); title('Original Sequence')
xlabel('n'); ylabel('x(n)');
subplot(2,2,2); stem(m,xe,'ko'); title('Even Part')
xlabel('n'); ylabel('xe(n)');
subplot(2,2,4); stem(m,xo,'ko'); title('Odd Part')
xlabel('n'); ylabel('xo(n)');

% P2.4d
[x41,n41] = sigshift(x,n,-2);
x42 = cos(0.1*pi*n);
[x42,n42] = sigmult(x42,n,x41,n41);
x43 = 2*exp(0.5*n);
[x41,n41] = sigmult(x43,n,x,n);
[x4,n4] = sigadd(x42,n42,x41,n41);
[xe,xo,m] = evenodd(x4,n4);
figure(4);
subplot(2,2,1); stem(n4,x4,'ko'); title('Original Sequence')
xlabel('n'); ylabel('x(n)');
subplot(2,2,2); stem(m,xe,'ko'); title('Even Part')
xlabel('n'); ylabel('xe(n)');
subplot(2,2,4); stem(m,xo,'ko'); title('Odd Part')
xlabel('n'); ylabel('xo(n)');

% P2.4e
x5 = zeros(size(n));
for k = 1:5,
    [x51,n51] = sigshift(x,n,k);
    x52 = n.*x51;
    x5 = sigadd(x5,n51,x52,n51);
end
[xe,xo,m] = evenodd(x5,n51);
figure(5);
subplot(2,2,1); stem(n51,x5,'ko'); title('Original Sequence')
xlabel('n'); ylabel('x(n)');
subplot(2,2,2); stem(m,xe,'ko'); title('Even Part')
xlabel('n'); ylabel('xe(n)');
subplot(2,2,4); stem(m,xo,'ko'); title('Odd Part')
xlabel('n'); ylabel('xo(n)');