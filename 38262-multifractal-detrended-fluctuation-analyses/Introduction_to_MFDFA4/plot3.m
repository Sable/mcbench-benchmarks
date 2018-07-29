
X=cumsum(multifractal-mean(multifractal));
X=transpose(X);
scale=1000;
m=1;
segments=floor(length(X)/scale);

figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1]);
axes1 = axes('Parent',figure1,'YTick',[0 200 400 600],'XTick',zeros(1,0),...
    'Position',[0.13 0.6454 0.775 0.2796],...
    'LineWidth',2,...
    'FontSize',14);
ylim(axes1,[-250 600]);
hold(axes1,'all');

plot(X,'Parent',axes1,'LineWidth',2,...
    'DisplayName','Noise like time series converted to a random walk');
for v=1:segments
	Index1=((((v-1)*scale)+1):(v*scale));
	C=polyfit(Index1,X(Index1),m);
	fit1{v}=polyval(C,Index1);
	RMS_scale1(v)=sqrt(mean((X(Index1)-fit1{v}).^2));
    if v==1,
       YMatrix=[fit1{v};fit1{v}+RMS_scale1(v);fit1{v}-RMS_scale1(v)];
       pplot1 = plot(Index1,YMatrix,'Parent',axes1,'Color',[1 0 0]);
       set(pplot1(1),'LineStyle','--',...
        'DisplayName','Local trend: fit in Matlab code 3');
       set(pplot1(2),'DisplayName','+/- 1 local RMS: RMS-scale in Matlab code 3'); 
       set(pplot1(3),'LineStyle','-');
    else
       YMatrix=[fit1{v};fit1{v}+RMS_scale1(v);fit1{v}-RMS_scale1(v)];
       pplot1 = plot(Index1,YMatrix,'Parent',axes1,'Color',[1 0 0]);
       set(pplot1(1),'LineStyle','--');
       set(pplot1(2),'LineStyle','-'); 
       set(pplot1(3),'LineStyle','-');
    end
end
m=2;
warning off
axes2 = axes('Parent',figure1,'YTick',[0 200 400 600],'XTick',zeros(1,0),...
    'Position',[0.13 0.369 0.775 0.2786],...
    'LineWidth',2,...
    'FontSize',14);
ylim(axes2,[-250 600]);
hold(axes2,'all');
plot(X,'Parent',axes2,'LineWidth',2);
for v=1:segments
	Index2=((((v-1)*scale)+1):(v*scale));
	C=polyfit(Index2,X(Index2),m);
	fit2{v}=polyval(C,Index2);
	RMS_scale2(v)=sqrt(mean((X(Index2)-fit2{v}).^2));
    
    YMatrix2=[fit2{v};fit2{v}+RMS_scale2(v);fit2{v}-RMS_scale2(v)];
    pplot2 = plot(Index2,YMatrix2,'Parent',axes2,'Color',[1 0 0]);
    set(pplot2(1),'LineStyle','--');
    set(pplot2(2),'LineStyle','-'); 
    set(pplot2(3),'LineStyle','-');
end
m=3;
warning off
axes3 = axes('Parent',figure1,'Position',[0.13 0.09131 0.775 0.2788],...
    'LineWidth',2,...
    'FontSize',14);
ylim(axes3,[-250 600]);
hold(axes3,'all');
plot(X,'Parent',axes3,'LineWidth',2);
for v=1:segments
	Index3=((((v-1)*scale)+1):(v*scale));
	C=polyfit(Index3,X(Index3),m);
	fit3{v}=polyval(C,Index3);
	RMS_scale3(v)=sqrt(mean((X(Index3)-fit3{v}).^2));
    
    YMatrix3=[fit3{v};fit3{v}+RMS_scale3(v);fit3{v}-RMS_scale3(v)];
    pplot3 = plot(Index3,YMatrix3,'Parent',axes3,'Color',[1 0 0]);
    set(pplot3(1),'LineStyle','--');
    set(pplot3(2),'LineStyle','-'); 
    set(pplot3(3),'LineStyle','-');
end

% Create xlabel
xlabel('time (sample number)','FontSize',14);

% Create ylabel
ylabel('Amplitude (measurement units)','FontSize',14);

% Create legend
legend1 = legend(axes1,'Noise like time series converted to a random walk','Local trend (fit) in Matlab code 3','+/- 1 local RMS in Matlab code 3');
set(legend1,'Position',[0.5259 0.5709 0.4106 0.1059]);

% Create textbox
annotation(figure1,'textbox',[0.1677 0.3019 0.2151 0.04307],...
    'String',{'Cubic detrending (m=3)'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.1711 0.9017 0.1995 0.04307],...
    'String',{'Linear detrending (m=1)'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');

% Create textbox
annotation(figure1,'textbox',[0.1694 0.5816 0.2151 0.04307],...
    'String',{'Quadratic detrending (m=2)'},...
    'FontSize',14,...
    'FitBoxToText','off',...
    'LineStyle','none');
m=1;
clear C Index1 Index2 Index3 fit1 fit2 fit3 RMS_scale1 RMS_scale2 RMS_scale3 ans figure1 legend1 YMatrix YMatrix2 YMatrix3 pplot1 pplot2 pplot3 axes1 axes2 axes3  