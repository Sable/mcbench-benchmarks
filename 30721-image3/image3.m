function image3(mat)
%image3
% usage:
% clf
% mat = 0.1*rand(5,6,7);
% mat(2,3,4) = 1;
% image3(mat)
[nx,ny,nz] = size(mat);
c = [1 0 0];
[yrng_org, xrng_org, zrng_org] = meshgrid(1:ny,1:nx,1:nz);
xrng(1,:,:,:) = xrng_org-0.5;
xrng(2,:,:,:) = xrng_org+0.5;
yrng(1,:,:,:) = yrng_org-0.5;
yrng(2,:,:,:) = yrng_org+0.5;
zrng(1,:,:,:) = zrng_org-0.5;
zrng(2,:,:,:) = zrng_org+0.5;
tbl = [1 1 1 2;1 1 2 2; 1 2 2 2; 1 2 1 2];
xtbl = tbl(:,[3 3 4 1 3 3]);
ytbl = tbl(:,[2 2 3 3 4 1]);
ztbl = tbl(:,[4 1 2 2 2 2]);
x_tot = zeros(4,6,nx,ny,nz);
y_tot = x_tot;
z_tot = x_tot;
for vertex = 1:4
    for face = 1:6
        x_tot(vertex,face,:,:,:) = xrng(xtbl(vertex,face),:,:,:);
        y_tot(vertex,face,:,:,:) = yrng(ytbl(vertex,face),:,:,:);
        z_tot(vertex,face,:,:,:) = zrng(ztbl(vertex,face),:,:,:);
    end
end
x_tot = reshape(x_tot, 4, nx*ny*nz*6);
y_tot = reshape(y_tot, 4, nx*ny*nz*6);
z_tot = reshape(z_tot, 4, nx*ny*nz*6);

h = patch(x_tot,y_tot,z_tot,c);
set(h, 'FaceAlpha', 'flat');
alphamat = (mat(:)*ones(1,6))';
set(h,'FaceVertexAlphaData',alphamat(:))
set(h, 'EdgeAlpha', 0);
xlabel('x');
ylabel('y');
zlabel('z');
axis([0.5 nx+0.5 0.5 ny+0.5 0.5 nz+0.5])
view([41,28]);