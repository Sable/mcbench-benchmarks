function letplot(p,r,c)

%	LETPLOT(P) displays the bit map stored
%	column vector P. By default the bit map
%	is 7x5 pixels. For other sizes supply
%	the number of rows and columns, e.g.,
%	LETPLOT(P,12,8) for 12x8 patterns.
% 
%	   Ex:   P = LETNO;
%	         LETPLOT(P(:,7))
%	   displays the binary pattern of letter G

%	Author: Val Ninov, 1997, valninov@total.net

r = 7; c = 5;	% Pattern size

x=[-.1 -.1  .1 .1 ]*5;	%
y=[ .1 -.1 -.1 .1 ]*5;	%  Patch size
xx=zeros(r,c);
for i=1:r
 j=c*i-c+1;
xx(i,:)=p(j:j+c-1,1)';
end;
p = xx;
[r,c]=size(p);
figure(2);
clf reset
figrect = get(gcf,'Position');
set(gcf,'Position',[figrect(1:2) 180 180]);
hold on
axis('manual','off','ij')
axis([2 c-1 0 r+1])
axis('equal');
for j=1:c
  for i=1:r
   if p(i,j)==1
	u=x+j;
	v=y+i;
	fill(u,v,'g')
   else
	plot(j,i,'go','markersize',3)
   end
  end
end