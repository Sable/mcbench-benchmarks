function plot_spar(spar)
%% called using the simulation stop callback
% Copyright 2004-2013 The MathWorks, Inc.

y=spar(:,2)+j*spar(:,3);
radius=sqrt(spar(:,4).^2+spar(:,5).^2);
angle = unwrap(atan2(spar(:,5),spar(:,4)));
subplot(1,2,1), [lineseries,hsm] = smithchart(y); title('Syy');
% subplot(1,2,2), polar(angle,radius); title('Sxy')
subplot(1,2,2), plot(spar(:,1),20*log10(radius)); title('Sxy'); xlabel('Hz'); ylabel('dB')
set(gcf,'NumberTitle','off','Name','S Parameter Plots','Position',[100,100,1000,300]);


