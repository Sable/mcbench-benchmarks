function out = MakeSampled(Seq,Samples,SamplesPerBit)
[m,n]=size(Seq);           % m = number of databit, n = number of user
if (m*SamplesPerBit>=Samples) 
    error ('Total Samples must be greater than databit*SamplesPerBit')
end
out = [];
for n1 = 1:n
    out1=[];
    for l = 1:m
        out1=[out1,Seq(l,n1).*ones(1,SamplesPerBit)];
    end
    out1 = [out1,zeros(1,Samples-length(out1))]';      % Zero Padding
    out = [out,out1];
end