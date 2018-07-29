
scale1=[16,32,64,128,256,512,1024];
X1=cumsum(multifractal-mean(multifractal));
for ns=1:length(scale1),
    segments1(ns)=floor(length(X1)/scale1(ns));
    for v=1:segments1(ns),
        Index1=((((v-1)*scale1(ns))+1):(v*scale1(ns)));
        RMS_scale2{ns}(Index1)=RMS{ns}(v).*ones(size(Index1));
    end
end
clear X1 Index1 scale1 segments1
X1=1:length(RMS_scale2{7});
X2=1:8000;
X3=1:length(RMS_scale2{6});
X4=1:length(RMS_scale2{5});
Y1=RMS_scale2{7};
Y2=F(7).*ones(8000,1);
Y3=RMS_scale2{6};
Y4=F(6).*ones(8000,1);
Y5=RMS_scale2{5};
Y6=F(5).*ones(8000,1);
Y7=RMS_scale2{4};
Y8=F(4).*ones(8000,1);
YMatrix1=[RMS_scale2{3};F(3).*ones(1,8000)];
YMatrix2=[RMS_scale2{2};F(2).*ones(1,8000)];
YMatrix3=[RMS_scale2{1};F(1).*ones(1,8000)];
clear RMS_scale2

% Create figure
figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1,'YTick',[0 20],'XTick',zeros(1,0),...
    'Position',[0.09852 0.8515 0.775 0.1274],...
    'LineWidth',2,...
    'FontSize',14);
ylim(axes1,[0 45]);
hold(axes1,'all');

% Create plot
plot(X1,Y1,'Parent',axes1,'LineWidth',2,'Color',[0 0 1],...
    'DisplayName','Local fluctuation: RMS in Matlab code 5');

% Create plot
plot(X2,Y2,'Parent',axes1,'LineWidth',2,'Color',[1 0 0],...
    'DisplayName','RMS of local fluctuation: F in Matlab code 5');

% Create axes
axes2 = axes('Parent',figure1,'YTick',[0 20],'XTick',zeros(1,0),...
    'Position',[0.09852 0.7242 0.775 0.1272],...
    'LineWidth',2,...
    'FontSize',14);
ylim(axes2,[0 45]);
hold(axes2,'all');

% Create plot
plot(X3,Y3,'Parent',axes2,'LineWidth',2,'Color',[0 0 1]);

% Create plot
plot(X2,Y4,'Parent',axes2,'LineWidth',2,'Color',[1 0 0]);

% Create axes
axes3 = axes('Parent',figure1,'YTick',[0 20],'XTick',zeros(1,0),...
    'Position',[0.09852 0.5968 0.775 0.1271],...
    'LineWidth',2,...
    'FontSize',14);
ylim(axes3,[0 44]);
hold(axes3,'all');

% Create plot
plot(X4,Y5,'Parent',axes3,'LineWidth',2,'Color',[0 0 1]);

% Create plot
plot(X2,Y6,'Parent',axes3,'LineWidth',2,'Color',[1 0 0]);

% Create axes
axes4 = axes('Parent',figure1,'YTick',[0 20],'XTick',zeros(1,0),...
    'Position',[0.09852 0.4694 0.775 0.127],...
    'LineWidth',2,...
    'FontSize',14);
ylim(axes4,[0 40]);
hold(axes4,'all');

% Create plot
plot(X4,Y7,'Parent',axes4,'LineWidth',2,'Color',[0 0 1]);

% Create plot
plot(X2,Y8,'Parent',axes4,'LineWidth',2,'Color',[1 0 0]);

% Create ylabel
ylabel('RMS in Matlab code 5 (measurement units)','FontSize',14);

% Create axes
axes5 = axes('Parent',figure1,'YTick',[0 10],'XTick',zeros(1,0),...
    'Position',[0.09852 0.3435 0.775 0.1269],...
    'LineWidth',2,...
    'FontSize',14);
ylim(axes5,[-0.5 30]);
hold(axes5,'all');

% Create multiple lines using matrix input to plot
pplot1 = plot(X2,YMatrix1,'Parent',axes5,'LineWidth',2);
set(pplot1(1),'Color',[0 0 1]);
set(pplot1(2),'Color',[1 0 0]);

% Create axes
axes6 = axes('Parent',figure1,'YTick',[0 10],'XTick',zeros(1,0),...
    'Position',[0.09852 0.2162 0.775 0.1267],...
    'LineWidth',2,...
    'FontSize',14);
xlim(axes6,[0 8000]);
ylim(axes6,[-0.5 20]);
hold(axes6,'all');

% Create multiple lines using matrix input to plot
pplot2 = plot(X2,YMatrix2,'Parent',axes6,'LineWidth',2);
set(pplot2(1),'Color',[0 0 1]);
set(pplot2(2),'Color',[1 0 0]);

% Create axes
axes7 = axes('Parent',figure1,'YTick',[0 5],...
    'Position',[0.09852 0.09048 0.775 0.1266],...
    'LineWidth',2,...
    'FontSize',14);
ylim(axes7,[0 15]);
hold(axes7,'all');

% Create multiple lines using matrix input to plot
pplot3 = plot(X2,YMatrix3,'Parent',axes7,'LineWidth',2);
set(pplot3(1),'Color',[0 0 1]);
set(pplot3(2),'Color',[1 0 0]);

% Create xlabel
xlabel('time (sample number)','FontSize',14);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Position',[0.5252 0.8089 0.3681 0.07268],'LineWidth',2);

% Create textbox
annotation(figure1,'textbox',[0.8714 0.3324 0.0981 0.05573],...
    'String',{'Scale = 64'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.8711 0.08541 0.0981 0.05573],...
    'String',{'Scale = 16'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.8716 0.2025 0.0981 0.05573],...
    'String',{'Scale = 32'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.8711 0.4607 0.102 0.05573],...
    'String',{'Scale = 128'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.8716 0.6065 0.1049 0.05573],...
    'String',{'Scale = 256'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.8721 0.7507 0.1036 0.05573],...
    'String',{'Scale = 512'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.8719 0.8997 0.1125 0.05573],...
    'String',{'Scale = 1024'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');
clear ans pplot1 pplot2 pplot3 axes1 axes2 axes3 axes4 axes5 axes6 axes7 legend1 figure1 X1 X2 X3 X4 Y1 Y2 Y3 Y4 Y5 Y6 Y7 Y8 YMatrix1 YMatrix2 YMatrix3
v=1;ns=1;