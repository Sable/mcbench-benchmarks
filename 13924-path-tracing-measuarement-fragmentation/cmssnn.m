%Script cmssnn;
%Center of mass calculation
%xc, yc; xcc, ycc - coordinates of center
%of mass of curve and spot
%(interior of the curve) correspondingly
%mss - mass (square) of a spot
mss=sum(sum(~J3));
xcc=0;ycc=0;
  for i=1:si;
    for j=1:sj;
      if ~J3(i,j)
        xcc=xcc+i;
        ycc=ycc+j;
      end
    end
  end
    xcc=xcc/mss;
    ycc=ycc/mss;

xc=mean(X0);
yc=mean(Y0);

    kz=[];
for iz=1:numel(X0);
  kz=[kz max(sqrt((X0(iz)-X0(iz+1:end)).^2+(Y0(iz)-Y0(iz+1:end)).^2))];
end
[uz1,uz]=max(kz);
[kz1,kz2]=max(sqrt((X0(uz)-X0(1:end)).^2+(Y0(uz)-Y0(1:end)).^2));
