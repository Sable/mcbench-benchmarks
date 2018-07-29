function F = Fermi_Level(mdn, mdp, ED, EA, Material, EgO, alpha, beta, guess)

global k J mo h gD gA;

mdnAbs = mdn*mo;
mdpAbs = mdp*mo;

T=50:10:600;
ND=[1E12 1E13 1E14 1E15 1E16 1E17 1E18];
NA=ND;

options=optimset('TolFun',1E-100,'TolX',1E-100,'MaxIter',500,'MaxFunEvals',500,'Display','off');
barra=waitbar(0,strcat('Calculating Fermi Level in',Material));
for nd=1:length(ND)
    for m=1:length(T)
        Nc=(2*(2*pi*mdnAbs*(k*T(m)*J)/(h^2)).^(3/2))*1E-6;
        Nv=(2*(2*pi*mdpAbs*(k*T(m)*J)/(h^2)).^(3/2))*1E-6;
        Eg=EgO-(alpha*T(m).^2)./(T(m)+beta);
        Ec=Eg/2; Ev=-Ec; Ed=Ec-ED; Ea=Ev+EA;

        Ef(m,nd)=fsolve(@(Ef) neutral(Nv,Nc,ND(nd),Ev,Ec,Ed,Ef,k,T(m),gD),guess,options);
        Efp(m,nd)=fsolve(@(Efp) neutralp(Nv,Nc,NA(nd),Ev,Ec,Ea,Efp,k,T(m),gA),-guess,options);
    end
    waitbar(nd/length(ND),barra)
end
close(barra)

hand=figure;
set(hand,'Name',strcat('Fermi Level in',Material),'NumberTitle','off','Color',[0.65 0.81 0.82]);
screen=get(0,'ScreenSize');
width=screen(4);
large=screen(3);
set(hand,'position',[50,50,large-300,width-300]);
centerfig

colores=['b';'g';'r';'c';'m';'y';'k';'.'];
for col=1:length(ND)
    lines(col)=plot(T,Ef(:,col),colores(col),'LineWidth',2.5);
    hold on, grid on, axis([0 600 -1 1])
    StrLabelTemp = num2str(ND(col), '%10.E\n');
    StrLabels(col,1:length(StrLabelTemp)) = StrLabelTemp;
end

for colp=1:length(NA)
    plot(T,Efp(:,colp),colores(colp),'LineWidth',2.5);
    hold on, grid on
end

xlabel('T(K)','FontSize',12,'FontWeight','Bold'), ylabel('E_{f} - E_{i} (eV)','FontSize',12,'FontWeight','Bold'),title(strcat('Fermi level for ', Material, ' as a function of temperature and impurity concentration'),'FontWeight','Bold');
legend(lines, StrLabels,'Orientation','horizontal','Location','South');

Eg=EgO-(alpha*T.^2)./(T+beta);
Ec=Eg/2; 
Ev=-Ec;
Ei=((Ec+Ev)/2)+((k*T)/2)*log(Nv/Nc);

plot(T,Ec,'LineStyle',':','LineWidth',3,'Color',[0.502 0.502 0.502])
plot(T,Ev,'LineStyle',':','LineWidth',3,'Color',[0.502 0.502 0.502])
plot(T,Ei,'LineStyle',':','LineWidth',2,'Color',[0.502 0.502 0.502])