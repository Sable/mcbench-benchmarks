function [Ht,Htbin,Ph,Dh] = MFDFA2(signal,scale,m,Fig)
% Multifractal detrended fluctuation analysis (MFDFA). This Matlab function
% estimate the multifractal spectrum Dh directly without q-order statistics.
%
% [Ht,Htbin,Ph,Dh] = MFDFA2(signal,scale,m,Fig);
%
% INPUT PARAMETERS---------------------------------------------------------
%
% signal:       input signal
% scale:        vector of scales 
% m:            polynomial order for the detrending
% Fig:          1/0 flag for output plot of F0, Ht, Ph, and Dh.
%
% OUTPUT VARIABLES---------------------------------------------------------
%
% Ht:           Time evolution of the local Hurst exponent
% Htbin:        Bin senters for the histogram based estimation of Ph and Dh 
% Ph:           Probability distribution of the local Hurst exponent Ht
% Dh:           Multifractal spectrum 
%
% EXAMPLE------------------------------------------------------------------
%
% load fractaldata
% scale=[7,9,11,13,15,17];
% m=2;
% signal1=multifractal;
% signal2=monofractal;
% signal3=whitenoise;
% [Ht1,Htbin1,Ph1,Dh1] = MFDFA2(signal1,scale,m,1);
% [Ht2,Htbin2,Ph2,Dh2] = MFDFA2(signal2,scale,m,1);
% [Ht3,Htbin3,Ph3,Dh3] = MFDFA2(signal3,scale,m,1);
%--------------------------------------------------------------------------
warning off
X=cumsum(signal-mean(signal));
if min(size(X))~=1||min(size(scale))~=1;
    error('Input arguments signal or scale must be a 1D vector');
end
if size(X,2)==1;
   X=transpose(X);
end
if min(scale)<m+1
   error('The minimum scale must be larger than trend order m+1')
end
disp('--please wait for the results--');

scmin=10;
scmax=length(signal)/10;
scres=20;
exponents=linspace(log2(scmin),log2(scmax),scres);
scale0=round(2.^exponents);

for ns=1:length(scale0),
    segments(ns)=floor(length(X)/scale0(ns));
    for v=1:segments(ns),
		Index0=((((v-1)*scale0(ns))+1):(v*scale0(ns)));
		C0=polyfit(Index0,X(Index0),m);
		fit0=polyval(C0,Index0);
		RMS0{ns}(v)=sqrt(mean((X(Index0)-fit0).^2));
    end
    Fq0(ns)=exp(0.5*mean(log(RMS0{ns}.^2)));
end

halfmax=floor(max(scale)/2);
Time_index=halfmax+1:length(X)-halfmax;
for ns=1:length(scale),
    halfseg=floor(scale(ns)/2);
    for v=halfmax+1:length(X)-halfmax;
        Index=v-halfseg:v+halfseg;
        C=polyfit(Index,X(Index),m);
        fit=polyval(C,Index);
        RMS{ns}(v)=sqrt(mean((X(Index)-fit).^2));
    end
    F(ns)=exp(0.5*mean(log(RMS{ns}.^2)));
end
C = polyfit(log2(scale0),log2(Fq0),1);
Regfit = polyval(C,log2(scale));
Hq0=C(1);
maxL=length(Time_index);
for ns=1:length(scale);
	RMSt=RMS{ns}(Time_index);
	resRMS=Regfit(ns)-log2(RMSt);
	logscale=log2(maxL)-log2(scale(ns));
    Ht(ns,:)=resRMS./logscale + Hq0;
end
Ht_row=Ht(:);
BinNumb= round(sqrt(length(Ht_row)));
[freq,Htbin]=hist(Ht_row,BinNumb);
Ph=freq./sum(freq);
Ph_norm=Ph./max(Ph);
Dh=1-(log(Ph_norm)./log(mean(diff(Htbin))));

%OUTPUT FIGURE-------------------------------------------------------------
if Fig==1
   for ns=1:length(scale);
       RMSt1(ns,:)=RMS{ns}(Time_index);
   end 
   Ht_mode=mean(Htbin(Ph==max(Ph)));
   numb1=find(Ht(1,:)==max(Ht(1,:)));
   numb2=find(Ht(end,:)==max(Ht(end,:)));
   numb3=find(Ht(1,:)==min(Ht(1,:)));
   numb4=find(Ht(end,:)==min(Ht(end,:)));
   
   %Figure variables---------------------
    X1=Time_index;
    Y1=signal(Time_index);
    X2=Time_index(numb1);
    Y2=signal(numb1);
    X3=Time_index(numb3);
    Y3=signal(numb3);
    X4=Time_index(numb2);
    Y4=signal(numb2);
    X5=Time_index(numb4);
    Y5=signal(numb4);
    YMatrix2=[Ht(1,:);Ht_mode.*ones(size(Time_index))];
    YMatrix3=[Ht(end,:);Ht_mode.*ones(size(Time_index))];
    YMatrix4=[log2(RMSt1(1,numb1)),log2(RMSt1(1,numb3))];
    YMatrix5=[log2(RMSt1(end,numb2)),log2(RMSt1(end,numb4))];
    YMatrix6=[log2(RMSt1(:,1:floor(length(RMSt1)/100):end)),log2(F'),Regfit'];
    Y6=Ht(1,numb1);
    Y7=Ht(1,numb3);
    Y8=Ht(end,numb2);
    Y9=Ht(end,numb4);
    log2scale=log2(scale);
    %-------------------------------------
    for ns=1:length(scale),
        scaletick{ns}=num2str(scale(ns));
    end

    % Create figure
    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1]);

    % Create axes
    axes1 = axes('Parent',figure1,'XTickLabel',{'','','','','','','','',''},...
        'Position',[0.08139 0.7673 0.7259 0.1577],...
        'LineWidth',2,...
        'FontSize',11);
    hold(axes1,'all');

    % Create plot
    plot(X1,Y1,'Parent',axes1);

    % Create plot
    plot(X2,Y2,'Parent',axes1,'MarkerFaceColor',[0 0.498 0],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','o',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[0 0.498 0]);

    % Create multiple lines using matrix input to plot
    plot(X3,Y3,'Parent',axes1,'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','square',...
        'LineWidth',2,...
        'LineStyle','none',...
        'MarkerFaceColor',[0 0.498 0],...
        'Color',[0 0.498 0]);

    % Create plot
    plot(X4,Y4,'Parent',axes1,'MarkerFaceColor',[1 0 0],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','o',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[1 0 0]);

    plot(X5,Y5,'Parent',axes1,'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','square',...
        'LineWidth',2,...
        'LineStyle','none',...
        'MarkerFaceColor',[1 0 0],...
        'Color',[1 0 0]);

    % Create ylabel
    ylabel('Amplitude','FontSize',12);

    % Create axes
    axes2 = axes('Parent',figure1,'XTickLabel',{'','','','','','','','',''},...
        'Position',[0.08139 0.5872 0.7259 0.1577],...
        'LineWidth',2,...
        'FontSize',12);
    ylim(axes2,[min(min(Ht))-0.05 max(max(Ht))+0.05]);
    hold(axes2,'all');

    % Create multiple lines using matrix input to plot
    plot2 = plot(X1,YMatrix2,'Parent',axes2);
    set(plot2(1),'DisplayName','Ht');
    set(plot2(2),'LineWidth',2,'Color',[0.749 0 0.749],...
        'DisplayName',strcat('mode Ht = ',num2str(Ht_mode)));

    % Create plot
    plot(X2,Y6,'Parent',axes2,'MarkerFaceColor',[0 0.498 0],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','o',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[0 0.498 0],...
        'DisplayName',strcat('max Ht = ',num2str(max(Ht(1,:)))));

    % Create plot
    plot(X3,Y7,'Parent',axes2,'MarkerFaceColor',[0 0.498 0],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','square',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[0 0.498 0],...
        'DisplayName',strcat('min Ht = ',num2str(min(Ht(1,:)))));

    % Create ylabel
    ylabel('Ht','FontSize',16);

    % Create axes
    axes3 = axes('Parent',figure1,'Position',[0.08139 0.4045 0.7259 0.1577],...
        'LineWidth',2,...
        'FontSize',12);
    ylim(axes3,[min(min(Ht))-0.05 max(max(Ht))+0.05]);
    hold(axes3,'all');

    % Create multiple lines using matrix input to plot
    plot3 = plot(X1,YMatrix3,'Parent',axes3);
    set(plot3(1),'DisplayName','Ht');
    set(plot3(2),'LineWidth',2,'Color',[0.749 0 0.749],...
        'DisplayName',strcat('mode Ht = ',num2str(Ht_mode)));

    % Create plot
    plot(X4,Y8,'Parent',axes3,'MarkerFaceColor',[1 0 0],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','o',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[1 0 0],...
        'DisplayName',strcat('max Ht = ',num2str(max(Ht(end,:)))));

    % Create plot
    plot(X5,Y9,'Parent',axes3,'MarkerFaceColor',[1 0 0],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','square',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[1 0 0],...
        'DisplayName',strcat('min Ht = ',num2str(min(Ht(end,:)))));

    % Create xlabel
    xlabel('time (sample number)','FontSize',12);

    % Create ylabel
    ylabel('Ht','FontSize',16);

    % Create axes
    axes4 = axes('Parent',figure1,'XTickLabel',scaletick,...
        'XTick',log2scale,...
        'Position',[0.08139 0.06326 0.2134 0.2234],...
        'LineWidth',2,...
        'FontSize',12);
    xlim(axes4,[log2scale(1)-0.05 log2scale(end)+0.05]);
    hold(axes4,'all');

    % Create multiple lines using matrix input to plot
    plot4 = plot(log2scale,YMatrix6,'Parent',axes4,'Marker','.','LineStyle','none',...
        'Color',[0 0 1]);
    set(plot4(length(YMatrix6)-1),'MarkerFaceColor',[0.749 0 0.749],'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','o',...
        'LineWidth',2,...
        'Color',[0.749 0 0.749]);
    set(plot4(length(YMatrix6)),'LineWidth',2,'Color',[0.749 0 0.749],'Marker','none',...
        'LineStyle','-');

    % Create multiple lines using matrix input to plot
    plot5 = plot(log2scale(1),YMatrix4,'Parent',axes4,'MarkerFaceColor',[0 0.498 0],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[0 0.498 0]);
    set(plot5(1),'Marker','o');
    set(plot5(2),'Marker','square');

    % Create multiple lines using matrix input to plot
    plot6 = plot(log2scale(end),YMatrix5,'Parent',axes4,'MarkerFaceColor',[1 0 0],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[1 0 0]);
    set(plot6(1),'Marker','o');
    set(plot6(2),'Marker','square');

    % Create xlabel
    xlabel('scale (segment sample size)','FontWeight','bold','FontSize',12);

    % Create ylabel
    ylabel('log_2(RMS)','FontSize',14);

    % Create title
    title('Scaling plot','FontSize',14);

    % Create axes
    axes5 = axes('Parent',figure1,'Position',[0.383 0.06326 0.2134 0.2234],...
        'LineWidth',2,...
        'FontSize',12);
    hold(axes5,'all');

    % Create plot
    plot(Htbin,Ph,'Parent',axes5,'LineWidth',2);

    % Create plot
    plot(mean(Htbin(Ph==max(Ph))).*ones(2,1),[min(Ph),max(Ph)],'Parent',axes5,'LineWidth',2,'Color',[0.749 0 0.749]);

    % Create xlabel
    xlabel('Ht','FontSize',16);

    % Create ylabel
    ylabel('Ph','FontSize',16);

    % Create title
    title('Prob. distribution (Ph) of Ht','FontSize',14);

    % Create axes
    axes6 = axes('Parent',figure1,'Position',[0.6907 0.06326 0.2134 0.2234],...
        'LineWidth',2,...
        'FontSize',12);
    hold(axes6,'all');

    % Create plot
    plot(Htbin,Dh,'Parent',axes6,'LineWidth',2);

    % Create plot
    plot(mean(Htbin(Ph==max(Ph))).*ones(2,1),[min(Dh(isinf(Dh)==0)),max(Dh)],'Parent',axes6,'LineWidth',2,'Color',[0.749 0 0.749]);

    % Create xlabel
    xlabel('Ht','FontSize',14);

    % Create ylabel
    ylabel('Dh','FontSize',16);

    % Create title
    title('Multifractal spectrum (Dh)','FontSize',14);

    % Create legend
    legend1 = legend(axes2,'show');
    set(legend1,'Position',[0.8215 0.6036 0.1589 0.1175],'LineWidth',2);

    % Create legend
    legend2 = legend(axes3,'show');
    set(legend2,'Position',[0.8215 0.4314 0.1589 0.1175],'LineWidth',2);

    % Create textbox
    annotation(figure1,'textbox',[0.2935 0.9004 0.2342 0.04172],...
        'String',{'Time series'},...
        'FontSize',14,...
        'FitBoxToText','off',...
        'LineStyle','none');

    % Create textbox
    annotation(figure1,'textbox',[0.2953 0.7135 0.2342 0.04172],...
        'String',{strcat('Ht: scale = ',num2str(scale(1)))},...
        'FontSize',14,...
        'FitBoxToText','off',...
        'LineStyle','none');

    % Create textbox
    annotation(figure1,'textbox',[0.2953 0.5307 0.2342 0.04172],...
        'String',{strcat('Ht: scale = ',num2str(scale(end)))},...
        'FontSize',14,...
        'FitBoxToText','off',...
        'LineStyle','none');
end