function test_polar()

t=0:0.01:2*pi;

figure;
polar(t, abs(sin(2*t).*cos(2*t)));

dragzoom
