% Colin O'Flynn, 2011
% Public Domain
% Used to generate files for presentation

N=10;

data = (round(rand(1,N))-0.5)*2;
noisey = 1/sqrt(2)*randn(1,N) + data;
hard = sign(noisey);

figure
subplot(3,1,1);
bar(1:N, data);
axis([1 N -2 2])
title('Original Data')

subplot(3,1,2);
bar(1:N, noisey);
axis([1 N -2 2])
title('Data with AWGN')

subplot(3,1,3);
bar(1:N, hard);
axis([1 N -2 2]);
title('Hard Decision')

