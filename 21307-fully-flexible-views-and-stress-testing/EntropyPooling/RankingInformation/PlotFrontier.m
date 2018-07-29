function PlotFrontier(e,s,w)

% subplot(2,1,1)
% plot(s,e);
% grid on
% set(gca,'xlim',[min(s) max(s)])
% 
% subplot(2,1,2)
[xx,N]=size(w);
Data=cumsum(w,2);
for n=1:N
    x=[min(s); s; max(s)];
    y=[0; Data(:,N-n+1); 0];
    hold on
    h=fill(x,y,[.9 .9 .9]-mod(n,3)*[.2 .2 .2]);
end
set(gca,'xlim',[min(s) max(s)],'ylim',[0 max(max(Data))])
%xlabel('portfolio # (risk propensity)')
%ylabel('portfolio composition')