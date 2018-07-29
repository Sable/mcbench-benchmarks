%% data
clc;
clear all;
close all;
snri=(-10:2:30);
qam=[2,4,8,16,32,64];
capacity = zeros(length(qam),length(snri));
for qami=1:length(qam)
    for index=1:length(snri)
        capacity(qami,index) = QAMCapacity(snri(index),1,qam(qami));
    end
end
figure;
hold
for qami=1:length(qam)
    plot(snri,capacity(qami,:),'LineWidth',1.6);
end
GaussianC = zeros(1,length(snri));
for index=1:length(snri)
    GaussianC(index) = log2(1+ 10^(snri(index)/10));
end
plot(snri,GaussianC,'LineWidth',1.6);
set(gca,'FontSize', 12, 'FontName', 'Times New Roman');
grid on;
box on;
xlabel('SNR (Es/No) dB','FontSize', 14, 'FontName', 'Times New Roman');
ylabel('Capacity (bits/Tx)','FontSize',14,'FontName', 'Times New Roman');

save ('DiscretInContinuousOutCapacityAWGN.mat','snri','capacity','GaussianC')
