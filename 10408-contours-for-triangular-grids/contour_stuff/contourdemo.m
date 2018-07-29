function contourdemo

% Demo function for tricontour
%
% Darren Engwirda - 2006

clc, close all



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Driven Cavity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

answer = lower(input(['This is a demo function for tricontour. \n'                                 ...
                      '\n'                                                                         ...
                      'The following meshes were generated using my mesh generator, "mesh2d.m" \n' ...
                      'and the data comes from my CFD code "Navier2d.m" \n'                        ...
                      '\n'                                                                         ...
                      'Continue?? [y/n] \n'],'s'));

if ~strcmp(answer,'y')
    return
end

load driven_cavity.mat

node  = old_data.node;
cnect = old_data.cnect;
p     = old_data.p;
t     = old_data.t;
U     = old_data.U;
V     = old_data.V;
P     = old_data.P;

figure

subplot(1,2,1), trimesh(t,p(:,1),p(:,2),U), axis square, title('X velocity')
subplot(1,2,2), trimesh(t,p(:,1),p(:,2),V), axis square, title('Y velocity')


figure

set(gcf,'Name','The xy velocity components for a box flow')

subplot(1,2,1), tricontour(p,t,U,15); axis equal, axis off, title('X velocity')
subplot(1,2,2), tricontour(p,t,V,15); axis equal, axis off, title('Y velocity')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Tester
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

answer = lower(input(['As well as making pretty pictures, the correct contouring interval is \n'  ...
                      'actually represented. \n'                                                  ...
                      '\n'                                                                        ...
                      'The following shows the contours of distance from a point at [0.5,0.5] \n' ...
                      'The function is correctly showing the contours at a distance of \n'        ...
                      '[0.1,0.2,0.3,0.4] \n'                                                      ...
                      '\n'                                                                        ...
                      'Continue?? [y/n] \n'],'s'));

if ~strcmp(answer,'y')
    return
end

xc = 0.5;
yc = 0.5;
d  = sqrt( (p(:,1)-xc).^2+(p(:,2)-yc).^2 );

figure, trimesh(t,p(:,1),p(:,2),d)
figure, [c,h]=tricontour(p,t,d,[0.1,0.2,0.3,0.4]); clabel(c,h), axis equal, grid on, hold on, plot(0.5,0.5,'bx')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       Vortex Shedding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

answer = lower(input(['The domain can be complex. The following example is a domain with holes. \n'             ...
                      '\n'                                                                                      ...
                      'The complexity of the domain shouldn''t matter, you just need a valid triangulation. \n' ...
                      '\n'                                                                                      ...
                      'Continue?? [y/n] \n'],'s'));

if ~strcmp(answer,'y')
    return
end

close all

load vortex_shedding.mat

node  = old_data.node;
cnect = old_data.cnect;
p     = old_data.p;
t     = old_data.t;
U     = old_data.U;
V     = old_data.V;
P     = old_data.P;
W     = old_data.W;

figure

trimesh(t,p(:,1),p(:,2),U), axis square, title('X velocity')


figure

set(gcf,'Name','The x velocity for the flow over a cylinder')

% Velocity contours
tricontour(p,t,U,50), axis equal, axis off, title('X velocity')

% Walls
patch('faces',cnect,'vertices',node,'facecolor','none','edgecolor','k')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Peaks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

answer = lower(input(['A standard contouring benchmark showing the operation of clabel. \n' ...
                      '\n'                                                                  ...                                                                                    ...
                      'Continue?? [y/n] \n'],'s'));

if ~strcmp(answer,'y')
    return
end

close all


[xx,yy] = meshgrid(linspace(-3,3,64),linspace(-2.5,2.5,64));
zz      = peaks(xx,yy);
v       = -3:5;
figure(1)
[c,h] = contour(xx,yy,zz,v);
clabel(c,h)
title('Contour')

% Triangulate
p = [xx(:),yy(:)];
t = delaunayn(p);

figure(2)
[c,h] = tricontour(p,t,zz(:),v);
clabel(c,h)
title('Tricontour')
