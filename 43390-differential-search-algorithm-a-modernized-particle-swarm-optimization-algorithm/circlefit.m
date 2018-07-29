%
% Example #1  Best-Fit Circle
%
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
function out=circlefit(X,mydata)

xdata=mydata.x;
ydata=mydata.y;

[N,~]=size(X);
out=ones(N,1); % pre-memory
for i=1:N
    x=X(i,:);
    a=x(1);
    b=x(2);
    r=x(3);
    
    out(i)=sum(abs((xdata-a).^2+(ydata-b).^2-repmat(r.^2,[size(xdata,1),1])));
end

% out---> Nx1 sized,  where N:size of superorganism (i.e., population size; pattern-matrix size)


