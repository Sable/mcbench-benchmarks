function test_semilogy
%TEST_SEMILOGY Test semilogy Plot with DRAGZOOM

x = 0:100;
y = log10(x);

figure;
semilogy(y, x, '*-r')

dragzoom;

