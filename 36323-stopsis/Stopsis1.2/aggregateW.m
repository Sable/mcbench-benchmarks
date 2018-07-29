function W=aggregatew(WD,k,n)

for i=1:n
    tmp1=[];     tmp2=[];     tmp3=[];     tmp4=[];
    for j=1:k
        tmp1=[tmp1 WD{j}{i}(1)];
        tmp2=[tmp2 WD{j}{i}(2)];
        tmp3=[tmp3 WD{j}{i}(3)];
        tmp4=[tmp4 WD{j}{i}(4)];
    end
    Wj1a(i)=min(tmp1);
    Wj2a(i)=1/k*sum(tmp2);
    Wj3a(i)=1/k*sum(tmp3);
    Wj4a(i)=max(tmp4);
end

W=[Wj1a;Wj2a;Wj3a;Wj4a];
%Here we just take transpose to get them in more suitable form.
for i=1:n
    Wv(i,:)=W(:,i)';
end
W=Wv;