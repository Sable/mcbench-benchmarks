% coordinates of the three rings (blue, red and green)
[X1,Y1,Z1]=torus(5-0.3,30,0.3,2); % the top (blue)
[X2,Z2,Y2]=torus(5+0.3,30,0.3,2); % inner gimbal (green, semi-transparent)
[X3,Z3,Y3]=torus(5+0.9,30,0.3,1); % outer gimbal (red, semi-transparent)

% handles to surf plots of the three rings
H1=surf(X1,Y1,Z1,'EdgeColor','none','FaceColor','blue'); hold on;
H2=surf(X2,Y2,Z2,'EdgeColor','none','FaceColor','green','FaceAlpha',0.3); 
H3=surf(X3,Y3,Z3,'EdgeColor','none','FaceColor','red','FaceAlpha',0.3); 

% creates the bars inside the inner (blue) ring. The wide cylinders
% represent weights.
[Xbar1,Ybar1,Zbar1,Xbar2,Ybar2,Zbar2]=createInnerBars(0.2,0.5,0.2,0.5);
bar1=surf(Xbar1,Ybar1,Zbar1,'EdgeColor','none','FaceColor','blue'); 
bar2=surf(Xbar2,Ybar2,Zbar2,'EdgeColor','none','FaceColor','blue'); 

% the red motionless supporting bar
[ Xupper,Yupper,Zupper,Xlower,Ylower,Zlower ] = createOuterBars( 0.3 );
surf(Xlower,Ylower,Zlower,...
    'EdgeColor','none','FaceColor','red','FaceAlpha',0.3);

hold off;
 camlight left;
 lighting gouraud; % phong is more demanding but gives nicer results
 bb=7;
 axis([-bb bb -bb bb -bb bb]);
axis square;
xlabel('x'); ylabel('y'); zlabel('z');