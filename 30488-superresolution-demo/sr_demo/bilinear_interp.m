function imgout=bilinear_interp(img)

% s=size(img);
% s(1:2)=2*s(1:2);
% imgout=zeros(s);

if length(size(img))==3
    for id=1:size(img,3)
        imgout(:,:,id)=bilinear_interp_bw(img(:,:,id));
    end
else
    imgout=bilinear_interp_bw(img);
end

