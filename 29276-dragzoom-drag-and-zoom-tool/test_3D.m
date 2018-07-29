function test_3D
%TEST_3D Test 3D Plot with DRAGZOOM

figure;
[X,Y] = meshgrid(-3:.125:3);
Z = peaks(X,Y);
meshc(X,Y,Z);
axis([-3 3 -3 3 -10 10]);

xlabel('x');
ylabel('y');
zlabel('z');

dragzoom;
