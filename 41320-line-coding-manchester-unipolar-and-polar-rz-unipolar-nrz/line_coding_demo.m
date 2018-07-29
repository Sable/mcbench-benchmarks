% Demo of using different line codings

bits = [1 0 1 0 0 0 1 1 0];
bitrate = 1; % bits per second

figure;
[t,s] = unrz(bits,bitrate);
plot(t,s,'LineWidth',3);
axis([0 t(end) -0.1 1.1])
grid on;
title(['Unipolar NRZ: [' num2str(bits) ']']);

figure;
[t,s] = urz(bits,bitrate);
plot(t,s,'LineWidth',3);
axis([0 t(end) -0.1 1.1])
grid on;
title(['Unipolar RZ: [' num2str(bits) ']']);

figure;
[t,s] = prz(bits,bitrate);
plot(t,s,'LineWidth',3);
axis([0 t(end) -1.1 1.1])
grid on;
title(['Polar RZ: [' num2str(bits) ']']);

figure;
[t,s] = manchester(bits,bitrate);
plot(t,s,'LineWidth',3);
axis([0 t(end) -1.1 1.1])
grid on;
title(['Manchester: [' num2str(bits) ']']);
