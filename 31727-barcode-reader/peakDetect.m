function [pk,loc]=peakDetect(g,minHt,minDist)
% clear, load movAvgTest.mat, minHt=80; minDist=5;
n=length(g);
x=ones(size(g)); x=cumsum(x);
loc=[]; pk=[];
for i=2:n-1
    if g(i)>g(i-1)
        if g(i)>=g(i+1)
            if g(i)>minHt
                loc=[loc, i];
                pk=[pk, g(i)];
            end
        end
    end
end
% figure(1), plot(x,g,loc,pk,'or')
% select the max peak location within minDist
dloc=loc(2:end)-loc(1:end-1);
z=find(dloc<=minDist);
rej=[];
for i=1:length(z)
    if pk(z(i)+1)<pk(z(i))
        rej=[rej, z(i)+1];
    else
        rej=[rej, z(i)];
    end
end
loc(rej)=[]; pk(rej)=[];

% figure(2), plot(x,g,loc,pk,'or')