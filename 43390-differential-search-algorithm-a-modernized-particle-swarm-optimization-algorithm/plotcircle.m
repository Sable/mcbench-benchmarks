%{

% pseudo-data setting
t=-pi:.01:pi; 
x=sin(t);
y=cos(t); 
xn=.05*randn(1,629);
yn=.05*randn(1,629); 
x=x+xn;
y=y+yn;

% additional data for objective function
mydata.x=x;
mydata.y=y;

ds(1,'circlefit',mydata,10,3,-10,10,2000)


plot(x,y,'o','markersize',2);
hold on
plotcircle(globalminimizer(1),globalminimizer(2),globalminimizer(3),'r')
daspect([1 1 1])
shg


%}
function plotcircle(a,b,r,color)

t=-pi:.01:pi;
x=a+r*sin(t);
y=b+r*cos(t);
x(end+1)=x(1);
y(end+1)=y(1);
plot(x,y,color,'linewidth',3);

