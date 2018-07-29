function z2x_view(rv,zv,pv,z2x,ax)
posa=get(z2x,'UserData');

zm=2;

zoom off;
set(zv,'Value',false);
% rotate3d off;
% set(rv,'Value',false);

if get(z2x,'Value')
    x0=posa(1)+posa(3)/2;
    y0=posa(2)+posa(4)/2;
    set(ax,'Position',[x0-zm*posa(3)/2   y0-zm*posa(4)/2   zm*posa(3)   zm*posa(4)]);
else
    set(ax,'Position',posa);
end
