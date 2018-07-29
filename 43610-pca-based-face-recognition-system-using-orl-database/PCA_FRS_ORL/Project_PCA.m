clc
clear all
close all
Results=[];
for TrNum=1:9
    [recp,rectime,TDS,DS]= PCA_NEW(TrNum);
    Results=[Results;recp,rectime,TDS,DS];
end

bar(1:TrNum,Results(:,1,1,1)*100);
title('Recognition Percentage vs Number of Training sample per class');
xlabel('Number of Training sample per class');
ylabel('Recognition Percentage');