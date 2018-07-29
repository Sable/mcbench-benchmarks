%% vvxlabsimfile
%%
%% called when simulated

if cocurrent, file = 'dTlabvvx3der';
else file = 'dTlabvvx2der';
end

if useoutput,
   [t,T]=ode23t(file,[0 tmax],T(nt,1:2*n-2),[],par);
else
   [t,T]=ode23t(file,[0 tmax],[linspace(40,20,n-1) linspace(60,30,n-1)],[],par);
end


Tkin = par(6);
Tvin = par(7);
nt = length(t);

if cocurrent,
   tcut = T(nt,n-1);
   thut = T(nt,2*n-2);
else
   tcut = T(nt,1);
   thut = T(nt,2*n-2);
end


%-Räkna-ut-algebraiskt-riktiga-värden-för-feluppskattning-
op = optimset('display','off','tolc',1e-8,'tolfun',1e-8);
%tcutr = fzero('itererat',tcin,op,par); %Bra startgissning krävs
%[temp, tcutr, thutr, dtl] = itererat(tcutr,par);

if cocurrent,
   dtlg = ((thin-tcin)-(thut-tcut))/log((thin-tcin)/(thut-tcut));
else
   dtlg = ((thin-tcut)-(thut-tcin))/log((thin-tcut)/(thut-tcin));
end
try
   dtlg = fzero('itererat2',dtlg,op,par); %Bra startgissning krävs
   [temp, dtl, thutr, tcutr] = itererat2(dtlg,par);   
catch
   thutr = NaN;
   tcutr = NaN;   
end
%---------------------------------------------------------


%-Ge-feluppskattning-i-displayen--------------------------
set(findobj('tag','tcutr'),'string',num2str(tcutr));
set(findobj('tag','thutr'),'string',num2str(thutr));
set(findobj('tag','tcut'),'string',num2str(tcut));
set(findobj('tag','thut'),'string',num2str(thut));
set(findobj('tag','cerr'),'string',num2str((tcut-tcutr)/tcutr*100));
set(findobj('tag','herr'),'string',num2str((thut-thutr)/thutr*100));
%---------------------------------------------------------

%-Plotta--------------------------------------------------
ax2 = findobj('tag','Axes2');
axes(ax2)
plot(t,T(:,1),'b-',t,T(:,2*n-2),'r-')
grid on
set(ax2,'tag','Axes2')

ax1 = findobj('tag','Axes1');
axes(ax1)
if cocurrent,
   plot(1:n,[Tkin T(nt,1:n-1)],'b-',1:n,[Tvin T(nt,n:2*n-2)],'r-')
else
   plot(1:n,[T(nt,1:n-1) Tkin],'b-',1:n,[Tvin T(nt,n:2*n-2)],'r-')
end

xax = get(gca,'xtick');
yax = get(gca,'ytick');
axis([1 max(xax) 0 100])

t = text(n+0.2,thut,num2str(round(thutr*10)/10));
set(t,'fontname','tahoma')
set(t,'fontsize',8)
t = text(n+0.2,thin,num2str(thin));
set(t,'fontname','tahoma')
set(t,'fontsize',8)
t = text(n+0.2,(thut+thin)/2,num2str(round((thin-thutr)*10)/10));
set(t,'fontname','tahoma')
set(t,'fontsize',8)
t = text(1.2,tcut,num2str(round(tcutr*10)/10));
set(t,'fontname','tahoma')
set(t,'fontsize',8)
t = text(1.2,tcin,num2str(tcin));
set(t,'fontname','tahoma')
set(t,'fontsize',8)
t = text(1.2,(tcut+tcin)/2,num2str(round((tcutr-tcin)*10)/10));
set(t,'fontname','tahoma')
set(t,'fontsize',8)
t = text(n/2+0.2,(T(nt,n/2)+T(nt,n/2+n))/2,num2str(round(dtl*10)/10));
set(t,'fontname','tahoma')
set(t,'fontsize',8)

grid on
set(ax1,'tag','Axes1')
%---------------------------------------------------------
