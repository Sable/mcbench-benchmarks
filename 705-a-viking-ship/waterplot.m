function f=waterplot(movefactor,watersurf,wcol)

% Uppbyggnad av vattenytans x-, y- och z-koordinater.
% Vattnet plottas med PLOT3.

global spunkter rpos botten nx ny wneg wpos

watersurface=watersurf;
qx=[]; qy=[]; qz=[];
for j=0:0.05:4
  wx=[]; wy=[]; wz=[];
  stop=-vlinjefunc(j,spunkter,1);   % Vattnets skärning med båten.
  for i=-2:0.05:stop
    wx=[wx j];
    wy=[wy i];
    wz=[wz 0.01*sin(j*10+movefactor)+0.01*sin(i*10)+watersurface];
  end
  wpos(round(20*j+1))=plot3(wx,wy,wz,wcol); hold on
  wneg(round(20*j+1))=plot3(wx,-wy,wz,wcol);
end
