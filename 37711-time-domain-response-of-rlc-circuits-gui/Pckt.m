warning('off','MATLAB:dispatcher:InexactMatch')
ax1=axes('Position',[0.016  .55  .4  .3]);
x1=[0.2  0.2  1.1  1.1];
y1=[0.6  1.0  1.0  .55];
x2=[0.2  0.2  1.1  1.1];
y2=[0.4  0    0    .45];
%h1=findobj('Tag','Axes1')
th=0:.005:2*pi;
x=0.2+0.1*cos(th);
y=0.5 +0.1*sin(th);
xr=[0.5 0.5  0.45  0.55 0.45  0.55 0.45 0.55 0.45 0.55  0.5  0.5];
yr=[0   .275 0.30  0.35 0.40  0.45 0.50 0.55 0.60 0.65  .675 1];
tho=-pi/2:.005:pi/2;
xo=0.8+0.05*cos(tho);
yo=.05*sin(tho);
xl=[xo     xo      xo       xo];
yl=[.35+yo 0.45+yo 0.55+yo  0.65+yo];
xl1=[0.8  .8]; yl1=[0 0.3];
xl2=[0.8  .8]; yl2=[0.7 1];
xc1=[1.05  1.15]; yc1=[0.45  0.45]; yc2=[0.55 0.55];
plot(x1, y1,'b', x2,y2,'b','erasemode','none')
hold on
plot(x,y)
plot(xr,yr)
plot(xl,yl)
plot(xl1,yl1,'b', xl2,yl2,'b')
plot(xc1,yc1,'b', xc1, yc2,'b')
axis off
text(0.025, .5, 'I_s')
text(0.375, .5, 'R')
text(0.75, .5, 'L')
text(1.0, .375, 'C')
text(.425, .825,'\downarrow')
text(.725, .825,'\downarrow')
text(1.025,.825,'\downarrow')
text(0.175,.485,'\uparrow')
text(0.725, 0.65,'\downarrow', 'color',[1 0 0])
text(.65,.65, 'I_0', 'color',[1 0 0])
text(.925, .5, 'V_0', 'color',[1 0 0])
text(.925, .65,'+', 'color',[1 0 0])
text(.925, .35,'-', 'color',[1 0 0])
text(1.2, .5, 'v')
text(1.15, 0.9, '+')
text(1.15, 0.1, '-')
text(.35,.9,'i_R')
text(.65,.9,'i_L')
text(.95,.9,'i_C')
hold off
%cla(ax1)