%ISCIRCLE    This program checks whether a point (x,y) lies inside,outside
%            or on a circle defined by 3 other points.
% 
%   Syntax: iscircle(X,Y,x,y), where X=[x1 x2 x3] and Y=[y1 y2 y3].
%           Thus, a circle can be made out of these 3 points-->(x1,y1),(x2,y2)&(x3,y3).
%           Program checks whether point (x,y) lies inside,outside or on the circle.
%           ans=0  ==> lie on the circle.
%           ans=1  ==> lie outside the circle.
%           ans=-1 ==> lie inside the circle.

function result=iscircle(X,Y,x,y)

x1=X(1);y1=Y(1);
x2=X(2);y2=Y(2);
x3=X(3);y3=Y(3);

k=((x1-x2)*(x2*x2-x3*x3+y2*y2-y3*y3)-(x2-x3)*(x1*x1-x2*x2+y1*y1-y2*y2))/((2)*((y2-y3)*(x1-x2)-(y1-y2)*(x2-x3)));
h=((y1-y2)*(y1+y2-2*k))/((2)*(x1-x2))+(x1+x2)/2;
r=sqrt((x3-h)*(x3-h)+(y3-k)*(y3-k));

val=(x-h)*(x-h)+(y-k)*(y-k)-r*r;

result=sign(val);