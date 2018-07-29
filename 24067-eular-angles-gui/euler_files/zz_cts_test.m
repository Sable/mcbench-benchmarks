thetaa=[];
phia=[];
for lc=1:1000
    rn=random_n;
    [theta,phi,R] = cart2sph(rn(1),rn(2),rn(3));
    thetaa=[thetaa theta];
    phia=[phia phi];
end
figure;
plot(thetaa,zeros(1,length(thetaa)),'.b');
title('theta');

figure;
plot(phia,zeros(1,length(phia)),'.r');
title('phi');