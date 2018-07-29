% DRAWGLOBE - Quickly plots a rotatable globe
%
% USAGE: drawglobe
%
% Michael Kleder, October 2004

function drawglobe
figure
axesm globe
h=displaym(worldlo('POline'));
set(h,'color','k')
sphere(100);
set(handlem('surface'),'edgecolor','none','facecolor',[.5 .5 .5])
gridm on
% seem to have some possible display issues in Matlab R14, so
% so these axis manipulations to remain compatible.
axis tight
axis equal
axis vis3d
axis off
view(0,45)