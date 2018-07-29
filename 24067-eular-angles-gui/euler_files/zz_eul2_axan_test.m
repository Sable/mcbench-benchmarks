gammaa=[];
deltaa=[];
alphaa=[];
for lc=1:1000
    phi=2*pi*rand;
    theta=pi*rand;
    psi=2*pi*rand;
    Ms=matrices(phi,theta,psi);
    M=Ms{1}*Ms{2}*Ms{3};
    % an={{gamma,delta,alpha},v};
    an=euler2axan(phi,theta,psi,M);
    an1=an{1};
    gamma=an1{1};
    delta=an1{2};
    alpha=an1{3};
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