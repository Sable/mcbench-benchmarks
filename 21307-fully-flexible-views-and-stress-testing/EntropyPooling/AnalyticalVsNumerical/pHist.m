function h=pHist(X,p,nBins)

[n,x] = hist(X,nBins);
D=x(2)-x(1);
np=0;
for s=1:length(x)
    Index=find( (X>=x(s)-D/2) & (X<=x(s)+D/2) );
    np(s)=sum(p(Index));
    f=np/D;
end

h=bar(x,f,1);
h = findobj(gca,'Type','patch');
set(h,'FaceColor',.6*[1 1 1],'EdgeColor',.6*[1 1 1])
grid on