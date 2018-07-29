function test_subplot_2D
%TEST_SUBPLOT_2D Test subplot 2D with DRAGZOOM

figure('Units', 'pixels');
x = -pi*2:0.1:pi*2;
y1 = sin(x);
y2 = cos(x);
y3 = sin(x).^3 - cos(x).^2;

hax1 = subplot(3, 1, 1); 
plot(hax1, x, y1, '.-r')

hax2 = subplot(3, 1, 2); 
plot(hax2, x, y2, 'o-b')

hax3 = subplot(3, 1, 3); 
plot(hax3, x, y3, '*-g')
legend('test')

% dragzoom([hax1; hax3]); % manage only axes 1 and axes 3
dragzoom()
