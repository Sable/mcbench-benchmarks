function segmentation=ICM(image,class_number,potential,maxIter)
[width,height,bands]=size(image);
image=imstack2vectors(image);
[segmentation,c]=kmeans(image,class_number);
%segmentation=reshape(id,[width height]);
clear c;
iter=0;
while(iter<maxIter)
    [mu,sigma]=GMM_parameter(image,segmentation,class_number);
    Ef=EnergyOfFeatureField(image,mu,sigma,class_number);
    E1=EnergyOfLabelField(segmentation,potential,width,height,class_number);
    E=Ef+E1;
    [tm,segmentation]=min(E,[],2);
    iter=iter+1;
end
segmentation=reshape(segmentation,[width height]);
end