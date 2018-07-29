function test_semilogx
%TEST_SEMILOGX Test semilogx Plot with DRAGZOOM

x = 0:100;
y = log10(x);

figure;
semilogx(x, y, '*-b')

dragzoom;

