function varargout=ewmaestimatevar(P1,P2,s,lambda,cl,w)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function estimates value risk of portfolio by exponentially weighted 
% moving average method at two levels. And sketchs related figures at the 
% given levels.
% The figures shows two quantities at any point of time, estimated value at
% risk and portfolio return at that time.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Functon's arguments
% The first argument (P1) is the first daily price series, The second
% argument (p2) is second daily price series, The third argument (s) is the 
% sample-in size, The fourth argument (lambda) is the decay parameter, The 
% fifth parameter (cl) is confidence levels vector (two confidence levels),
% The sixth parameter (w) is the weight of first daily price in portfolio 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% outputs
% [VaR violation RP]=ewmaestimatevar(P1,P2,s,lambda,cl,w)
% VaR: The Estimated VaR Vector.
% violation: The number of violations.
% RP: The Portfolio returns vector.
%% Revised by Ali Najjar, August 28, 2012
%% Written by Ali Najjar, April 30, 2011
%%
%Main Body
n=size(P1,1);
[row_cl,col_cl]=size(cl);
R1=zeros(n-1,1);
R2=zeros(n-1,1);
VaR=zeros(n-1-s,row_cl);
violation=zeros(row_cl,col_cl);
for i=2: n
    R1(i-1)=100*log(P1(i)/P1(i-1));
    R2(i-1)=100*log(P2(i)/P2(i-1));
end
% portfolio return
RP=w*R1+(1-w)*R2;
%
W=[w,1-w];

for j=1:row_cl
    for i=1:(n-1-s)
        R1A=R1(i:i+s-1);
        R2A=R2(i:i+s-1);
        va_co=[ewmavariance(R1,(s+i),s,lambda),ewmacovariance(R1,R2,(s+i),s...
            ,lambda);ewmacovariance(R1,R2,(s+i),s,lambda),ewmavariance(R2,(s+i),s,lambda)];
        mu=[mean(R1A),mean(R2A)];
       
        VaR(i,j)=-(W*mu'+sqrt(W*va_co*W')*norminv(cl(j)));
        if VaR(i,j)>RP(s+i-1);
            violation(j)=violation(j)+1;
        end
    end
end
varargout{1}=VaR;
varargout{2}=violation;
varargout{3}=RP;
%
%% Plotting
%
figure(1);
plot(1:(n-1-s),RP(s+1:n-1),'g.');
hold on;
plot(1:(n-1-s),VaR(:,1),'r:');
legend('Portfolio Return','EWMA');
xlabel('Trading days','horizontal','center','Fontweight','bold');
ylabel('Portfolio Return','rotation',90,'horizontal',...
    'center','Fontweight','bold');
title(['EWMA VaR at ',num2str(cl(1)*100),...
    '%'],'FontSize',12,'Fontweight','bold');
hold off;
figure(2);
plot(1:(n-1-s),RP(s+1:n-1),'.');
hold on;
plot(1:(n-1-s),VaR(:,2),'m:');
legend('Portfolio Return','EWMA');
xlabel('Trading days','horizontal','center','Fontweight','bold');
ylabel('Portfolio Return','rotation',90,'horizontal',...
    'center','Fontweight','bold');
title(['EWMA VaR at ',num2str(cl(2)*100),...
    '%'],'FontSize',12,'Fontweight','bold');
hold off


end
