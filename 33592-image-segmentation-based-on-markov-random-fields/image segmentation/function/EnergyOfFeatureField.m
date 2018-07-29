function [E]=EnergyOfFeatureField(image,mu,sigma,class_number)
n=size(image,1);
E=zeros(n,class_number);
for i=1:class_number
    mu_i=mu(i,:);
    sigma_i=sigma(:,:,i);
    diff_i=image-repmat(mu_i,[n,1]);
    E(:,i)=sum(diff_i*inv(sigma_i).*diff_i,2)+log(det(sigma_i));
end
end
