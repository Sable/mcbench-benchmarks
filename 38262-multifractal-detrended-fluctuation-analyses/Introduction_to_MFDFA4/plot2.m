RMS1=RMS_multifractal;
RMS2=RMS_monofractal;
RMS3=RMS_ordinary;
YMatrix1=[multifractal,mean(multifractal).*ones(size(multifractal)),(mean(multifractal)+RMS1).*ones(size(multifractal)),(mean(multifractal)-RMS1).*ones(size(multifractal))];
YMatrix2=[monofractal,mean(monofractal).*ones(size(monofractal)),(mean(monofractal)+RMS2).*ones(size(monofractal)),(mean(monofractal)-RMS2).*ones(size(monofractal))];
YMatrix3=[whitenoise,mean(whitenoise).*ones(size(whitenoise)),(mean(whitenoise)+RMS3).*ones(size(whitenoise)),(mean(whitenoise)-RMS3).*ones(size(whitenoise))];

% Create figure
figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1]);

% Create axes
axes1 = axes('Parent',figure1,'XTick',zeros(1,0),...
    'Position',[0.13 0.6555 0.775 0.2695],...
    'LineWidth',2,...
    'FontSize',14);
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[-7 20]);
hold(axes1,'all');

% Create multiple lines using matrix input to plot
pplot1 = plot(YMatrix1,'Parent',axes1,'Color',[1 0 0],'LineWidth',2);
set(pplot1(1),'Color',[0 0 1],'DisplayName','Noise like time series',...
    'LineWidth',0.5);
set(pplot1(2),'LineStyle','--','DisplayName','Mean');
set(pplot1(3),'DisplayName','+/- 1 RMS');

% Create axes
axes2 = axes('Parent',figure1,'YTick',[-4 -2 0 2 4],'XTick',zeros(1,0),...
    'Position',[0.13 0.3876 0.775 0.2687],...
    'LineWidth',2,...
    'FontSize',14);
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes2,[-6 6]);
hold(axes2,'all');

% Create multiple lines using matrix input to plot
pplot2 = plot(YMatrix2,'Parent',axes2,'Color',[1 0 0],'LineWidth',2);
set(pplot2(1),'Color',[0 0 1],'LineWidth',0.5);
set(pplot2(2),'LineStyle','--');

% Create axes
axes3 = axes('Parent',figure1,'YTick',[-4 -2 0 2 4],...
    'Position',[0.13 0.1198 0.775 0.2692],...
    'LineWidth',2,...
    'FontSize',14);
% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes3,[-6 6]);
hold(axes3,'all');

% Create multiple lines using matrix input to plot
pplot3 = plot(YMatrix3,'Parent',axes3,'Color',[1 0 0],'LineWidth',2);
set(pplot3(1),'Color',[0 0 1],'LineWidth',0.5);
set(pplot3(2),'LineStyle','--');

% Create xlabel
xlabel('Time (sample number)','FontSize',14);

% Create ylabel
ylabel('Amplitude (measurement units)','FontSize',14);

% Create legend
legend1 = legend(axes1,'Noise like time series','Mean','+/- 1 RMS');
set(legend1,'Position',[0.6322 0.8219 0.2066 0.1059]);

% Create textbox
annotation(figure1,'textbox',[0.264 0.8856 0.1917 0.05384],...
    'String',{'Multifractal time series'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.2684 0.3234 0.1917 0.05384],...
    'String',{'White noise'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.2641 0.5937 0.1917 0.05384],...
    'String',{'Monofractal time series'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

clear pplot1 pplot2 pplot3 legend1 axes1 figure1 axes2 figure2 axes3 figure3 ans YMatrix1 YMatrix2 YMatrix3 RMS1 RMS2 RMS3