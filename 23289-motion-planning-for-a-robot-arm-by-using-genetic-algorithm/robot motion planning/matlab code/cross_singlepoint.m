function off=cross_singlepoint(parent,croprop)% randum sigle point crossover
[pops,numvar]=size(parent);
d=[1:numvar];
for i=1:2:round(pops*croprop)
    w=ceil((length(d)-1)*rand);
    r=d(w);
    e=floor(rand*size(parent,1)); 
    if e==0
       e=1;   
    end
    offs(i,:)=[parent(e,1:r),parent(e+1,r+1:numvar)];
    offs(i+1,:)=[parent(e+1,1:r),parent(e,r+1:numvar)];
    parent(e:e+1,:)=[];
end
off=[offs;parent];