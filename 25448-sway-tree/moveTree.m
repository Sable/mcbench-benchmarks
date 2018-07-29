function moveTree(m,maxIt)
if nargin==0
    m=100000;
    maxIt=40;
end
ww=[0.52 0.7143 0 0 0 0.6
    0.28 0.5143 45 45 0 0.28
    0.4 0.5143 -45 -45 0 0.35
    0 0.428 0 0 0 0 ];
p=[0.25 0.25 0.25 0.25];
w=ww;
n=size(w,1);
x=zeros(1,m+1);
y=x;
sump=[0,cumsum(p)];
for q=1:maxIt
    pf=rand-0.5;
    powf=[10*pf 0.45*pf 0.45*pf 0.1*pf];
    for i=1:4
        w(i,1)=ww(i,1)*cos((ww(i,3)+powf(i))*pi/180);
        w(i,2)=-ww(i,2)*sin((ww(i,4)+powf(i))*pi/180);
        w(i,3)=ww(i,1)*sin((ww(i,3)+powf(i))*pi/180);
        w(i,4)=ww(i,2)*cos((ww(i,4)+powf(i))*pi/180);
    end
    for i=1:m
        r=rand;
        for j=1:n
            if r>sump(j) && r<=sump(j+1)
                x(i+1)=w(j,1)*x(i)+w(j,2)*y(i)+w(j,5);
                y(i+1)=w(j,3)*x(i)+w(j,4)*y(i)+w(j,6);
            end
        end
    end
    plot(x,y,'r.')
    axis off equal
    pause(0.1);
end