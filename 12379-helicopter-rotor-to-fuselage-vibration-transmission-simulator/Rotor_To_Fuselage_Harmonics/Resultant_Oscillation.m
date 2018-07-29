function [] = Resultant_Oscillation( Nb,n )

% Nb=10;
% n=10;
% figure(1)
% hold on

R=100;

psi=[0:1:360]*pi/180;

npsi=length(psi);

bih1=sin(psi);

for i=0:Nb-1
    bihn(i+1,:)=sin(n*(2*i*pi/Nb+psi));
end
resultant=sum(bihn);
if max(resultant)>1e-3
    resultant=resultant/max(resultant);
end

% title('Resultant Oscillation Transmitted to Hull','Position',[179.129 1.007 17.321],'FontWeight','Bold')
hold on
axis([0,360,-1,1])
Waves=plot(psi*180/pi,resultant,'r',  psi*180/pi,bih1,'b');
% legend('Transmitted','1 Per rev','Location','BestOutside')
set(gca,'ytick',0)
set(gca,'xtick',[0:90:360])
set(gca,'XAxisLocation','top')
set(gca,'XTickLabel',[])
set(gca,'YTickLabel',[])

grid on
save DataFile1 Waves