function fakecolorbar
% Annoyingly, MATLAB changes the size of the subplot when a colorbar is
% added. Therefore, if a time series is plotted in two separate subplots,
% they will not line up if one subplot has a colorbar and the other does
% not. Use fakecolorbar to adjust the size of the subplots without
% colorbars to match the size of the subplots that do have colorbars.

colorbar
pos = get(gca,'position');
colorbar('delete')
set(gca,'position',pos)


end

