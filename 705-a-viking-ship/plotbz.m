%
% PLOTBZ
%
% Plottar en tvådimensionell bézierkurva i xz-planet

function r = plotbz(p1,b,c,p2,y,dt,plarg)    

t=(0:dt:1)';
F=[(1-t).^3 3*t.*(1-t).^2 3*t.^2.*(1-t) t.^3];
pbcp=[p1;b;c;p2];
r=F*pbcp;
plot3(r(:,1),y*ones(size(r(:,1))),r(:,2),plarg);





