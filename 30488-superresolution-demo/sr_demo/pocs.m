function image=pocs(image,lr_image,ds,sh)

sh_image=gen_shift_downsample_image(image,ds,sh);
scale=lr_image./sh_image;
%         imshow(sh_image/255);
% %imagesc(scale);
% %         title(sprintf('tid: %d',tid));
%         pause;

scale=shift_image(kron(scale,ones(ds)),-sh);
image=image.*scale;