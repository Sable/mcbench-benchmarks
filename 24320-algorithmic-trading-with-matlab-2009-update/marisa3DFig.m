% script to reproduce the 3D marisa figure
figure
isoplot(SS,NN,MM,SH);
set(gca,'view',[156,17],'dataaspectratio',[3.3333,2.3333,4])
set(gcf,'pos',[169, 215, 757, 423])
box, grid on
% labels
title('Sharpes Ratio hypersurface for intraday MA/RSI','fontweight','bold');

xl = get(gca,'xlabel');
set(xl,'pos',[1720.6,2603,1210],...
    'string','Frequency (minutes)',...
    'fontweight','bold');

yl = get(gca,'ylabel');
set(yl,'pos',[1997.7,2535.9,1297.7],...
    'string','Mov av. window',....
    'fontweight','bold');

zl= get(gca,'zlabel');
set(zl,'pos',[2099.7,2433.3,1474.1],...
    'string','RSI window',...
    'fontweight','bold')


