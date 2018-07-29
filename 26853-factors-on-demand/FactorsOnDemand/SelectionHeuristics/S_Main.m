clc; close all; clear;

% this script selects the best K out of N factors in the Factors on Demand apporach to attribution
% see Meucci, A. (2010) "Factors on Demand", Risk, 23, 7, p. 84-89
% available at http://ssrn.com/abstract=1565134

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs
N=50;
A=randn(N+1,N+1);
Sig=A*A';

Metric.Cov_FF=Sig(1:N,1:N);
Metric.Cov_XF=Sig(N+1,1:N);
OutOfWho=[1:N];
    
% naive routine
[WhoNv, NumNv, GNv]=Naive(OutOfWho,Metric);
%[WhoNvF, NumNvF, GNvF]=Naive(FilteredWho,Metric);

% acceptance routine
AcceptBy=1;
[WhoA1, NumA1, GA1]=AcceptByS(OutOfWho,AcceptBy,Metric);

% rejection routine
RejectBy=1;
[WhoR1, NumR1, GR1]=RejectByS(OutOfWho,RejectBy,Metric);

figure
h1=plot(NumNv,GNv,'k');
hold on 
h2=plot(NumR1,GR1,'r');
hold on 
h3=plot(NumA1,GA1,'b');
legend([h1 h2 h3],'naive','rec. rejection','rec. acceptance','location','SouthEast')
xlabel(['num players out of total ' num2str(N)])
ylabel('fit')

break
% exact routine
GE=[];
NumE=[];
for k=1:length(OutOfWho)
    k
    [Who, G]=ExactNChooseK(OutOfWho,k,Metric);
    GE=[GE G];
    NumE=[NumE k];
end

hold on 
h4=plot(NumE,GE,'r');
