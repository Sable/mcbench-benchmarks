function [xxt,yyt]=angls2links2(bq)
global l1 l2 
l1=1;l2=1;
for j=1:size(bq,2)
        [x1(j),y1(j)]=pol2cart(bq(1,j),l1);
        [x2(j),y2(j)]=pol2cart(bq(2,j)+bq(1,j),l2);
        xx1(j,:)=linspace(0,x1(j));
        yy1(j,:)=linspace(0,y1(j));
        xx2(j,:)=linspace(0,x2(j));xx2(j,:)=xx2(j,:)+x1(j);
        yy2(j,:)=linspace(0,y2(j));yy2(j,:)=yy2(j,:)+y1(j);
end
xxt=[xx1,xx2];
yyt=[yy1,yy2];

%     [xs1,ys1]=pol2cart(qs1,l1);
%     [xs2,ys2]=pol2cart(qs2+qs1,l2);
%     xxs1=linspace(0,xs1);
%     yys1=linspace(0,ys1);
%     xxs2=linspace(0,xs2);xxs2=xxs2+xs1;
%     yys2=linspace(0,ys2);yys2=yys2+ys1;
      
      