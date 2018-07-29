warning('off','MATLAB:dispatcher:InexactMatch')
ax1=axes('Position',[0.016  .56  .4  .36]);
x1=[0.2  0.2  .325   .35   .40  .45  .50  .55  .60  .625   .70];
y1=[0.6  1.0  1.0    1.05  .95  1.05  .95  1.05 .95  1       1 ];
x2=[0.2  0.2  1.1  1.1];
y2=[0.4  0    0    .45];
h1=findobj('Tag','Axes1');
th=0:.005:2*pi;
x=0.2+0.1*cos(th);
y=0.5 +0.1*sin(th);
%xr=[0.5 0.5  0.45  0.55 0.45  0.55 0.45 0.55 0.45 0.55  0.5  0.5];
%yr=[0   .275 0.30  0.35 0.40  0.45 0.50 0.55 0.60 0.65  .675 1];
tho=0:.005:pi;
xo=0.05*cos(tho);
yo= 1 +.05*sin(tho);
xla=0.75+xo;
xlb=0.85+xo;
xlc=0.95+xo;

xl1=[1  1.1  1.1]; yl1=[1   1   0.55];
xl2=[0.8  .8]; yl2=[0.7 1];
xc1=[1.05  1.15]; yc1=[0.45  0.45]; yc2=[0.55 0.55];
plot(x1, y1,'b', x2,y2,'b','erasemode','none')
hold on
plot(x,y)
%plot(xr,yr)
plot(xla,yo),plot(xlb, yo), plot(xlc, yo)
plot(xl1,yl1,'b')
plot(xc1,yc1,'b', xc1, yc2,'b')
axis off
text(0.0, .5, 'V_s')
text(0.375, 1.15, 'R')
text(0.75, 1.15, 'L')
text(1.025, .35, 'C')
%text(.425, .825,'\downarrow')
text(.6, 1.1,'\rightarrow')
%text(1.025,.825,'\rightarrow')
text(0.175,.5,'\pm')
text(0.875, 1.125,'\rightarrow', 'color',[1 0 0])
text(.85,1.275, 'I_0', 'color',[1 0 0])
text(.9, .5, 'V_0', 'color',[1 0 0])
text(.95, .725,'+', 'color',[1 0 0])
text(.95, .3,'-', 'color',[1 0 0])
text(1.175, .5, 'v_C')
text(1.15, 0.9, '+')
text(1.15, 0.1, '-')
text(.425,.85,'v_R')
text(.3, 0.875, '+')
text(.55, 0.875, '-')

text(.625,1.2,'i')
text(.825,.85,'v_L')
text(.7, 0.875, '+')
text(.95, 0.875, '-')

hold off
%cla(ax1)