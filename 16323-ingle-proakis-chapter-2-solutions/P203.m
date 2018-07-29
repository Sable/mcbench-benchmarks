clear;  clc;
% P2.3b
n = -20:20;
x = cos (0.3*pi*n);         % Periodic Sequence T = 20/3
subplot(2,1,1); plot(n,x,'ko-');title('cos(0.3\pin)');xlabel('n');
% P2.3c
x = cos (0.3*n);            % Non-Periodic Sequence
subplot(2,1,2); plot(n,x,'ko-');title('cos(0.3n)');xlabel('n');