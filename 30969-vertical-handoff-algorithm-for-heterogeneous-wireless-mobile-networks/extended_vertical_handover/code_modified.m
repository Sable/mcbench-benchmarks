%% A Simple and Robust Vertical Handoff Algorithm for HeterogeneousWireless Mobile Networks
%   Function Parameters:
%   C=cost of Ith network      S=Security     P=Power
%   D = Network Conditions     F= Network Performance
%   V = Velocity of MN         T= Estimated Time MN will stay in the
%                                   network coverage
%   NS = Network Set of eligible candidates for VHO
%   N = Number of Networks Presently available for evaluation.
%   lambda = mean number of request arrivals per unit time
%   mu = mean number of calls serviced per unit time
%   wx = weight function of the 'x' parameter for evaluating EVHDF
%   
% Take as input from user the various network parameters for each network
% under consideration.
%
%   Reference: A Simple and Robust Vertical Handoff Algorithm for
%   Heterogenous Wireless Mobile Networks
%   Paper Authors: Daojing He, Caixia Chi, Sammy Chan, Chun Chen, Jiajun Bu,
%   Mingjian Yin.
%   Wireless Pers Commun DOI 10.1007/s11277-010-9922-x
%
%   Code Author: Anshul Thakur
%   Contact: anshulthakurjourneyendless@gmail.com
%   Created: 4/4/2011
%   Copyright Owner: Anshul Thakur


%% Note that the code that has been commented out are of the various
% parameters that the author did not consider for his evaluation. User may
% uncomment the necessary part to include more parameters in their
% evaluation
function code_modified()
%This section of code takes in various parameters of the different networks
%between which decision of a handoff is to be made.
fprintf('\nThe number of networks under evaluation N: \n')
N=input('=');
b=zeros(1,N);
RSS=zeros(1,N);
%V=zeros(1,N);
T=zeros(1,N);
%P=zeros(1,N);
%C=zeros(1,N);
%fj=zeros(1,N);
%wc=zeros(1,N);
%ws=zeros(1,N);
%wf=zeros(1,N);
wp=zeros(1,N);
wd=zeros(1,N);
M=zeros(1,N);
lambda=zeros(1,N);
mu=zeros(1,N);
pj=zeros(1,N);
NL=0;
fprintf('\nEnter the threshold values of various parameters when prompted.\n');
    bi=input('Threshold Current Available Bandwidth: ');
    RSSi=input('Threshold Received Signal Strength:  ');
    %Vi=input('Threshold Velocity of Mobile Station:  ');
    Ti=input('Threshold Estimated Time MS will be in present network:  ');
    %Pi=input('Threshold Battery Power of MS  :');
    %Ci=input('Threshold Cost of Network to MS  :');
for i=1:N
    fprintf('Enter the values for the network number %d when prompted.\n', i);
    if(i==1)
        fprintf('Enter the values of the currently connected network\n');
    end
    b(1,i)=input('Current Available Bandwidth: ');
    RSS(1,i)=input('Received Signal Strength:  ');
    %V(1,i)=input('Velocity of Mobile Station:  ');
    T(1,i)=input('Estimated Time MS will be in present network:  ');
    %P(1,i)=input('Battery Power of MS  :');
    %C(1,i)=input('Cost of Network to MS  :');
    %s(1,i)=input('Security level in Network    :');
    pj(1,i)=input('Power Dissipation in Network  :');
    %fj(1,i)=input('Network Performance Parameter of Network    :');
    lambda(1,i)=input('Mean number of request arrivals per unit time    :');
    mu(1,i)=input('Mean number of calls serviced per unit time  :');
    fprintf('\n \t Enter the Network Dependent Weights to the following parameters\n');
    %wc(1,i)=input('Cost of Service:');
    %ws(1,i)=input('Security Parameter:');
    wp(1,i)=input('Power Consumption: ');
    wd(1,i)=input('Network Conditions:  ');
    %wf(1,i)=input('Network Performance     :');
    
    %% This part evaluates the first step decision function to find the eligible
    % set of networks out of the available networks with values greater
    % than threshold
    %M(1,i)=((b(1,i)-bi)>0)&&((RSS(1,i)-RSSi)>0)&&((V(1,i)-Vi)>0)&&((T(1,i)-Ti)>0)&&((P(1,i)-Pi)>0)&&((C(1,i)-Ci)>0);
    M(1,i)=((b(1,i)-bi)>0)&&((RSS(1,i)-RSSi)>0)&&((T(1,i)-Ti)>0);
    if M(1,i)==1
        NL=NL+1;
    end
end
if(NL==0)
    fprintf('\nNo eligible networks found. Remain Connected to existing network itself\n');
else
%% Decision making when Network list has some networks in it
    NS=zeros(1,NL);
    hi=zeros(1,NL);
    EQ=zeros(1,NL);
    Dj=zeros(1,NL);
   x=1;
   for i=1:N
        if M(1,i)~=0
            NS(1,x)=i;
            x=x+1;
        end
   end
   if ((NL==1)&&(NS(1,1)==1))
       fprintf('\nNo other network is having minimum service quality better than threshold. Stay in same network\n');
   elseif((NL==1)&&(NS(1,1)~=1))
       fprintf('\n Handoff to new network with Network ID %d',NS(1,1));
   else
       fprintf('\nIs the Mobile Node Reource rich or Resource Poor?\n');
       res=input('r for Rich/ p for Poor      ','s');
       if(strcmp(res,'p'))
           if(NS(1,1)==1)
               frpintf('\nNo handoff required for Resource Poor Mobile Node at present\n');
           else
               fprintf('\nPerform Handoff with any of the %d Networks in the pool',NL);
           end
       elseif(strcmp(res,'r'))
           for i=1:NL
               index=NS(1,i);
               hi(1,i)=dyn_cal_prob(lambda(1,index),mu(1,index),b(1,index));
               Dj(1,i)=(b(1,index))/(hi(1,i));
           end
           %% This section evaluates the Extended Vertical Handoff Decision
           %  Function for the network pool previously selected as eligible
           for i=1:NL
               %index=NS(i,i);
               %Ct(1,i)=C(1,index);
               %EQ(1,i)=((wc(1,index)*(1/Ct(1,i)))/min(Ct,[],2))+(ws(1,index)*s(1,index)/max(s,[],2))+(wp(1,index)*pj(1,index)/max(pj,[],2))+(wd(1,index)*Dj(1,i)/max(Dj,[],2))+(wf(1,index)*fj(1,index)/max(fj,[],2));
               %EQ(1,i)=Dj(1,i)/max(Dj,[],2);
               EQ(1,i)=(wp(1,index)*pj(1,index)/max(pj,[],2))+(wd(1,index)*Dj(1,i)/max(Dj,[],2));
           end
           [para,netwrk]=max(EQ,[],2);
           if netwrk==1
               fprintf('\nCurrently selected Network is the best network, no Handoff required\n');
           else
               fprintf('\nPerform handoff with Network %d for best performance\n',NS(netwrk));
           end
       end
   end
    figure;
    subplot(2,1,1);
    stem(NS(1,:),hi(1,:));
    ylabel('New Dynamic Call Blocking Probability');
    xlabel('Network Number');
    title('a.   NDCBP vs Network ');
    subplot(2,1,2);
    stem(NS(1,:),EQ(1,:));
    title('   b.  EVHDF vs Network');
    xlabel('Netowrk');
    ylabel('Extended Vertical Handoff Decision Function');   
end
end


%% Function to compute the New Dynamic Call blocking Probability
function hi=dyn_cal_prob(lambda, mu, bi)
    b=(lambda/mu);
    a=(b.^(bi))/factorial(bi);
    sumi=0;
    for n=0:bi
        sumi=sumi+((b.^exp(n))/factorial(n));
    end
    hi=a/sumi;
end
