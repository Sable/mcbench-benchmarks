[K u] = sphere_wp;
h=trisurf(K,u(:,1),u(:,2),u(:,3));
set(h,'FaceColor',[0.7 0.7 0.7],'EdgeColor','none','FaceLighting','gouraud');
axis equal;
light('Position',[1 -1 0],'Style','infinite');
% light('Position',[10 10 10],'Style','infinite');
xlim([-2,10]);
ylim([-2,2]);
zlim([-2,2]);

% animation loop:
u0=u;
for t=0:0.02:5
    R=1+0.2*sin(10*t); % change radius
    x=0+4+3*sin(8.1234*t); % change x position
    u=R*u0;
    u(:,1)=u(:,1)+x;
    set(h,'Vertices',u);
    drawnow;
    pause(1/50);
end
    
    