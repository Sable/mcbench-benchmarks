clear;  clc;
%P2.14b
nx = 0:3;       % Index for sequence x(n)
x = 1:4;        % Sequence x(n) = {1,2,3,4}
nh = 0:2;       % Index for impulse h(n)
h = 3:-1:1;     % Sequence h(n) = {3,2,1}
[ytilde,H]=conv_toe(h,x);