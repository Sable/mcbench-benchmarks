function [xxt,yyt]=angls2links(bq)
global l1 l2 l3       
for j=1:size(bq,2)
        [x1(j),y1(j)]=pol2cart(bq(1,j),l1);
        [x2(j),y2(j)]=pol2cart(bq(2,j)+bq(1,j),l2);
        [x3(j),y3(j)]=pol2cart(bq(3,j)+bq(2,j)+bq(1,j),l3);
        xx1(j,:)=linspace(0,x1(j));
        yy1(j,:)=linspace(0,y1(j));
        xx2(j,:)=linspace(0,x2(j));xx2(j,:)=xx2(j,:)+x1(j);
        yy2(j,:)=linspace(0,y2(j));yy2(j,:)=yy2(j,:)+y1(j);
        xx3(j,:)=linspace(0,x3(j));xx3(j,:)=xx3(j,:)+x2(j)+x1(j);
        yy3(j,:)=linspace(0,y3(j));yy3(j,:)=yy3(j,:)+y2(j)+y1(j);
end
xxt=[xx1,xx2,xx3];
yyt=[yy1,yy2,yy3];

        
     
      