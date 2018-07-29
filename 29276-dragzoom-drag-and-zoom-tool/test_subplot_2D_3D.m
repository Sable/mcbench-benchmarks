function test_subplot_2D_3D
%TEST_SUBPLOT_2D_3D Test mixed subplot 2D/3D with DRAGZOOM

figure;
hax1 = subplot(2,1,1);
x = -pi*2:0.1:pi*2;
y = sin(x);
plot(x,y);

hax2 = subplot(2,1,2);
k = 5;
n = 2^k-1;
[x,y,z] = sphere(n);
surf(x,y,z);

dragzoom();
