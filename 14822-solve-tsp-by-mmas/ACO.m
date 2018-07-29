function ACO(inputfile)
% Usage: ACO('ulysses22.tsp')

%%%%%%%%%%%% The Key Parameter In Max-MIN Ant System %%%%%%%%%%%%%%%%%%%%%
AntNum=76; %Best equal Dimension of Problem
alpha=1;
beta=5;
rho=0.7;
MaxITime=AntNum*20;
%%%%%%%%%%%% The Key Parameter In Max-MIN Ant System %%%%%%%%%%%%%%%%%%%%%

[MMASOption,TSP] = InterfaceMMAS(inputfile,AntNum,alpha,beta,rho,MaxITime);
disp(['MMAS start at ',datestr(now)]);
[GBTour,GBLength,Option,IBRecord] = MMAS(MMASOption,TSP);
disp(['MMAS stop at ',datestr(now)]);

%:Show The Results
figure(1);

subplot(2,1,1)
plot(1:length(IBRecord(2,:)),IBRecord(2,:));
xlabel('Iterative Time');
ylabel('Iterative Best Cost');
title(['Iterative Course: ','GMinC=',num2str(GBLength)]);

subplot(2,1,2)
plot(1:length(IBRecord(1,:)),IBRecord(1,:));
xlabel('Iterative Time');
ylabel('Average Node Branching');

figure(2);
DrawCity(TSP.nodes,GBTour);
title('Final Global Best Tour Path');