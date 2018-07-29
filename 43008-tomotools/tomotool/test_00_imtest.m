%TEST 00: Test Image
clear
clc
fprintf('TEST 00: Show test images.\r');
for k = 0:10
    figure
    imshow(imtest(k))
end
