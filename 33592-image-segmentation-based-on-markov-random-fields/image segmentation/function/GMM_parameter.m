function[mu,sigma]=GMM_parameter(image,segmentation,class_number)
[n,d]=size(image);
mu=zeros(class_number,d);
sigma=zeros(d,d,class_number);
   for i=1:class_number
       Im_i=image(segmentation==i,:);
       [sigma(:,:,i),mu(i,:)]=covmatrix(Im_i);
    end
end