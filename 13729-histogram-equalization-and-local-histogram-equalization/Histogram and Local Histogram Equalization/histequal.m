% %Program No:5
% Write a histogram equalization function.

function histequal(x)
f=imread(x);
g=histeq(f,256);
imshow(f);
figure, imhist(f);
figure, imshow(g);
figure, imhist(g);
