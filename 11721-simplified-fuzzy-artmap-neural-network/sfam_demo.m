%
% SFAM usage demo. 
%
function sfam_demo

% load data
load demodata

% create network
net = create_network(size(data,2))

% change some parameters as you wish
net.epochs = 1;

% train the network
tnet = train(data, labels, net, 100)

% test the network on the testdata
r = classify(testdata, tnet, testlabels, 10);

% compute classification performance
fprintf(1,'Hit rate: %f\n', sum(r' == testlabels)*100/size(testdata,1));
