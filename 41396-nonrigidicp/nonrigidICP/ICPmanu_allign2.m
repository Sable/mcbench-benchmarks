function [distancemax,I,error,Reallignedsource]=ICPmanu_allign2(target,source)

[IDX1,d]=knnsearch(target,source,'K',3);
[IDX2,D]=knnsearch(source,target);

crossvector=cross((target(IDX1(:,2),:)-target(IDX1(:,1),:)),(target(IDX1(:,3),:)-target(IDX1(:,1),:)));
lengthy=sqrt(crossvector(:,1).^2+crossvector(:,2).^2+crossvector(:,3).^2);
unitvector=horzcat(crossvector(:,1)./lengthy,crossvector(:,2)./lengthy,crossvector(:,3)./lengthy) ;
secvec=source-target(IDX1(:,1),:);
Error=abs(sum(unitvector.*secvec,2));


[distancemax,I]=max(Error(:,1));

Datasetsource=vertcat(source,source(IDX2,:));
Datasettarget=vertcat(target(IDX1(:,1),:),target);

[error,Reallignedsource] = procrustes(Datasettarget,Datasetsource,'reflection',0);
Reallignedsource=Reallignedsource(1:length(source(:,1)),:);