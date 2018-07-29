function b = Theil_Sen_Regress(x,y)

[N c]=size(x);


Comb = combnk(1:N,2);
deltay=diff(y(Comb),1,2);
deltax=diff(x(Comb),1,2);



theil=diff(y(Comb),1,2)./diff(x(Comb),1,2);
b=median(theil);






%% Example code below !!

% % %  x = (-15:25)';
% % % y =2*x + normrnd(0,3,41,1);
% % % y([38 40 41]) = 0;
% % % y([1 3])=20;
% % % 
% % % bls = regress(y,[ones(41,1) x]);
% % % [N c]=size(x);
% % % Comb = combnk(1:N,2);
% % % deltay=diff(y(Comb),1,2);
% % % deltax=diff(x(Comb),1,2);
% % % theil=diff(y(Comb),1,2)./diff(x(Comb),1,2);
% % % b=median(theil);
% % % 
% % % scatter(x,y,'filled'); grid on; hold on
% % % plot(x,bls(1)+bls(2)*x,'r','LineWidth',2);
% % % plot(x,b*x,'g','LineWidth',3);
% % % plot(x,2*x,'k','LineWidth',2);
% % % legend('Data','Ordinary Least Squares','Theil-Senn Estimator','Real slope')