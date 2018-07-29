% Script to plot manufacturer's frequency response characterstic
% (phase only)
% Copyright 2010, MathWorks Inc.

%% REFERENCE DATA, Eaton SM4-40 Servovalve
RefFR_100_Frq =     [7 10 20 30 40 43 50 54];
RefFR_100_Phs = -1*[25 35 59 75 87 90 96 100];

RefFR_40_Frq =     [7 10 20 30 40 50 57 70];
RefFR_40_Phs = -1*[21 30 50 63 75 85 90 100];

%% PLOT TO COMPARE WITH DATA SHEET
figure(2)
semilogx(RefFR_40_Frq,-RefFR_40_Phs,'k-','LineWidth',2.5);
hold on
semilogx(RefFR_100_Frq,-RefFR_100_Phs,'k--','LineWidth',2.5);
hold off
axis([3 200 10 100]);
grid on
title('Manufacturer''s Data (Phase)','FontSize',14);
xlabel('Frequency (Hz)','FontSize',12);
ylabel('Phase (deg)','FontSize',12);
legend({'+/-40% Rated Current','+/-100% Rated Current'},'Location','Best');

