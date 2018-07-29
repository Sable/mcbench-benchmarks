
X1=cumsum(multifractal-mean(multifractal));
X1=transpose(X1);
X2=cumsum(monofractal-mean(monofractal));
X2=transpose(X2);
X3=cumsum(whitenoise-mean(whitenoise));
X3=transpose(X3);
scale1=7:2:17;
halfmax1=floor(max(scale1)/2);
Time_index1=halfmax1+1:length(X1)-halfmax1;
m1=2;
scmin=16;
scmax=1024;
scres=19;
exponents=linspace(log2(scmin),log2(scmax),scres);
scale2=round(2.^exponents);
q1=linspace(-5,5,11);
warning off;

for ns=1:length(scale2),
    segments2(ns)=floor(length(X1)/scale2(ns));
    for v=1:segments2(ns),
        Index4=((((v-1)*scale2(ns))+1):(v*scale2(ns)));
        C4=polyfit(Index4,X1(Index4),m1);
        fit4=polyval(C4,Index4);
        RMS_scale4{ns}(v)=sqrt(mean((X1(Index4)-fit4).^2));
        C5=polyfit(Index4,X2(Index4),m1);
        fit5=polyval(C5,Index4);
        RMS_scale5{ns}(v)=sqrt(mean((X2(Index4)-fit5).^2));
        C6=polyfit(Index4,X3(Index4),m1);
        fit6=polyval(C6,Index4);
        RMS_scale6{ns}(v)=sqrt(mean((X3(Index4)-fit6).^2));
    end
    
    for nq=1:length(q1),
        qRMS4{ns}=RMS_scale4{ns}.^q1(nq);
        qRMS5{ns}=RMS_scale5{ns}.^q1(nq);
        qRMS6{ns}=RMS_scale6{ns}.^q1(nq);
        Fq4(nq,ns)=mean(qRMS4{ns}).^(1/q1(nq));
        Fq5(nq,ns)=mean(qRMS5{ns}).^(1/q1(nq));
        Fq6(nq,ns)=mean(qRMS6{ns}).^(1/q1(nq));   
    end
    Fq4(q1==0,ns)=exp(0.5*mean(log(RMS_scale4{ns}.^2)));
    Fq5(q1==0,ns)=exp(0.5*mean(log(RMS_scale5{ns}.^2)));
    Fq6(q1==0,ns)=exp(0.5*mean(log(RMS_scale6{ns}.^2)));
end
for nq=1:length(q1),
    Ch4(1:2,nq) = polyfit(log2(scale2),log2(Fq4(nq,:)),1);
    Ch5(1:2,nq) = polyfit(log2(scale2),log2(Fq5(nq,:)),1);
    Ch6(1:2,nq) = polyfit(log2(scale2),log2(Fq6(nq,:)),1);
    Hq4(nq) = Ch4(1,nq);
    Hq5(nq) = Ch5(1,nq);
    Hq6(nq) = Ch6(1,nq);
end 

for ns=1:length(scale1),
    halfseg1=floor(scale1(ns)/2);
    for v=halfmax1+1:length(X1)-halfmax1;
          Index1=v-halfseg1:v+halfseg1;
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
end
Ch1(1:2)=Ch4(1:2,q1==0);
Ch2(1:2)=Ch5(1:2,q1==0);
Ch3(1:2)=Ch6(1:2,q1==0);
Regfit1=polyval(Ch1,log2(scale1));
Regfit2=polyval(Ch2,log2(scale1));
Regfit3=polyval(Ch3,log2(scale1));
maxL1=length(Time_index1);
for ns=1:length(scale1);
	RMS1(ns,:)=RMS_scale1{ns}(Time_index1);
    RMS2(ns,:)=RMS_scale2{ns}(Time_index1);
    RMS3(ns,:)=RMS_scale3{ns}(Time_index1);
	resRMS1=Regfit1(ns)-log2(RMS1(ns,:));
    resRMS2=Regfit2(ns)-log2(RMS2(ns,:));
    resRMS3=Regfit3(ns)-log2(RMS3(ns,:));
	logscale1=log2(maxL1)-log2(scale1(ns));
    Ht1(ns,:)=resRMS1./logscale1 + Hq4(q1==0);
    Ht2(ns,:)=resRMS2./logscale1 + Hq5(q1==0);
    Ht3(ns,:)=resRMS3./logscale1 + Hq6(q1==0);
end
Ht1_row=Ht1(:);
Ht2_row=Ht2(:);
Ht3_row=Ht3(:);
BinNumb1= round(sqrt(length(Ht1_row)));
BinNumb2= round(sqrt(length(Ht2_row)));
BinNumb3= round(sqrt(length(Ht3_row)));
[freq1,Htbin1]=hist(Ht1_row,BinNumb1);
[freq2,Htbin2]=hist(Ht2_row,BinNumb2);
[freq3,Htbin3]=hist(Ht3_row,BinNumb3);
Ph1=freq1./sum(freq1);
Ph2=freq2./sum(freq2);
Ph3=freq3./sum(freq3);
Ph1_norm=Ph1./max(Ph1);
Ph2_norm=Ph2./max(Ph2);
Ph3_norm=Ph3./max(Ph3);
Dh1=1-(log(Ph1_norm)./-log(mean(scale1)));
Dh2=1-(log(Ph2_norm)./-log(mean(scale1)));
Dh3=1-(log(Ph3_norm)./-log(mean(scale1)));

clear RMS_scale1 RMS_scale2 RMS_scale3 fit1 fit2 fit3 C1 C2 C3 Index1 halfseg1 m1 halfmax1 scale1 Ch1 Ch2 Ch3 F1 F2 F3 X1 X2 X3 maxL1 Ph1_norm Ph2_norm Ph3_norm freq1 freq2 freq3 BinNumb1 BinNumb2 BinNumb3 Ht1_row Ht2_row Ht3_row logscale1 resRMS1 resRMS2 resRMS3 RMS1 RMS2 RMS3 
clear segments2 Index4 C4 fit4 RMS_scale4 Index5 C5 fit5 RMS_scale5 Index6 C6 fit6 RMS_scale6 qRMS4 qRMS5 qRMS6 Fq4 Fq5 Fq6 Ch4 Ch5 Ch6 Hq4 Hq5 Hq6 q1
X1=Time_index1;
YMatrix1=[multifractal(Time_index1),monofractal(Time_index1)-5,whitenoise(Time_index1)-13];
YMatrix2=[Ht1(5,:);Ht2(5,:);Ht3(5,:)];
X2=Htbin1;
Y1=Ph1;
X3=Htbin2;
Y2=Ph2;
X4=Htbin3;
Y3=Ph3;
Y4=Dh1;
Y5=Dh2;
Y6=Dh3;
maxHt=max(Ht1(end-1,:));
minHt=min(Ht1(end-1,:));
Numb1=find(Ht1(end-1,:)==max(Ht1(end-1,:)));
Numb2=find(Ht1(end-1,:)==min(Ht1(end-1,:)));
clear Regfit1 Regfit2 Regfit3 Htbin1 Ph1 Htbin2 Ph2 Htbin3 Ph3 Dh1 Dh2 Dh3 Ht1 Ht2 Ht3 Time_index1 ns v 
clear exponents ns nq v scale2 scmin scmax scres

% Create figure
figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1,'YTick',[-10 0 10 20],'XTick',zeros(1,0),...
    'Position',[0.1283 0.7389 0.7919 0.2157],...
    'LineWidth',2,...
    'FontSize',14);
xlim(axes1,[0 2000]);
hold(axes1,'all');

% Create multiple lines using matrix input to plot
pplot1 = plot(X1,YMatrix1,'Parent',axes1);
set(pplot1(1),'Color',[0 0 1]);
set(pplot1(2),'Color',[1 0 0]);
set(pplot1(3),'Color',[0 0.749 0.749]);

% Create ylabel
ylabel('Amplitude','FontSize',14);

% Create axes
axes2 = axes('Parent',figure1,'YTickLabel',{'0.5','1','1.5'},...
    'YTick',[0.5 1 1.5],...
    'Position',[0.1283 0.4684 0.7919 0.2727],...
    'LineWidth',2,...
    'FontSize',14);
xlim(axes2,[0 2000]);
ylim(axes2,[0.4 2]);
hold(axes2,'all');

% Create multiple lines using matrix input to plot
pplot2 = plot(X1,YMatrix2,'Parent',axes2,'LineWidth',2);
set(pplot2(1),'Color',[0 0 1],'DisplayName','Multifractal');
set(pplot2(2),'Color',[1 0 0],'DisplayName','Monofractal');
set(pplot2(3),'Color',[0 0.749 0.749],'DisplayName','White noise');

% Create plot
plot(Numb1,maxHt,'Parent',axes2,'MarkerEdgeColor',[1 0 0],'Marker','o',...
    'LineWidth',2,...
    'LineStyle','none',...
    'Color',[1 0 0]);

% Create plot
plot(Numb2,minHt,'Parent',axes2,'MarkerEdgeColor',[1 0 0],'Marker','o',...
    'LineWidth',2,...
    'LineStyle','none',...
    'Color',[1 0 0]);

% Create xlabel
xlabel('time (sample number)','FontSize',14);

% Create ylabel
ylabel('Ht','FontSize',16);

% Create axes
axes3 = axes('Parent',figure1,...
    'XTickLabel',{'0.4','0.6','0.8','1','1.2','1.4','1.6'},...
    'XTick',[0.4 0.6 0.8 1 1.2 1.4 1.6],...
    'YTickLabel',{'0.005','0.010','0.015','0.020','0.025'},...
    'YTick',[0.005 0.01 0.015 0.02 0.025],...
    'Position',[0.13 0.06595 0.3648 0.3069],...
    'LineWidth',2,...
    'FontSize',14);
xlim(axes3,[0.3 1.6]);
ylim(axes3,[0 0.025]);
hold(axes3,'all');

% Create plot
plot(X2,Y1,'Parent',axes3,'LineWidth',2);

% Create plot
plot(X3,Y2,'Parent',axes3,'LineWidth',2,'Color',[1 0 0]);

% Create plot
plot(X4,Y3,'Parent',axes3,'LineWidth',2,'Color',[0 0.749 0.749]);

% Create xlabel
xlabel('Htbin in Matlab code 14','FontSize',14);

% Create ylabel
ylabel('Ph in Matlab code 14','FontSize',14);

% Create axes
axes4 = axes('Parent',figure1,...
    'YTickLabel',{'-2','-1.5','-1','-0.5','0','0.5','1'},...
    'YTick',[-2 -1.5 -1 -0.5 0 0.5 1],...
    'XTickLabel',{'0.4','0.6','0.8','1','1.2','1.4','1.6'},...
    'XTick',[0.4 0.6 0.8 1 1.2 1.4 1.6],...
    'Position',[0.5591 0.06595 0.3646 0.3069],...
    'LineWidth',2,...
    'FontSize',14);
xlim(axes4,[0.3 1.6]);
hold(axes4,'all');

% Create plot
plot(X2,Y4,'Parent',axes4,'LineWidth',2);

% Create plot
plot(X3,Y5,'Parent',axes4,'LineWidth',2,'Color',[1 0 0]);

% Create plot
plot(X4,Y6,'Parent',axes4,'LineWidth',2,'Color',[0 0.749 0.749]);

% Create xlabel
xlabel('Htbin in Matlab code 14','FontSize',14);

% Create ylabel
ylabel('Dh in Matlab code 14','FontSize',14);

% Create legend
legend1 = legend(axes2,'Multifractal','Monofractal','White noise');
set(legend1,'Position',[0.3041 0.2788 0.1372 0.1059]);

% Create textbox
annotation(figure1,'textbox',[0.4663 0.3217 0.03459 0.07268],'String',{'C'},...
    'FontSize',30,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.02968 0.3124 0.03285 0.0821],'String',{'B'},...
    'FontSize',30,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.02704 0.8991 0.03285 0.0821],'String',{'A'},...
    'FontSize',30,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create line
annotation(figure1,'line',[0.5426 0.5426],[0.9533 0.4661],'LineStyle','--',...
    'LineWidth',2);

% Create line
annotation(figure1,'line',[0.5652 0.5652],[0.9534 0.4662],'LineStyle','--',...
    'LineWidth',2);

% Create line
annotation(figure1,'line',[0.5946 0.5946],[0.9542 0.467],'LineStyle','--',...
    'LineWidth',2,...
    'Color',[1 0 0]);

% Create line
annotation(figure1,'line',[0.6198 0.6198],[0.9531 0.4659],'LineStyle','--',...
    'LineWidth',2,...
    'Color',[1 0 0]);

% Create textbox
annotation(figure1,'textbox',[0.1599 0.6939 0.3471 0.04787],...
    'String',{'Ht computed in Matlab code 13 for scale = 15'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.6616 0.7105 0.2264 0.04571],...
    'String',{'Period with small variation'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.6616 0.6614 0.2264 0.04571],...
    'String',{'Period with large variation'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.1599 0.9017 0.1726 0.05258],...
    'String',{'Fractal time series'},...
    'FontSize',16,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create arrow
annotation(figure1,'arrow',[0.6615 0.6215],[0.6864 0.6856],'HeadLength',15,...
    'HeadWidth',15);

% Create arrow
annotation(figure1,'arrow',[0.6589 0.5686],[0.7349 0.7341],'HeadLength',15,...
    'HeadWidth',15);

% Create textarrow
annotation(figure1,'textarrow',[0.635431918008785 0.604685212298683],...
    [0.431528662420382 0.461783439490446],'TextEdgeColor','none',...
    'TextLineWidth',2,...
    'FontSize',14,...
    'String',{'Ht_m_i_n'},...
    'LineWidth',2);

% Create textarrow
annotation(figure1,'textarrow',[0.513909224011713 0.546852122986823],...
    [0.655050955414013 0.656050955414013],'TextEdgeColor','none',...
    'TextLineWidth',2,...
    'FontSize',14,...
    'String',{'Ht_m_a_x'},...
    'LineWidth',2);

clear figure1 legend1 axes1 axes2 axes3 axes4 ans pplot1 pplot2 X1 X2 X3 X4 Y1 Y2 Y3 Y4 Y5 Y6 YMatrix1 YMatrix2
ns=1;v=1;