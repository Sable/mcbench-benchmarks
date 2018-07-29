%Voice Based Biometric System
%By Ambavi K. Patel.

%finds 20 centroids from equally partitioned mfcc matrix
function cb2=centr(mfcc1)
%partitioning mfcc1 matrix into 20 region and taking centroid from each
[r,c]=size(mfcc1);
dc=floor(c/10);
dr=floor(r/2);
for i=1:10
    for j=1:2
        x=(dr*(j-1))+1:dr*j;
        y=(dc*(i-1))+1:dc*i;
        t=dc+dr;
        cb1(j,i)=sum(sum(mfcc1(x,y)))/t;
    end;
end;
k=1;
for i=1:10
    for j=1:2
        cb2(1,k)=cb1(j,i);
        k=k+1;
    end;
end;

