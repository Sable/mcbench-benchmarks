
X1=cumsum(multifractal-mean(multifractal));
X2=cumsum(monofractal-mean(monofractal));
X1=transpose(X1);
X2=transpose(X2);
scale1=16;
q1 =[-3,-1,1,3];
m1=1;
Y1=multifractal;
timeind1=1:2000;
monofractal1=monofractal(1:2000)-5;

segments1=floor(length(X1)/scale1);
for v=1:segments1,
    Index1=((((v-1)*scale1)+1):(v*scale1));
	C1=polyfit(Index1,X1(Index1),m1);
	fit1=polyval(C1,Index1);
	RMS_scale1(Index1)=sqrt(mean((X1(Index1)-fit1).^2));
    
	C2=polyfit(Index1,X2(Index1),m1);
	fit2=polyval(C2,Index1);
	RMS_scale2(Index1)=sqrt(mean((X2(Index1)-fit2).^2));
end
for nq=1:length(q1),
    qRMS1{nq}=RMS_scale1(1:2000).^q1(nq);
    qRMS2{nq}=RMS_scale2(1:2000).^q1(nq);
end

Y2=qRMS1{1};
qRMS1a1=qRMS2{1};
Y3=qRMS1{2};
qRMS2a1=qRMS2{2};
Y4=qRMS1{3};
qRMS3a1=qRMS2{3};
Y5=qRMS1{4};
qRMS4a1=qRMS2{4};

% Create figure
figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1,'XTickLabel',{'','','','','','','','','',''},...
    'XTick',[200 400 600 800 1000 1200 1400 1600 1800 2000],...
    'Position',[0.1309 0.7914 0.775 0.1682],...
    'LineWidth',2,...
    'FontSize',14);
xlim(axes1,[0 2000]);
ylim(axes1,[-9 20]);
hold(axes1,'all');

% Create plot
plot(Y1,'Parent',axes1);

% Create plot
plot(timeind1,monofractal1,'Parent',axes1,'DisplayName','monofractal1');

% Create axes
axes2 = axes('Parent',figure1,'YTickLabel',{'0','200000','400000'},...
    'XTick',zeros(1,0),...
    'Position',[0.13 0.5896 0.775 0.1756],...
    'LineWidth',2,...
    'FontSize',14);
xlim(axes2,[0 2000]);
ylim(axes2,[-1e+004 5e+005]);
hold(axes2,'all');

% Create plot
plot(Y2,'Parent',axes2,'LineWidth',2,'DisplayName','Multifractal');

% Create plot
plot(timeind1,qRMS1a1,'Parent',axes2,'LineWidth',2,...
    'DisplayName','Monofractal');

% Create axes
axes3 = axes('Parent',figure1,'YTick',[0 20 40],'XTick',zeros(1,0),...
    'Position',[0.13 0.4189 0.775 0.172],...
    'LineWidth',2,...
    'FontSize',14);
xlim(axes3,[0 2000]);
ylim(axes3,[-2 80]);
hold(axes3,'all');

% Create plot
plot(Y3,'Parent',axes3,'LineWidth',2);

% Create plot
plot(timeind1,qRMS2a1,'Parent',axes3,'LineWidth',2,'DisplayName','qRMS2a');

% Create axes
axes4 = axes('Parent',figure1,'YTick',[0 5 10],'XTick',zeros(1,0),...
    'Position',[0.13 0.2472 0.775 0.1713],...
    'LineWidth',2,...
    'FontSize',14);
xlim(axes4,[0 2000]);
ylim(axes4,[-0.5 15]);
hold(axes4,'all');

% Create plot
plot(Y4,'Parent',axes4,'LineWidth',2);

% Create ylabel
ylabel('qRMS (measurment units)','FontSize',14);

% Create plot
plot(timeind1,qRMS3a1,'Parent',axes4,'LineWidth',2,'DisplayName','qRMS3a');

% Create axes
axes5 = axes('Parent',figure1,'YTick',[0 1000],...
    'Position',[0.13 0.07683 0.775 0.172],...
    'LineWidth',2,...
    'FontSize',14);
xlim(axes5,[0 2000]);
ylim(axes5,[-50 2000]);
hold(axes5,'all');

% Create plot
plot(Y5,'Parent',axes5,'LineWidth',2);

% Create xlabel
xlabel('time (sample number)','FontSize',14);

% Create plot
plot(timeind1,qRMS4a1,'Parent',axes5,'LineWidth',2,'DisplayName','qRMS4a');

% Create legend
legend1 = legend(axes2,'show');
set(legend1,'Position',[0.736 0.6808 0.1354 0.07268]);

% Create arrow
annotation(figure1,'arrow',[0.4748 0.5265],[0.6541 0.6533],'HeadLength',15,...
    'HeadWidth',15,...
    'LineWidth',2);

% Create textbox
annotation(figure1,'textbox',[0.274 0.6206 0.2052 0.05732],...
    'String',{'Period with small variation'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create arrow
annotation(figure1,'arrow',[0.6805 0.6212],[0.1756 0.175],'HeadLength',15,...
    'HeadWidth',15,...
    'LineWidth',2);

% Create textbox
annotation(figure1,'textbox',[0.6808 0.1423 0.2029 0.05732],...
    'String',{'Period with large variation'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create line
annotation(figure1,'line',[0.5588 0.5588],[0.9228 0.07569],'LineStyle','--',...
    'LineWidth',2);

% Create line
annotation(figure1,'line',[0.5869 0.5869],[0.923 0.0759],'LineStyle','--',...
    'LineWidth',2,...
    'Color',[1 0 0]);

% Create line
annotation(figure1,'line',[0.6134 0.6134],[0.9237 0.0766],'LineStyle','--',...
    'LineWidth',2,...
    'Color',[1 0 0]);

% Create line
annotation(figure1,'line',[0.5356 0.5359],[0.9219 0.07793],'LineStyle','--',...
    'LineWidth',2);

% Create textbox
annotation(figure1,'textbox',[0.1425 0.7227 0.3158 0.05384],...
    'String',{'qRMS in Matlab code 7 for scale = 16'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create line
annotation(figure1,'line',[0.1302 0.1302],[0.7675 0.7349],'LineWidth',3,...
    'Color',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',[0.1558 0.6379 0.06489 0.07484],...
    'String',{'q = -3'},...
    'FontSize',16,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.1554 0.4786 0.06489 0.07484],...
    'String',{'q = -1'},...
    'FontSize',16,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.1555 0.1458 0.06489 0.07484],...
    'String',{'q = 3'},...
    'FontSize',16,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.1451 0.8762 0.1726 0.06057],...
    'String',{'Fractal time series'},...
    'FontSize',16,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.1558 0.3115 0.06489 0.07484],...
    'String',{'q = 1'},...
    'FontSize',16,...
    'FitBoxToText','off',...
    'LineStyle','none');
clear X1 X2 Y1 Y2 Y3 Y4 Y5 qRMS1 qRMS2 qRMS1a1 qRMS2a1 qRMS3a1 qRMS4a1 ans monofractal1 RMS_scale1 RMS_scale2 fit1 fit2 C1 C2 Index1 timeind1 segments1 scale1 q1 m1 figure1 axes1 axes2 axes3 axes4 axes5 legend1
nq=1;ns=1;v=1;