
% generate test data:
[s, t]=meshgrid([0:0.3:pi/2], [0:0.3:pi]);

% create test data:
a=10; b=8; c=6;
xx=a*cos(s).*cos(t);
yy=b*cos(s).*sin(t);
zz=c*sin(s);

% add testing noise:
noiseIntensity = 0.3;
xx=xx+randn(size(s))*noiseIntensity;
yy=yy+randn(size(s))*noiseIntensity;
zz=zz+randn(size(s))*noiseIntensity;

% do the fitting
dx=xx(:); dy=yy(:); dz=zz(:);
n=size(dx,1);

D=[dx.*dx, dy.*dy,  dz.*dz, 2.*dy.*dz, 2.*dx.*dz, 2.*dx.*dy, ...
        2.*dx, 2.*dy, 2.*dz, ones(n,1)]';

S=D*D';

v=FindFit4(S);

minX=min(dx);  maxX=max(dx);
minY=min(dy);  maxY=max(dy);
minZ=min(dz);  maxZ=max(dz);

% draw fitting:
nStep=20;
stepA=a/nStep; stepB=b/nStep; stepC=c/nStep;

[x, y, z]=meshgrid(-a:stepA:a, -b:stepB:b, -c:stepC:c);


SolidObj=v(1)*x.*x+v(2)* y.*y+v(3)*z.*z+ 2*v(4)*y.*z + 2*v(5)*x.*z + 2*v(6)*x.*y...
    + 2*v(7)*x + 2*v(8)*y + 2*v(9)*z + v(10)* ones(size(x));


clf;
       p = patch(isosurface(x,y,z,SolidObj, 0.0));
       isonormals(x,y,z,SolidObj, p);
       set(p, 'FaceColor', 'y', 'EdgeColor', 'none');
       daspect([1 1 1]);
       view(3);
       camlight ;
       lighting phong;

       hold on;
plot3(dx, dy, dz, '.');
