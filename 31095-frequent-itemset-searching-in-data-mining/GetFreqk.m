function AFreqk=GetFreqk(A,t,AFreq1,AFreqk0)

[m1,n1]=size(AFreq1);
[m0,n0]=size(AFreqk0);
count=0;
for i=1:m0
    Idx1=find(AFreq1==AFreqk0(i,1),1,'first');
    for j=Idx1+1:n1
        if(numel(find(AFreqk0(i,:)==AFreq1(j))))
            continue;
        else
            sm=A(:,AFreq1(j))&A(:,AFreqk0(i,1));
            for k=2:n0
                sm=sm&A(:,AFreqk0(i,k));
            end
            if(mean(sm)>=t)
                temp=sort([AFreq1(j),AFreqk0(i,:)]);
                flag1=0;
                for ii=1:count
                    if(temp==AFreqk(ii,:))
                        flag1=1;
                        break;
                    end
                end
                if(~flag1)
                    count=count+1;
                    AFreqk(count,:)=temp; %#ok<AGROW>
                end
            end
        end
    end
end

if(count==0)
    AFreqk=0;
end

end