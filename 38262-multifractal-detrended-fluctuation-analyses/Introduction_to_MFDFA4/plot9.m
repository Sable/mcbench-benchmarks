X1=cumsum(multifractal-mean(multifractal));
X2=cumsum(monofractal-mean(monofractal));
X3=cumsum(whitenoise-mean(whitenoise));
X1=transpose(X1);
X2=transpose(X2);
X3=transpose(X3);

scmin=16;
scmax=1024;
scres=19;
exponents=linspace(log2(scmin),log2(scmax),scres);
scale1=round(2.^exponents);
q1=linspace(-5,5,101);
m1=1;
for ns=1:length(scale1),
    segments1(ns)=floor(length(X1)/scale1(ns));
    for v=1:segments1(ns),
        Index1=((((v-1)*scale1(ns))+1):(v*scale1(ns)));
        C1=polyfit(Index1,X1(Index1),m1);
        C2=polyfit(Index1,X2(Index1),m1);
        C3=polyfit(Index1,X3(Index1),m1);
        fit1=polyval(C1,Index1);
        fit2=polyval(C2,Index1);
        fit3=polyval(C3,Index1);
        RMS_scale1{ns}(v)=sqrt(mean((X1(Index1)-fit1).^2));
        RMS_scale2{ns}(v)=sqrt(mean((X2(Index1)-fit2).^2));
        RMS_scale3{ns}(v)=sqrt(mean((X3(Index1)-fit3).^2));
    end
    for nq=1:length(q1),
        qRMS1{ns}=RMS_scale1{ns}.^q1(nq);
        qRMS2{ns}=RMS_scale2{ns}.^q1(nq);
        qRMS3{ns}=RMS_scale3{ns}.^q1(nq);
        Fq1(nq,ns)=mean(qRMS1{ns}).^(1/q1(nq));
        Fq2(nq,ns)=mean(qRMS2{ns}).^(1/q1(nq));
        Fq3(nq,ns)=mean(qRMS3{ns}).^(1/q1(nq));
    end
end
for nq=1:length(q1),
    Ch1 = polyfit(log2(scale1),log2(Fq1(nq,:)),1);
    Hq1(nq) = Ch1(1);
    
    Ch2 = polyfit(log2(scale1),log2(Fq2(nq,:)),1);
    Hq2(nq) = Ch2(1);

    Ch3 = polyfit(log2(scale1),log2(Fq3(nq,:)),1);
    Hq3(nq) = Ch3(1);
end
if isempty(find(q1==0, 1))==0,
    qzero=find(q1==0);
    Hq1(qzero)=(Hq1(qzero-1)+Hq1(qzero+1))/2;
    Hq2(qzero)=(Hq2(qzero-1)+Hq2(qzero+1))/2;
    Hq3(qzero)=(Hq3(qzero-1)+Hq3(qzero+1))/2;
end
tq1 = Hq1.*q1-1;
tq2 = Hq2.*q1-1;
tq3 = Hq3.*q1-1;

hq1 = diff(tq1)./(q1(2)-q1(1));
Dq1 = (q1(1:end-1).*hq1)-tq1(1:end-1); 
hq2 = diff(tq2)./(q1(2)-q1(1));
Dq2 = (q1(1:end-1).*hq2)-tq2(1:end-1); 
hq3 = diff(tq3)./(q1(2)-q1(1));
Dq3 = (q1(1:end-1).*hq3)-tq3(1:end-1); 

clear X1 X2 X3
X1=q1;
YMatrix1=[Hq1;Hq2;Hq3];
YMatrix2=[tq1;tq2;tq3];
X2=q1(1:end-1);
YMatrix3=[hq1;hq2;hq3];
YMatrix4=[Dq1;Dq2;Dq3];
X3=hq1;
Y1=Dq1;
X4=hq2;
Y2=Dq2;
X5=hq3;
Y3=Dq3;
clear scale1 Hq1 Hq2 Hq3 tq1 tq2 tq3 hq1 hq2 hq3 Dq1 Dq2 Dq3 segments1 Ch1 Ch2 Ch3 qRMS1 qRMS2 qRMS3 q1 qindex qzero Fq1 Fq2 Fq3 m1 sindex2 scmin scmax scres exponents RMS_scale1 RMS_scale2 RMS_scale3 fit1 fit2 fit3 C1 C2 C3 Index1

figure1 = figure('PaperType','a4letter','PaperSize',[20.98 29.68],...
    'Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1,...
    'YTickLabel',{'0.2','0.4','0.6','0.8','1','1.2','1.4','1.6','1.8'},...
    'YTick',[0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8],...
    'XTickLabel',{'-5','-4','-3','-2','-1','0','1','2','3','4','5'},...
    'XTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5],...
    'Position',[0.13 0.5747 0.3693 0.384],...
    'LineWidth',2,...
    'FontSize',12);
ylim(axes1,[0.2 1.8]);
hold(axes1,'all');

% Create multiple lines using matrix input to plot
pplot1 = plot(X1,YMatrix1,'Parent',axes1,'LineWidth',2);
set(pplot1(2),'Color',[1 0 0]);
set(pplot1(3),'Color',[0 0.749 0.749]);

% Create xlabel
xlabel('q-order','FontSize',14);

% Create ylabel
ylabel('Hq','FontSize',14);

% Create axes
axes2 = axes('Parent',figure1,...
    'XTickLabel',{'-5','-4','-3','-2','-1','0','1','2','3','4','5'},...
    'XTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5],...
    'Position',[0.1296 0.07899 0.3682 0.3834],...
    'LineWidth',2,...
    'FontSize',12);
hold(axes2,'all');

% Create multiple lines using matrix input to plot
pplot2 = plot(X1,YMatrix2,'Parent',axes2,'LineWidth',2);
set(pplot2(1),'DisplayName','Multifractal');
set(pplot2(2),'Color',[1 0 0],'DisplayName','Monofractal');
set(pplot2(3),'Color',[0 0.749 0.749],'DisplayName','White noise');

% Create xlabel
xlabel('q-order','FontSize',14);

% Create ylabel
ylabel('tq','FontSize',16);

% Create axes
axes3 = axes('Parent',figure1,...
    'YTickLabel',{'0.2','0.4','0.6','0.8','1','1.2','1.4','1.6','1.8'},...
    'YTick',[0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8],...
    'XTickLabel',{'-5','-4','-3','-2','-1','0','1','2','3','4','5'},...
    'XTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5],...
    'Position',[0.5606 0.6375 0.1745 0.279],...
    'LineWidth',2,...
    'FontSize',11);
ylim(axes3,[0.2 1.8]);
hold(axes3,'all');

% Create multiple lines using matrix input to plot
pplot3 = plot(X2,YMatrix3,'Parent',axes3,'LineWidth',2);
set(pplot3(2),'Color',[1 0 0]);
set(pplot3(3),'Color',[0 0.749 0.749]);

% Create xlabel
xlabel('q-order','FontSize',14);

% Create ylabel
ylabel('hq','FontSize',14);

% Create axes
axes4 = axes('Parent',figure1,...
    'YTickLabel',{'-0.4','-0.2','0','0.2','0.4','0.6','0.8','1'},...
    'YTick',[-0.4 -0.2 -5.551e-017 0.2 0.4 0.6 0.8 1],...
    'XTickLabel',{'-5','-4','-3','-2','-1','0','1','2','3','4','5'},...
    'XTick',[-5 -4 -3 -2 -1 0 1 2 3 4 5],...
    'Position',[0.7849 0.6375 0.1741 0.2829],...
    'LineWidth',2,...
    'FontSize',11);
ylim(axes4,[-0.4 1.01]);
hold(axes4,'all');

% Create multiple lines using matrix input to plot
pplot4 = plot(X2,YMatrix4,'Parent',axes4,'LineWidth',2);
set(pplot4(2),'Color',[1 0 0]);
set(pplot4(3),'Color',[0 0.749 0.749]);

% Create xlabel
xlabel('q-order','FontSize',14);

% Create ylabel
ylabel('Dq','FontSize',14);

% Create axes
axes5 = axes('Parent',figure1,...
    'XTickLabel',{'0.2','0.4','0.6','0.8','1','1.2','1.4','1.6','1.8'},...
    'XTick',[0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8],...
    'Position',[0.6032 0.0774 0.3091 0.4433],...
    'LineWidth',2,...
    'FontSize',12);
ylim(axes5,[-0.4 1.01]);
hold(axes5,'all');

% Create plot
plot(X3,Y1,'Parent',axes5,'LineWidth',2);

% Create plot
plot(X4,Y2,'Parent',axes5,'LineWidth',2,'Color',[1 0 0]);

% Create plot
plot(X5,Y3,'Parent',axes5,'LineWidth',2,'Color',[0 0.749 0.749]);

% Create xlabel
xlabel('hq','FontSize',14);

% Create ylabel
ylabel('Dq','FontSize',14);

% Create legend
legend1 = legend(axes2,'show');
set(legend1,'Position',[0.3691 0.8015 0.1372 0.1026],'FontSize',14);

% Create textbox
annotation(figure1,'textbox',[0.1747 0.4306 0.242 0.0621],...
    'String',{'tq computed in Matlab code 10'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.133 0.4052 0.03194 0.09076],'String',{'B'},...
    'FontSize',30,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.6108 0.4252 0.03634 0.1003],'String',{'C'},...
    'FontSize',30,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create arrow
annotation(figure1,'arrow',[0.7445 0.7445],[0.76 0.5641],'HeadLength',15,...
    'HeadWidth',15);

% Create doublearrow
annotation(figure1,'doublearrow',[0.6501 0.855],[0.1529 0.1534],...
    'Head2Length',15,...
    'Head2Width',15,...
    'Head1Length',15,...
    'Head1Width',15);

% Create textbox
annotation(figure1,'textbox',[0.676 0.1062 0.1755 0.0414],...
    'String',{'Width hq_m_a_x - hq_m_i_n'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.6739 0.195 0.1655 0.09713],...
    'String',{'Multifractal spectrum'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.1372 0.8813 0.03194 0.09076],'String',{'A'},...
    'FontSize',30,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.1747 0.8986 0.242 0.0621],...
    'String',{'Hq computed in Matlab code 9'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.5883 0.9292 0.3101 0.04459],...
    'String',{'hq and Dq computed in Matlab code 11'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create arrow
annotation(figure1,'arrow',[0.5247 0.5247],[0.7577 0.5619],'HeadLength',15,...
    'HeadWidth',15);

% Create arrow
annotation(figure1,'arrow',[0.09288 0.09215],[0.7471 0.2919],...
    'HeadLength',15,...
    'HeadWidth',15);

% Create arrow
annotation(figure1,'arrow',[0.4809 0.5482],[0.2973 0.297],'HeadLength',15,...
    'HeadWidth',15);
clear ans axes1 axes2 axes3 axes4 axes5 figure1 legend1 pplot1 pplot2 pplot3 pplot4 X1 X2 X3 X4 X5 Y1 Y2 Y3 YMatrix1 YMatrix2 YMatrix3 YMatrix4
nq=1;ns=1;v=1;