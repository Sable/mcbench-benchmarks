function Error=Error1(P,T,Comment)
%   Error=Error1(T,P,Comment)
%                                ANNN1
%                       
%           NEURAL NETWORK SCRIPT LINK FOR HYDROLOGICAL PURPOSES
%
%                             Version 2.0
%                         
%                       Department of Hydroinformatics
%                                 Delft
%                        Gerald A. Corzo Perez
%                               UNESCO-IHE
%                               www.hi.ihe.nl
%                                --OO--
%
%
%DEFAULT PARAMETERS FOR TRAINING NETWORKS:if isempty(Par)
%     P= Predicted values (vector)
%     T= Target values  (vector)
%
%OTHER FILES IN DIRECTORY
%Error1, Error2, Error7, Error6 in adition works only with Matlab version
%above 7 and should have the NN toolbox
%
% Error.MARE=MARE -> Mean Absolute relative error
% Author: Gerald Corzo
% Made Jan 2004
% Updated May /2009
%
if isempty(Comment)
    Comment='Target and Predicted';
end

S=size(P);
if S(1)<S(2)
    P=P';
end

S=size(T);
if S(1)<S(2)
    T=T';
end

n=size(P,1);
%Traditional Measures of error
SSE=sum((P-T).^2);
RMSE=sqrt(SSE/size(P,1));
StdT=std(T,1);
StdP=std(P,1);
NRMSE=100*RMSE/StdT;%sqrt(SSE/sum((T-mean(T)).^2));
NSC=1-SSE/sum((T-mean(T)).^2);
Cor=sum((P-mean(P)).*(T-mean(T)))/(sqrt(sum((P-mean(P)).^2))*sqrt(sum((T-mean(T)).^2)));

MAE=sum(abs(P-T))/size(P,1);
MARE=sum(abs((T-P)./T))/n;

MuT=mean(T);
MuP=mean(P);

%Calculating PERS
P2=T(1:end-1,:);
T2=T(2:end,:);
SSEN=sum((P2-T2).^2);
PERS=1-(SSE/SSEN);
RMSEN=sqrt(SSEN/(n-1));
NRMSEN=100*RMSEN/std(T2,1);

%Passing the output structure
Error.RMSE=RMSE;
Error.NSC=NSC;
Error.Cor=Cor;
Error.NRMSE=NRMSE;
Error.MAE=MAE;
Error.StdT=StdT;
Error.StdP=StdP;
Error.MuT=MuT;
Error.MuP=MuP;
Error.PERS=PERS;
Error.SSE=SSE;
Error.SSEN=SSEN;  %Sum Squared Error Naive
Error.RMSEN=RMSEN; %RMSE Naive
Error.NRMSEN=NRMSEN; %NRMSE Naive
Error.MARE=MARE;

%Ploting results
figure1 = figure(...
  'Color',[1 1 1],...
  'PaperPosition',[0.6345 6.345 20.3 15.23],...
  'PaperSize',[20.98 29.68],'Tag',Comment,'HandleVisibility','on','visible','on');
set(gcf,'color',[1 1 1]);
%Upper graph with the taget and predicted series
subplot(2,1,1);
H1=plot(P,'r--','LineWidth',2);
hold on;
H2 = plot(T,...
  'Color',[0 0 1],...
  'DisplayName','Predicted');  
%H2=plot(T,'b');
legend1=legend([H1 H2],'Predicted','Target');

set(legend1,'FontName','Tahoma',...
  'FontSize',8,...
  'Location','SouthOutside',...
  'Position',[0.7389 0.4479 0.1898 0.092],...
  'EdgeColor',[1 1 1]);
  
title({'Time series of target and predicted discharges',['(RMSE=' num2str(RMSE) ') ' Comment ]});
xlabel('Time');
ylabel('Discharge (mł/s)');

%Lower graphwith the Error Target minus predicted

subplot(2,1,2);
plot(T-P,...
 'Color',[0 0 1],...
 'DisplayName','Target');
title(['Error between target and predicted (NRMSE=' num2str(NRMSE) ')']);
xlabel('Time');
ylabel('Error (T-P)');

Error.Er=T-P;
Io=find(Error.Er<=0);
Iu=find(Error.Er>0);

S1=size(Io,1);
S2=size(Iu,1);

Error.Po=S1/size(Error.Er,1);
Error.Pu=S2/size(Error.Er,1);
Error.h=figure1;
