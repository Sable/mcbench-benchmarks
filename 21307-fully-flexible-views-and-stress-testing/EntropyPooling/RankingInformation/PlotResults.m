function PlotResults(e,s,w,M,Lower,Upper)

N=length(M);
figure 

subplot('position',[0.05 .1 .3 .8])
h=barh(M*100);
set(h,'FaceColor',.8*[1 1 1],'EdgeColor',.4*[1 1 1])
if nargin > 4
    hold on
    Changed=0*M;
    Changed(union(Lower,Upper))=M(union(Lower,Upper))*100;;
    h=barh(Changed);
    set(h,'FaceColor','r','EdgeColor',.4*[1 1 1])
end
ylim([0 N+1])
grid on
title('expected returns')

subplot('position',[0.45 .1 .5 .8])
PlotFrontier(e*100,s*100,w)
title('frontier')

