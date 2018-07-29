function AFreq2=GetFreq2(A,t,AFreq1)
[mAFreq1,nAFreq1]=size(AFreq1);
label=1;
for i=1:nAFreq1-1
    for j=i+1:nAFreq1
        f=mean(A(:,AFreq1(i))&A(:,AFreq1(j)));
%         conf=f/sum(A(:,AFreq1(i))&1);
        if(f>=t)
            AFreq2(label,1:2)=[AFreq1(i),AFreq1(j)]; %#ok<AGROW>
%             AFreq2(label,3)=conf;
            label=label+1;
        end
    end
end
if(label==1)
    AFreq2=0;
end
end