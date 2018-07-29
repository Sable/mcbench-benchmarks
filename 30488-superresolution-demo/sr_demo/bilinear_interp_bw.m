function imgout=bilinear_interp_bw(img)

imgout=bilinear_interp_1d(img);
imgout=bilinear_interp_1d(imgout');
imgout=imgout';

function imgout=bilinear_interp_1d(img)

interp=(img(:,1:size(img,2)-1)+img(:,2:size(img,2)))/2;

imgout=zeros(size(img,1),size(img,2)*2-1);
imgout(:,1:size(imgout,2)-1)=kron(img(:,1:size(img,2)-1),[1 0])+kron(interp,[0 1]);
imgout(:,size(imgout,2))=img(:,size(img,2));