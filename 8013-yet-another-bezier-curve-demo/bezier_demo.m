% bezier_demo
disp('Enter 4 points to define a Bezier curve and than edit it in WYSYWIG.');
disp('You can move both end points and control points. Close the window when you are ready.');

p=ginput(4);
c=num2cell(p(:)');
delete(gcf);
[x0,y0,x1,y1,x2,y2,x3,y3]=deal(c{:});
b=bezier('xpoints',[x0,y0,x1,y1,x2,y2,x3,y3]);
c=edit_curve(b)
hold on
disp('Now variable c contains a Bezier object.');

