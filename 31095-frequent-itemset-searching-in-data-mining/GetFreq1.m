function AFreq1=GetFreq1(A,t)
% This function finds all frequent items with frequency(normalised) greater
% than threshold 't'
% A contains one transaction in each row with each column representing an item

a=mean(A,1);
AFreq1=find(a>=t);
if(numel(AFreq1)==0)
    AFreq1=0;
end

end