function [X,Y] = fusion2p(x1,y1,x2,y2,v1,v2,t)
 
x1 = double(x1);
y1 = double(y1);
x2 = double(x2);
y2 = double(y2);

r = double(v1/v2);
s = membership(r,t);
X = x2*(1-s) + x1*s;
Y = y2*(1-s) + y1*s;

end
