function out = MakeUnsampled(SampledSeq,SamplesPerBit,clipto)
if (clipto<1 || mod(clipto,SamplesPerBit)~=0),
    error('Error in Selecting Clipping Point')
end
SampledSeq = SampledSeq(1:clipto);
out = [];
n=length(SampledSeq(1,:));                  % Number of columns
for n1 = 1:n
    out1=[];
    for l = 1:SamplesPerBit:clipto
        out1=[out1,SampledSeq(l,n1)];
    end
    out = [out,out1'];
end