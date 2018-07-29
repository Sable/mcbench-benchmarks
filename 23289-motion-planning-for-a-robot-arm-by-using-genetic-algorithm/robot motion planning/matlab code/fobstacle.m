function a=fobstacle()
global l1 l2 l3 cond xx yy ox oy angles

qs1=cond(1);
qs2=cond(2);
qs3=cond(3);
qg1=cond(4);
qg2=cond(5);
qg3=cond(6);

[xs1,ys1]=pol2cart(qs1,l1);
[xs2,ys2]=pol2cart(qs2+qs1,l2);
[xs3,ys3]=pol2cart(qs3+qs2+qs1,l3);    
xxs1=linspace(0,xs1);
yys1=linspace(0,ys1);
xxs2=linspace(0,xs2);xxs2=xxs2+xs1;
yys2=linspace(0,ys2);yys2=yys2+ys1;
xxs3=linspace(0,xs3);xxs3=xxs3+xs2+xs1;
yys3=linspace(0,ys3);yys3=yys3+ys2+ys1;
xts=[xxs1,xxs2,xxs3];
yts=[yys1,yys2,yys3];

[xg1,yg1]=pol2cart(qg1,l1);
[xg2,yg2]=pol2cart(qg2+qg1,l2);
[xg3,yg3]=pol2cart(qg3+qg2+qg1,l3);
xxg1=linspace(0,xg1);
yyg1=linspace(0,yg1);
xxg2=linspace(0,xg2);xxg2=xxg2+xg1;
yyg2=linspace(0,yg2);yyg2=yyg2+yg1;
xxg3=linspace(0,xg3);xxg3=xxg3+xg2+xg1;
yyg3=linspace(0,yg3);yyg3=yyg3+yg2+yg1;
xtg=[xxg1,xxg2,xxg3];xtg=fliplr(xtg);
ytg=[yyg1,yyg2,yyg3];ytg=fliplr(ytg);

xt=[xts,xx,xtg];
yt=[yts,yy,ytg];
inn = inpolygon(ox,oy,xt,yt);
a1= ~any(any(inn));
if a1==1
   bq=angles;
   for j=1:size(angles,2)
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
   for w=1:size(ox,2) 
       in = inpolygon(xxt,yyt,ox(:,w),oy(:,w));
       a2(w)=any(any(in));
   end
   a2=~any(a2);  
   a=a1*a2;
else
    a=a1;
end