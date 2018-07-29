
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
sindex2=[1,4,7,10,13,16,19];

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
    F1(ns)=sqrt(mean(RMS_scale1{ns}.^2));
    F2(ns)=sqrt(mean(RMS_scale2{ns}.^2));
    F3(ns)=sqrt(mean(RMS_scale3{ns}.^2));
end
Ch1 = polyfit(log2(scale1),log2(F1),1);
H1 = Ch1(1);
RegLine1 = polyval(Ch1,log2(scale1));

Ch2 = polyfit(log2(scale1),log2(F2),1);
H2 = Ch2(1);
RegLine2 = polyval(Ch2,log2(scale1));

Ch3 = polyfit(log2(scale1),log2(F3),1);
H3 = Ch3(1);
RegLine3 = polyval(Ch3,log2(scale1));

YMatrix1=[log2(F2);log2(F3);log2(F1);RegLine1;RegLine2;RegLine3];
clear segments1 RegLine1 RegLine2 RegLine3 H1 H2 H3 Ch1 Ch2 Ch3 F1 F2 F3 m1 sindex2 scmin scmax scres exponents X1 X2 X3 RMS_scale1 RMS_scale2 RMS_scale3 fit1 fit2 fit3 C1 C2 C3 Index1
X1=log2(scale1);
clear scale1


% Create figure
figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1,'YTickLabel',{'1','2','4','8','16','32'},...
    'YTick',[0 1 2 3 4 5],...
    'XTickLabel',{'16','32','64','128','256','512','1024'},...
    'LineWidth',2,...
    'FontSize',14);
ylim(axes1,[0 5]);
hold(axes1,'all');

% Create multiple lines using matrix input to plot
pplot1 = plot(X1,YMatrix1,'Parent',axes1,'LineWidth',2);
set(pplot1(1),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',8,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[1 0 0],...
    'DisplayName','Monofractal time series');
set(pplot1(2),'MarkerFaceColor',[0 0.749 0.749],'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',8,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[0 0.749 0.749],...
    'DisplayName','White noise');
set(pplot1(3),'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',8,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[0 0 1],...
    'DisplayName','Multifractal time series');
set(pplot1(4),'Color',[0 0 1],'DisplayName','Slope H = 0.77');
set(pplot1(5),'Color',[1 0 0],'DisplayName','Slope H = 0.72');
set(pplot1(6),'Color',[0 0.749 0.749],'DisplayName','Slope H = 0.45');

% Create xlabel
xlabel('Scale (segment sample size)','FontSize',14);

% Create ylabel
ylabel('F in Matlab code 5 (measurement units)','FontSize',14);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Position',[0.1887 0.6536 0.2205 0.2055]);

% Create line
annotation(figure1,'line',[0.2584 0.2592],[0.1089 0.2898],'LineStyle',':',...
    'LineWidth',2);

% Create line
annotation(figure1,'line',[0.388 0.388],[0.1073 0.4331],'LineStyle',':',...
    'LineWidth',2);

% Create line
annotation(figure1,'line',[0.5176 0.5176],[0.1089 0.5589],'LineStyle',':',...
    'LineWidth',2);

% Create line
annotation(figure1,'line',[0.6464 0.6464],[0.1073 0.7102],'LineStyle',':',...
    'LineWidth',2);

% Create line
annotation(figure1,'line',[0.7753 0.7753],[0.1073 0.7946],'LineStyle',':',...
    'LineWidth',2);

% Create line
annotation(figure1,'line',[0.9048 0.9048],[0.1105 0.879],'LineStyle',':',...
    'LineWidth',2);

% Create line
annotation(figure1,'line',[0.4414 0.5886],[0.4719 0.4729],'LineStyle','--',...
    'LineWidth',2,...
    'Color',[0 0 1]);

% Create line
annotation(figure1,'line',[0.5886 0.5886],[0.4745 0.6146],'LineStyle','--',...
    'LineWidth',2,...
    'Color',[0 0 1]);

% Create textbox
annotation(figure1,'textbox',[0.5922 0.492 0.1574 0.05414],...
    'String',{'Hurst exponent (H)'},...
    'FontSize',16,...
    'FitBoxToText','off',...
    'LineStyle','none',...
    'BackgroundColor',[1 1 1]);

clear pplot1 legend1 axes1 figure1 ans X1 YMatrix1
v=1;ns=1;