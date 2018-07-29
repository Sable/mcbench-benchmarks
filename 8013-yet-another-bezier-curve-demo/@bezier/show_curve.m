function show_curve(b)
% function show_curve(b)


if ~strcmpi(class(b),'bezier')
  error('Expecting a bezier object');
end


t=0:0.01:1;
t2=t.^2;
t3=t2.*t;
x=b.ax*t3+b.bx*t2+b.cx*t+b.x0;
y=b.ay*t3+b.by*t2+b.cy*t+b.y0;

plot(x,y,'b',[b.x0],[b.y0],'r*',...
     [b.x1],[b.y1],'ro',...
     [b.x0,b.x1],[b.y0,b.y1],'r',...
     [b.x2],[b.y2],'ro',...
     [b.x3],[b.y3],'r*',...
     [b.x2,b.x3],[b.y2,b.y3],'r');

text([b.x0],[b.y0],'(x_0,y_0)'); 
text([b.x1],[b.y1],'(x_1,y_1)'); 
text([b.x2],[b.y2],'(x_2,y_2)'); 
text([b.x3],[b.y3],'(x_3,y_3)'); 