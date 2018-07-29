gammaa=[];
deltaa=[];
alphaa=[];
for lc=1:25
    gamma=4*pi*(rand-0.5)
    delta=4*pi*(rand-0.5)
    alpha=4*pi*(rand-0.5)
    an=ax_an_bounding(gamma,delta,alpha)
    gamma=an(2);
    delta=an(3);
    alpha=an(4);
    gammaa=[gammaa gamma];
    deltaa=[deltaa delta];
    alphaa=[alphaa alpha];
end

figure;
plot(gammaa,zeros(1,length(gammaa)),'.b');
title('gamma');

figure;
plot(deltaa,zeros(1,length(deltaa)),'.r');
title('delta');

figure;
plot(alphaa,zeros(1,length(alphaa)),'.r');
title('alpha');