clear all;
close all;

NbSimu = 20000 : 20000: 200000;
NbPoints = numel(NbSimu);

ResAV =  zeros(NbPoints,1);
ResMC =  zeros(NbPoints,1);
ResMCCV =  zeros(NbPoints,1);
ResSobol = zeros(NbPoints,1);
ResHalton = zeros(NbPoints,1);

CIAV   =  zeros(NbPoints,2);
CIMC   =  zeros(NbPoints,2);
CIMCCV =  zeros(NbPoints,2);
CIQMC  = zeros(NbPoints,2);
CIHalton = zeros(NbPoints,2);


BLprice = blsprice(100,100,0.03,0.25,0.5,0);
%% Run 
for i = 1 :numel(NbSimu)
  disp(['Computing Iteration N°' num2str(i) ' with ' num2str(NbSimu(i)) ' Simulated Paths']);
    [ResAV(i),CIAV(i,:)] =  BlsMCAV(100,100,0.03,0.25,0.5,NbSimu(i));
    [ResMC(i),CIMC(i,:)] =  BlsMC(100,100,0.03,0.25,0.5,NbSimu(i));
    [ResMCCV(i),CIMCCV(i,:)] =  BlsMCCV(100,100,0.03,0.25,0.5,NbSimu(i),1000);
    [ResSobol(i),CIQMC(i,:)] =  BlsSobol(100,100,0.03,0.25,0.5,NbSimu(i));
    [ResHalton(i),CIHalton(i,:)] =  BlsHalton(100,100,0.03,0.25,0.5,NbSimu(i));
end;

%% Display Results
h= figure;
plot(NbSimu,[repmat(BLprice,NbPoints,1) ResAV ResMC ResMCCV ResSobol ResHalton]);
legend({'Black Scholes' 'Antithetic', 'Simple Monte Carlo', 'Monte Carlo with Control Variable', 'Sobol sequences', 'Halton Sequences'});
set(h,'WindowStyle','Docked');
grid on;
xlabel('Number of simuation');
Ylabel('Vanilla option Price');
xlim([NbSimu(1) NbSimu(end)]);
ylim([10 10.5]);
%%
h= figure;
plot(NbSimu,[diff(CIAV,1,2) diff(CIMC,1,2) diff(CIMCCV,1,2) ]);
legend({'Antithetic', 'Simple Monte Carlo', 'Monte Carlo with Control Variable', });
grid on;xlim([NbSimu(1) NbSimu(end)]);
title('Comparing different Monte Carlo methods')
set(h,'WindowStyle','Docked');
xlabel('Number of simuation');
Ylabel('absolute confidence ionterval');
h= figure;
FillBetween(NbSimu',CIMCCV(:,1),CIMCCV(:,2),'g',0.3);
hold on;
plot(NbSimu,ResMCCV,'LineWidth',1.5,'Color','r');
plot(NbSimu,repmat(BLprice,NbPoints,1),'b');
xlim([NbSimu(1) NbSimu(end)])
set(h,'WindowStyle','Docked');
title('Monte Carlo with Control Variable');
xlabel('Number of simulation');
Ylabel('Vanilla option Price');
grid on;
