% script to test guided filter
% calling filtered = guilded_filter(input, guide, epsilon, win_size)

original = imread('peppers256.png');
original = double(original);
original = original / 255;

sd = sqrt(.001);
win_size = 5;

input = imnoise(original, 'gaussian', 0, sd*sd);
guide = input;

filtered = guided_filter(input, guide, .01, win_size);

figure; imshow(input, []);
title(['noisy image ', 'SNR=', num2str(-log10(sd)*20),'dB']);
figure; imshow(filtered, []);
title(['filtered image ', 'window size ', num2str(win_size)]);
