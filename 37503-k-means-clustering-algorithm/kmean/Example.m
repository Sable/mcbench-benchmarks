% Example using the k-means algorithm function on an image and clustering
% the letters as seperate clusters

test = imread('Example.bmp');
test = test>=100;
test = test(:,:,1);

imagesc(test); colormap('gray')

% initial guess
means = [100,100; 200, 200; 150, 300; 50, 300];

hold on

% before the first step
plot(means(:,2),means(:,1),'o','Color',[1,0,0],'MarkerSize',10,'LineWidth',4)

% one step
means = kmean(test,means);
plot(means(:,2),means(:,1),'o','Color',[0,1,0],'MarkerSize',10,'LineWidth',4)

% second step
means = kmean(test,means);
plot(means(:,2),means(:,1),'o','Color',[0,0,1],'MarkerSize',10,'LineWidth',4)