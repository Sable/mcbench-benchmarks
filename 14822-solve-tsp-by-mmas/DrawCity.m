function plothandle=DrawCity(CityList,Tours)
xd=[];yd=[];
nc=length(Tours);
plothandle=plot(CityList(:,2:3),'.');
set(plothandle,'MarkerSize',16);
for i=1:nc
    xd(i)=CityList(Tours(i),2);
    yd(i)=CityList(Tours(i),3);
end
set(plothandle,'XData',xd,'YData',yd);
line(xd,yd);
title([num2str(nc-1),'城市游历路径图']);
