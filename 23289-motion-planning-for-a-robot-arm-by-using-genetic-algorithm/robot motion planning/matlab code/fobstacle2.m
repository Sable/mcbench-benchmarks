function a=fobstacle2(xx,yy)
global l1 l2 para ox2 oy2 angles

qs1=para(1);
qs2=para(2);
qg1=para(3);
qg2=para(4);

[xs1,ys1]=pol2cart(qs1,l1);
[xs2,ys2]=pol2cart(qs2+qs1,l2);
xxs1=linspace(0,xs1);
yys1=linspace(0,ys1);
xxs2=linspace(0,xs2);xxs2=xxs2+xs1;
yys2=linspace(0,ys2);yys2=yys2+ys1;
xts=[xxs1,xxs2];
yts=[yys1,yys2];

[xg1,yg1]=pol2cart(qg1,l1);
[xg2,yg2]=pol2cart(qg2+qg1,l2);
xxg1=linspace(0,xg1);
yyg1=linspace(0,yg1);
xxg2=linspace(0,xg2);xxg2=xxg2+xg1;
yyg2=linspace(0,yg2);yyg2=yyg2+yg1;
xtg=[xxg1,xxg2];xtg=fliplr(xtg);
ytg=[yyg1,yyg2];ytg=fliplr(ytg);

xt=[xts,xx,xtg];
yt=[yts,yy,ytg];
inn = inpolygon(ox2,oy2,xt,yt);
a1=~any(inn);
if a1==1
   bq=angles;
   for j=1:7
       [x1(j),y1(j)]=pol2cart(bq(1,j),l1);
       [x2(j),y2(j)]=pol2cart(bq(2,j)+bq(1,j),l2);
       xx1(j,:)=linspace(0,x1(j));
       yy1(j,:)=linspace(0,y1(j));
       xx2(j,:)=linspace(0,x2(j));xx2(j,:)=xx2(j,:)+x1(j);
       yy2(j,:)=linspace(0,y2(j));yy2(j,:)=yy2(j,:)+y1(j);
   end
   xxt=[xx1,xx2];
   yyt=[yy1,yy2];
   in = inpolygon(xxt,yyt,ox2,oy2);
   a2=~any(any(in));
   a=a1*a2;
else
    a=a1;
end