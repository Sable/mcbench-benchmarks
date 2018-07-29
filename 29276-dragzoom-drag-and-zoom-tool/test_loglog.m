function test_loglog
%TEST_LOGLOG Test loglog Plot with DRAGZOOM

x = logspace(-1,2);

figure;
loglog(x, exp(x),'-s')

dragzoom;

