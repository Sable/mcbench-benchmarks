%
%   run an example of ordfilt3 on a noisy sphere.
%
%   for uint8, a 100x100x100 sphere dataset takes 2.75s on a P4 2.4GHz
clear
randn('seed',0)


[x,y,z] = meshgrid(1:100,1:100,1:100);
sphere = 20 + 200*( ( sqrt((x-50).^2+(y-50).^2+(z-50).^2) ) < 40 );
clear x y z
sphere = uint8(1*sphere + 50*randn(size(sphere)));

% -- median filter
tic
[Vr] = ordfilt3D(sphere,14);
toc
clf
% -- compare to box filter
subplot(221)
p1 = patch(isosurface(sphere,100), ...
   'FaceColor','blue','EdgeColor','none');
p2 = patch(isocaps(sphere,100), ...
    'FaceColor','interp','EdgeColor','none');
isonormals(sphere,p1)
view(3); axis vis3d square
camlight; lighting phong

subplot(222)
p1 = patch(isosurface(Vr,100), ...
   'FaceColor','blue','EdgeColor','none');
p2 = patch(isocaps(Vr,100), ...
    'FaceColor','interp','EdgeColor','none');
isonormals(Vr,p1)
view(3); axis vis3d square
camlight; lighting phong

%%
% show some slice
for k=1:20,
    subplot(223)
    imagesc( sphere(:,:,k) ,[0 255]),axis image
    title('original')
    
    subplot(224)
    imagesc( Vr(:,:,k) ,[0 255]),axis image
    title('Filtered with a 3D median filter')

    drawnow
end
