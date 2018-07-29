%
% This demo shows the designed of filters and some figures in 
%
% Ha T. Nguyen and Minh N. Do, Hybrid Filter Banks with Fractional Delays:
% Minimax Design and Application to Multichannel Sampling, vol. 56, no. 7,
% pp. 3180-3190, July 2008.

initialization;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Design of (IIR for FIR) synthesis filters F_i(z)

% Design IIR synthesis filters F_i(z)
[num, den, gamma] = designIIR(phi, D, m0, h, M);

% Design FIR synthesis filters F_i(z)
% [num, den, gamma] = designFIR(phi, D, m0, h, M, n);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo of the approximation of the high-resolution signal
% Filtering using the synthesis filters F_i(z)
y0hat = 0*y0;

for i = 1:N
    z = filter(num{i}, den{i}, upsample(x{i},M));
    y0hat = y0hat + z(1:L);
end

% Approximation error
e = y0 - y0hat;

% Compute the errors
max(e)
mean(e(1:200).^2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the results, 

% Plot Fig. 9
figure(9);
bode(numphi, denphi);
title('Bode diagram of \Phi(s)')

% Plot Fig. 10
plot_equi_filters;

% Plot of Fig. 11 
% (plot only the first 2 filters if more than 2 are available)
figure(11);
freqz(num{1}, den{1});
hold on;
freqz(num{2}, den{2});

% figure;
% plot(e(1:200));
% xlabel('sample');
% ylabel('error');
% title('Approximation error')

% Plot Fig. 12
figure(12);
plot(e(1:50));
hold on;
plot(y0(1:50), 'r--')
xlabel('sample');
ylabel('error');
legend('error', 'signal')
title('Approximation error vs the high resolution signal')



