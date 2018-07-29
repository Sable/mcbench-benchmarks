%Script cmssn
%Center of mass calculation
%xc, yc; xcc, ycc - coordinates of center
%of mass of curve and spot
%(interior of the curve) correspondingly
%mss - mass (square) of a spot
mnx=min(x);mny=min(y);
mxx=max(x);mxy=max(y);
I1=I;
xcc=0;ycc=0;

for i=1:length(x);
 ii=0;
 while ~I1(x(i),y(i)+ii)
   I1(x(i),y(i)+ii)=1;
   ii=ii+1;
   if y(i)+ii>sj
     break
   end
 end
end
I=~xor(I1,I);
mss=sum(sum(~I(mnx:mxx,mny:mxy)));
if dg1<qint
  for i=mnx:mxx;
    for j=mny:mxy;
      if ~I(i,j)
        xcc=xcc+i;
        ycc=ycc+j;
      end
    end
  end
    xcc=xcc/mss;
    ycc=ycc/mss;
end
xc=mean(x);
yc=mean(y);
kz=[];
for iz=1:length(x)-1;
  kz=[kz max(sqrt((x(iz)-x(iz+1:end)).^2+(y(iz)-y(iz+1:end)).^2))];
end 
[uz1,uz]=max(kz);
[kz1,kz2]=max(sqrt((x(uz)-x(1:end)).^2+(y(uz)-y(1:end)).^2));
