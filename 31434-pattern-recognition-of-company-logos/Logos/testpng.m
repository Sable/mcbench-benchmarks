function testpng
[h1,v1] = imcount('Aqua.png',300,0.7, 'no');
[h2,v2] = imcount('Coca-Cola.png',300,0.5,'no');
[h3,v3] = imcount('Michelin.png',300,0.5,'no');
[h4,v4] = imcount('IBM.png',300,0.5,'no');
[h5,v5] = imcount('NYY.png',300,0.5,'no');
figure(5)
hold on
plot(h1,v1)
plot(h2,v2,'r*')
plot(h3,v3,'co')
plot(h4,v4,'g+')
plot(h5,v5,'m.')
hold off
legend('Aqua','C-C','Mich','IBM','NYY');
saveas(gcf,'testpng.jpg')
%axis([0, 10, 0,10])
end