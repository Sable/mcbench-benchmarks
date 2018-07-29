img = rgb2gray(im2double(imread('corner2.gif')));
[map r c] = susanCorner(img);
figure,imshow(img),hold on
plot(c,r,'o')