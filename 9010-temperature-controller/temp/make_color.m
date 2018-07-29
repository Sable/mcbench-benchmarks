function  c=make_color(r)
c0=zeros (256*r,1);
c255 (256*r,1)=255;
c255 (:,1)=255;
cf = linspace(0,255,256*r)';
cb = linspace(255,0,256*r)';

c=[c0 ,cf, c255 ; cf ,c255,cb ; c255 ,cb ,c0];