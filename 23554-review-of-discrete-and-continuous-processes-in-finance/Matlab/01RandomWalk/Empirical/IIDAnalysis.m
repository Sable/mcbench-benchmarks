function IIDAnalysis(Dates,Data)
% this function performs simple invariance (i.i.d.) tests on a time series
% 1. it checks that the variables are identically distributed by looking at the 
%    histogram of two subsamples
% 2. it checks that the variables are independent by looking at the 1-lag scatter plot
% under i.i.d. the location-dispersion ellipsoid should be a circle
% see "Risk and Asset Allocation"-Springer (2005), by A. Meucci




% plot time series

figure
h=plot(Dates,Data,'.'); 
xlim([Dates(1) Dates(end)])
datetick('x','mmmyy','keeplimits','keepticks');
grid on


% test "identically distributed hypothesis": split observations into two sub-samples and plot histogram
Sample_1=Data(1:round(length(Data)/2));
Sample_2=Data(round(length(Data)/2)+1:end);
num_bins_1=round(5*log(length(Sample_1)));
num_bins_2=round(5*log(length(Sample_2)));
X_lim=[min(Data)-.1*(max(Data)-min(Data)) max(Data)+.1*(max(Data)-min(Data))];
[n1,xout1]=hist(Sample_1,num_bins_1);
[n2,xout2]=hist(Sample_2,num_bins_2);

figure
subplot('Position',[0.03 .59 .44 .35])
h1=bar(xout1,n1,1);
set(h1,'FaceColor',[.7 .7 .7],'EdgeColor','k')
set(gca,'ytick',[],'xlim',X_lim,'ylim',[0 max(max(n1),max(n2))])
grid off

subplot('Position',[.53 .59 .44 .35])
h2=bar(xout2,n2,1);
set(h2,'FaceColor',[.7 .7 .7],'EdgeColor','k');
set(gca,'ytick',[],'xlim',X_lim,'ylim',[0 max(max(n1),max(n2))]);
grid off

% test "independently distributed hypothesis": scatter plot of observations at lagged times
subplot('Position',[.28 .01 .43 .43])
X=Data(1:end-1);
Y=Data(2:end);
h3=plot(X,Y,'.');
grid off
axis equal
set(gca,'xlim',X_lim,'ylim',X_lim);

m=mean([X Y])';
S=cov([X Y]);
TwoDimEllipsoid(m,S,2,0,0);