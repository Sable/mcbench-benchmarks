function FDM=aggregateFDM(FDM,z,k,n)


for i=1:n
        tmp1=[];     tmp2=[];     tmp3=[];     tmp4=[];
    for j=1:k
        tmp1=[tmp1 FDM{j}{z,i}(1)];
        tmp2=[tmp2 FDM{j}{z,i}(2)];
        tmp3=[tmp3 FDM{j}{z,i}(3)];
        tmp4=[tmp4 FDM{j}{z,i}(4)];
    end
   Wj1a(i)=min(tmp1);
   Wj2a(i)=1/k*sum(tmp2);
   Wj3a(i)=1/k*sum(tmp3);
   Wj4a(i)=max(tmp4);
   
end
FDMtmp=[Wj1a; Wj2a; Wj3a; Wj4a];
for i=1:n
    FDM2{:,i}=FDMtmp(:,i)';
end
FDM=FDM2;

