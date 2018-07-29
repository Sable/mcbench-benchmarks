function DI=dunns(clusters_number,distM,ind)   
%%%Dunn's index for clustering compactness and separation measurement
% dunns(clusters_number,distM,ind)
% clusters_number = Number of clusters 
% distM = Dissimilarity matrix
% ind   = Indexes for each data point aka cluster to which each data point
% belongs
i=clusters_number;
denominator=[];

for i2=1:i
    indi=find(ind==i2);
    indj=find(ind~=i2);
    x=indi;
    y=indj;
    temp=distM(x,y);
    denominator=[denominator;temp(:)];
end

num=min(min(denominator)); 
neg_obs=zeros(size(distM,1),size(distM,2));

for ix=1:i
    indxs=find(ind==ix);
    neg_obs(indxs,indxs)=1;
end

dem=neg_obs.*distM;
dem=max(max(dem));

DI=num/dem;
end