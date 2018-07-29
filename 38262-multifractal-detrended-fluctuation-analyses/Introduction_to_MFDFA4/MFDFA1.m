function [Hq,tq,hq,Dq,Fq] = MFDFA1(signal,scale,q,m,Fig)
% Multifractal detrended fluctuation analysis (MFDFA)
%
% [Hq,tq,hq,Dq,Fq]=MFDFA(signal,scale,q,m,Fig);
%
% INPUT PARAMETERS---------------------------------------------------------
%
% signal:       input signal
% scale:        vector of scales
% q:            q-order that weights the local variations 
% m:            polynomial order for the detrending
% Fig:          1/0 flag for output plot of Fq, Hq, tq and multifractal
%               spectrum (i.e. Dq versus hq).
%
% OUTPUT VARIABLES---------------------------------------------------------
%
% Hq:           q-order Hurst exponent
% tq:           q-order mass exponent 
% hq:           q-order singularity exponent
% Dq:           q-order dimension 
% Fq:           q-order scaling function
%
% EXAMPLE------------------------------------------------------------------
%
% load fractaldata
% scmin=16;
% scmax=1024;
% scres=19;
% exponents=linspace(log2(scmin),log2(scmax),scres);
% scale=round(2.^exponents);
% q=linspace(-5,5,101);
% m=1;
% signal1=multifractal;
% signal2=monofractal;
% signal3=whitenoise;
% [Hq1,tq1,hq1,Dq1,Fq1]=MFDFA1(signal1,scale,q,m,1);
% [Hq2,tq2,hq2,Dq2,Fq2]=MFDFA1(signal2,scale,q,m,1);
% [Hq3,tq3,hq3,Dq3,Fq3]=MFDFA1(signal3,scale,q,m,1);
%--------------------------------------------------------------------------
warning off
X=cumsum(signal-mean(signal));
if min(size(X))~=1||min(size(scale))~=1||min(size(q))~=1;
    error('Input arguments signal, scale and q must be a vector');
end
if size(X,2)==1;
   X=transpose(X);
end
if min(scale)<m+1
   error('The minimum scale must be larger than trend order m+1')
end
for ns=1:length(scale),
    segments(ns)=floor(length(X)/scale(ns));
    for v=1:segments(ns),
        Index=((((v-1)*scale(ns))+1):(v*scale(ns)));
        C=polyfit(Index,X(Index),m);
        fit=polyval(C,Index);
        RMS_scale{ns}(v)=sqrt(mean((X(Index)-fit).^2));
    end
    for nq=1:length(q),
        qRMS{nq,ns}=RMS_scale{ns}.^q(nq);
        Fq(nq,ns)=mean(qRMS{nq,ns}).^(1/q(nq));
    end
    Fq(q==0,ns)=exp(0.5*mean(log(RMS_scale{ns}.^2)));
end
for nq=1:length(q),
    C = polyfit(log2(scale),log2(Fq(nq,:)),1);
    Hq(nq) = C(1);
    qRegLine{nq} = polyval(C,log2(scale));
end
tq = Hq.*q-1;
hq = diff(tq)./(q(2)-q(1));
Dq = (q(1:end-1).*hq)-tq(1:end-1);

%OUTPUT FIGURE-------------------------------------------------------------
if Fig==1, 
   qindex=[1,round(length(q)/2),length(q)];
   qindex2=[1,round((length(q)-1)/2),length(q)-1];
   
   %Variable settings---------
   qstart1=q(qindex(1));
   qmid1=q(qindex(2));
   qstop1=q(qindex(3));
   Hqstart1=Hq(qindex(1));
   Hqmid1=Hq(qindex(2));
   Hqstop1=Hq(qindex(3));
   tqstart1=tq(qindex(1));
   tqmid1=tq(qindex(2));
   tqstop1=tq(qindex(3));
   hqstart2=hq(qindex2(1));
   hqmid2=hq(qindex2(2));
   hqstop2=hq(qindex2(3));
   Dqstart1=Dq(qindex2(1));
   Dqmid1=Dq(qindex2(2));
   Dqstop1=Dq(qindex2(3));
   for nq=1:length(qindex),
       qRegFit(nq,:)=qRegLine{qindex(nq)};
   end
   X1=log2(scale);
   YMatrix1=[log2(Fq(qindex,:));qRegFit];
   X2=q;
   Y1=Hq;
   Y3=tq;
   X4=hq;
   Y5=Dq;
   %---------------------------
    q_end=num2str(max(q));
    if length(find(q==0))==1
       q_middle=0;
    else
       qm0=min(q)+((max(q)-min(q))/2);
       qm1=[q(find(q<qm0, 1, 'last' )),q(find(q>qm0, 1 ))];
       qm2=qm1-qm0;
       midind= qm2==min(qm2);
       q_middle=qm2(midind(1));
    end
    q_mid=num2str(q_middle);
    q_start=num2str(min(q));

    % Create figure
    figure1 = figure('PaperSize',[20.98 29.68],'Color',[1 1 1]);

    scaleInd=floor(min(log2(scale))):ceil(max(log2(scale)));
    for ns=1:length(scaleInd),
        scaletick{ns}=num2str(2^scaleInd(ns));
    end
    Fqind=floor(log2(min(min(Fq)))):ceil(log2(max(max(Fq))));
    for nf=1:length(Fqind),
        Fqtick{nf}=num2str(Fqind(nf));
    end

    % Create subplot
    subplot1 = subplot(2,2,1,'Parent',figure1,...
        'YTickLabel',Fqtick,...
        'XTickLabel',scaletick,...
        'XTick',scaleInd,...
        'LineWidth',2,...
        'FontSize',14);
    hold(subplot1,'all');

    % Create multiple lines using matrix input to plot
    plot1 = plot(X1,YMatrix1,'Parent',subplot1);
    set(plot1(1),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[0 0 0],...
        'Marker','o',...
        'LineStyle','none',...
        'Color',[1 0 0],...
        'DisplayName',strcat('q = ',num2str(min(q))));
    set(plot1(2),'MarkerFaceColor',[0 0 1],'MarkerEdgeColor',[0 0 0],...
        'Marker','o',...
        'LineStyle','none',...
        'Color',[0 0 1],...
        'DisplayName',strcat('q = ',num2str(q_middle)));
    set(plot1(3),'MarkerFaceColor',[0 0.498 0],'MarkerEdgeColor',[0 0 0],...
        'Marker','o',...
        'LineStyle','none',...
        'Color',[0 0.498 0],...
        'DisplayName',strcat('q = ',num2str(max(q))));
    set(plot1(4),'LineWidth',2,'Color',[1 0 0],'DisplayName',strcat('q = ',num2str(min(q))));
    set(plot1(5),'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 1 1],...
        'LineWidth',2,...
        'Color',[0 0 1],...
        'DisplayName',strcat('q = ',num2str(q_middle)));
    set(plot1(6),'LineWidth',2,'Color',[0 0.498 0],'DisplayName',strcat('q = ',num2str(max(q))));

    % Create xlabel
    xlabel('Scale (segment sample size)','FontSize',14);

    % Create ylabel
    ylabel('log_2(Fq)','FontSize',14);

    % Create title
    title('Scaling function Fq (q-order RMS)','FontSize',14);

    qInd=floor(min(q)):ceil(max(q));
    for nq=1:length(qInd),
        qtick{nq}=num2str(qInd(nq));
    end

    % Create subplot
    subplot2 = subplot(2,2,2,'Parent',figure1,...
        'XTickLabel',qtick,...
        'XTick',qInd,...
        'LineWidth',2,...
        'FontSize',14);
    hold(subplot2,'all');

    % Create plot
    plot(X2,Y1,'Parent',subplot2,'Marker','o','LineStyle','none',...
        'Color',[0 0 1]);

    % Create xlabel
    xlabel('q','FontSize',16);

    % Create ylabel
    ylabel('Hq','FontSize',16);

    % Create title
    title('q-order Hurst exponent','FontSize',14);

    % Create plot
    plot(qstart1,Hqstart1,'Parent',subplot2,'MarkerFaceColor',[1 0 0],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','o',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[1 0 0],...
        'DisplayName',strcat('Hq(',num2str(min(q)),') = ',num2str(Hq(q==min(q)))));

    % Create plot
    plot(qmid1,Hqmid1,'Parent',subplot2,'MarkerFaceColor',[0 0 1],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','o',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[0 0 1],...
        'DisplayName',strcat('Hq(',num2str(q_middle),') = ',num2str(Hq(q==q_middle))));

    % Create plot
    plot(qstop1,Hqstop1,'Parent',subplot2,'MarkerFaceColor',[0 0.498 0],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','o',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[0 0.498 0],...
        'DisplayName',strcat('Hq(',num2str(max(q)),') = ',num2str(Hq(q==max(q)))));

    % Create subplot
    subplot3 = subplot(2,2,3,'Parent',figure1,...
        'XTickLabel',qtick,...
        'XTick',qInd,...
        'LineWidth',2,...
        'FontSize',14);
    hold(subplot3,'all');

    % Create plot
    plot(X2,Y3,'Parent',subplot3,'Marker','o','LineStyle','none',...
        'Color',[0 0 1]);

    % Create xlabel
    xlabel('q','FontSize',16);

    % Create ylabel
    ylabel('tq','FontSize',16);

    % Create title
    title('q-order Mass exponent','FontSize',14);

    % Create plot
    plot(qstop1,tqstop1,'Parent',subplot3,'MarkerFaceColor',[0 0.498 0],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','o',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[0 0.498 0],...
        'DisplayName',strcat('tq(',num2str(max(q)),') = ',num2str(tq(q==max(q)))));

    % Create plot
    plot(qstart1,tqstart1,'Parent',subplot3,'MarkerFaceColor',[1 0 0],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','o',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[1 0 0],...
        'DisplayName',strcat('Hq(',num2str(min(q)),') = ',num2str(Hq(q==min(q)))));

    % Create plot
    plot(qmid1,tqmid1,'Parent',subplot3,'MarkerFaceColor',[0 0 1],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','o',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[0 0 1],...
        'DisplayName',strcat('Hq(',num2str(q_middle),') = ',num2str(Hq(q==q_middle))));

    % Create subplot
    subplot4 = subplot(2,2,4,'Parent',figure1,'LineWidth',2,'FontSize',12);
    % Uncomment the following line to preserve the X-limits of the axes
    % xlim(subplot4,[0.2 1.8]);
    hold(subplot4,'all');

    % Create plot
    plot(X4,Y5,'Parent',subplot4,'Marker','o','LineStyle','none',...
        'Color',[0 0 1]);

    % Create xlabel
    xlabel('hq','FontSize',16);

    % Create ylabel
    ylabel('Dq','FontSize',16);

    % Create title
    title('Multifractal spectrum','FontSize',14);

    % Create plot
    plot(hqstart2,Dqstart1,'Parent',subplot4,'MarkerFaceColor',[1 0 0],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','o',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[1 0 0],...
        'DisplayName',[strcat('Dq(',num2str(min(q)),') = ',num2str(Dq(q==min(q)))),sprintf('\n'),strcat('hq(',num2str(min(q)),') = ',num2str(hq(q==min(q))))]);

    % Create plot
    plot(hqmid2,Dqmid1,'Parent',subplot4,'MarkerFaceColor',[0 0 1],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','o',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[0 0 1],...
        'DisplayName',[strcat('Dq(',num2str(q_middle),') = ',num2str(Dq(q==q_middle))),sprintf('\n'),strcat('hq(',num2str(q_middle),') = ',num2str(hq(q==q_middle)))]);

    % Create plot
    plot(hqstop2,Dqstop1,'Parent',subplot4,'MarkerFaceColor',[0 0.498 0],...
        'MarkerEdgeColor',[0 0 0],...
        'MarkerSize',8,...
        'Marker','o',...
        'LineWidth',2,...
        'LineStyle','none',...
        'Color',[0 0.498 0],...
        'DisplayName',[strcat('Dq(',num2str(max(q)),') = ',num2str(Dq(find(q==max(q))-1))),sprintf('\n'),strcat('hq(',num2str(max(q)),') = ',num2str(hq(find(q==max(q))-1)))]);

    % Create legend
    %legend1 = legend(subplot1,'show');
    %set(legend1,'Position',[0.4174 0.6072 0.09288 0.2055]);
    % Create legend
    legend1 = legend(subplot1,'show');
    set(legend1,'Position',[0.4126 0.6072 0.1024 0.2055]);

    % Create legend
    legend2 = legend(subplot3,'show');
    set(legend2,'Position',[0.3414 0.1576 0.1458 0.1714]);

    % Create legend
    legend3 = legend(subplot2,'show');
    set(legend3,'Position',[0.8171 0.7456 0.1528 0.1714]);

    % Create legend
    legend4 = legend(subplot4,'show');
    set(legend4,'Position',[0.8338 0.2436 0.1354 0.2764]);

    % Create textbox
    annotation(figure1,'textbox',[0.2726 0.638 0.1111 0.05249],...
        'String',{'Slope = Hq'},...
        'HorizontalAlignment','center',...
        'FontSize',14,...
        'FitBoxToText','off');

    % Create textbox
    annotation(figure1,'textbox',[0.6355 0.1669 0.2013 0.05518],...
        'String',{strcat('hq_m_a_x - hq_m_i_n = ',num2str(max(hq)-min(hq)))},...
        'HorizontalAlignment','center',...
        'FontSize',14,...
        'FitBoxToText','off',...
        'LineStyle','none');
end