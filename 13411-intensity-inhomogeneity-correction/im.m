function [] = im(I,r),
%
%
%
if exist('r','var'),
    imagesc(I,r);
else
    imagesc(I)
end
axis image,axis off
% impixelinfo
drawnow