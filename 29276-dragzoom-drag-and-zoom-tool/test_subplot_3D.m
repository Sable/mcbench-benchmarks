function test_subplot_3D
%TEST_SUBPLOT_3D Test subplot 3D with DRAGZOOM

figure;
h1 = subplot(2,1,1);
[X,Y] = meshgrid(-3:.125:3);
Z = peaks(X,Y);
meshc(X,Y,Z);
axis([-3 3 -3 3 -10 10]);

h2 = subplot(2,1,2);
k = 5;
n = 2^k-1;
[x,y,z] = sphere(n);
surf(x,y,z);


dragzoom();
