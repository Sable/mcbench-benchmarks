n=30^2; % number of vortecies

hf=figure('units','normalized','position',[0.02 0.15  0.95 0.7]);

% 1) test sphere_wp
subplot(1,2,1);
[K u] = sphere_wp(n);
h1=trisurf(K,u(:,1),u(:,2),u(:,3));
set(h1,'FaceColor',[0.7 0.7 0.7],'EdgeColor','none','FaceLighting','gouraud');
axis equal;
title('sphere\_wp');
light('Position',[1 -1 0],'Style','infinite');
light('Position',[10 10 10],'Style','infinite');
view(-2.5,48);


% 2) test sphere
subplot(1,2,2);
[X,Y,Z] = sphere(round(sqrt(n)));
h2=surf(X,Y,Z);
set(h2,'FaceColor',[0.7 0.7 0.7],'EdgeColor','none','FaceLighting','gouraud');
axis equal;
title('sphere');
light('Position',[1 -1 0],'Style','infinite');
light('Position',[10 10 10],'Style','infinite');
view(-2.5,48);
