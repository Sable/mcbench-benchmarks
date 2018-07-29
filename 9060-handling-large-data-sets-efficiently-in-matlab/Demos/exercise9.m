%% a)
% plot(data(1:100:end,1));
% ylim([1 255]);

%% b)
%% Down sample rate
downsample=100;

%% Downsampled max/min
maxdata=zeros(1,size(data,1)/downsample);
mindata=zeros(1,size(data,1)/downsample);

for k=1:size(data,1)/downsample
   section=data((k-1)*downsample+(1:downsample),1);
   maxdata(k)=max(section);
   mindata(k)=min(section);
end

combine=[mindata;maxdata];
plot(1:.5:(numel(combine)/2+.5),combine(:),'g');
hold on;

%% Downsampled
plot(data(1:downsample:end,1),'b');
ylim([1 255]);
hold off;

%% Annotate
title('Detect Trend');
ylabel('Thickness');
xlabel('Wafer #');