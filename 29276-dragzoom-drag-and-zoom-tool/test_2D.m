function test_2D
%TEST_2D Test 2D Plot with DRAGZOOM

x = -pi*4:0.1:pi*4;
y1 = sin(x);
y1n = y1 + 0.5 * randn(1, length(x));
y2 = cos(x);
y2n = y2 + 0.5 * randn(1, length(x));

figure();
hax = axes();
plot(hax, x, y1, '.-b', x, y1n, '*g', x, y2, '.-r', x, y2n, 'om');
legend('plot 1', 'plot 2', 'plot 3', 'plot 4')

dragzoom();

