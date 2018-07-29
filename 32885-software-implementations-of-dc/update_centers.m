function [new_center,cl]=update_centers(SD,II,E,K,num,center)
center;
for iter1=2:num,  
    com=SD(:,iter1);
    i1=II(:,iter1);
    comp=[com,II(:,1),i1];
    if size(find(center),1)==num,
       aa=sortrows(comp);
       bb=flipud(aa);
    else
        for i=1:size(find(center),1)
            a=center(find(center));
            b(i,:)=comp(a(i),:);
        end
       aa=sortrows(b);
       bb=flipud(aa);
    end
    for iter2=1:size(bb,1),
        row=bb(iter2,2);
        column=bb(iter2,3);
        sum1=E(row,1);
        sum2=E(column,1);
        if sum1>sum2,
           center(column,:)=[0];
           comp(column,3)=[0];
        else
           center(row,:)=[0];
           comp(row,2)=[0];
        end
        new_center=find(center);
        kk=size(new_center,1);
        if kk==K,
            break;
        end   
    end
    if kk==K
       break;
    end  
end
for i=1:num,
    for j=1:K,
        ind2=find(II(i,:)==new_center(j));
        temp(j,:)=SD(i,ind2);
    end
    [a,b]=max(temp);
    cl(i,:)=new_center(b);
end