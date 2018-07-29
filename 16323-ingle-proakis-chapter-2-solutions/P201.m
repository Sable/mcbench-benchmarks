% P2.1a
n  = [0:25];
x1 = zeros(1,26);
for m=0:10,
    x1 = x1 + (m-1).*(impseq(2.*m,0,25)-impseq(2.*m+1,0,25));
end
subplot(3,2,1);
stem(n,x1);
title('Sequence in Problem 2.1a')

% P2.1b
n = [-25:25];
x2 = n.^2.*(stepseq(-5,-25,25)-stepseq(6,-25,25)) + 10*impseq(0,-25,25) + 20*0.5.^n.*(stepseq(4,-25,25)-stepseq(10,-25,25));
subplot(3,2,2);
stem(n,x2);
title('Sequence in Problem 2.1b')

% P2.1c
n = [0:20];
x3 = 0.9.^n.*cos(0.2*pi.*n + pi/3);
subplot(3,2,3);
stem(n,x3);
title('Sequence in Problem 2.1c')

% P2.1d
n = [0:100];
x4 = 10.*cos(0.008*pi.*n.^2) + randn(size(n));
subplot(3,2,4);
stem(n,x4);
title('Sequence in Problem 2.1d')

% P2.1e
x5 = [2,1,2,3];
x5 = x5' * ones(1,5);      % Plots 5 periods
x5 = (x5(:))';
n = [0:size(x5)];
subplot(3,2,5);
stem(x5);
title('Sequence in Problem 2.1e')