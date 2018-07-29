% TRIDEMO  Demonstration of triangular
% mesh contouring
%
% R. Pawlowicz (rpawlowicz@eos.ubc.ca) Mar/2013



% Example
res=1000;    % Number o random points

% Create a grid and a triangulation.
x=rand(res,1)*6-3;
y=rand(res,1)*6-3;
M=delaunay(x,y);
z=peaks(x,y);
 
% Now, remove triangles in the middle, and a bite
% out of the upper right corner
 
ii=find(sqrt(x.^2+y.^2)<.6 | sqrt((x-3).^2+(y-2).^2)<1.5 );
jj=zeros(size(M,1),1);
for l=1:size(M,1);
  jj(l)=any( M(l,1)==ii | M(l,2)==ii | M(l,3)==ii );
end;
M=M(~jj,:);

  

clf; orient landscape;
set(gcf,'defaultaxestickdir','out','defaultaxesfontsize',16);
subplot(121);
xx=[ x(M(:,[1 2 3 1])');NaN(1,size(M,1)) ];
yy=[ y(M(:,[1 2 3 1])');NaN(1,size(M,1)) ];
plot(xx(:),yy(:));
title({'Randomly generated non-convex','triangular mesh'});
axis([-3 3 -3 3]);


subplot(122);
[CS,h]=tricontf(x,y,M,z);
set(h,'edgecolor','none');
hold on;
[CS,h]=tricont(x,y,M,z,'-k');
clabel(CS,h,'fontsize',14);
hold off;
title({'...and the ''peaks'' function','contoured over that mesh'});
axis([-3 3 -3 3]);
 
