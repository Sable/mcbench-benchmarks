function [N1,TV,SG]=KMV_MODEL(S,EQ,F,r,TEND,N)

%% Document Title
% KMV-Merton model Probability of Default represented by  Jin-Chuan Duan, Genevi`eve Gauthier and
% Jean-Guy Simonato (2005)
% This code calculates the probability of default based on Moody’s KMV
% where firms equity follows European call option.
%% Author
% Author : Haidar Haidar University of Sussex Email: h.haidar@sussex.ac.uk
% Date: 3rd - April - 2010, homepage: http://www.maths.sussex.ac.uk/~hh56

%% Reference:  
% 1) On the Equivalence of the KMV and Maximum Likelihood Methods for
%    Structural Credit Risk Models by Jin-Chuan Duan, Genevi`eve Gauthier and
%    Jean-Guy Simonato 2005

%% Inputs

% S  : Vector of Share prices as a time series starts with times t=1,2,3.
% EQ : Number of outstanding shares
% F  : Total Liabilities
% r  : free interest rate
% TEND : Time horizontal in years
% N : Number of time steps

%% Accuracy
% NR_Acc : The accuracy of Newton Raphson method
% Sig_Acc : The accuracy of Sigma

%% Example
% [N1,T,SG]=KMV_MODEL(cumprod(((rand(1,100)-0.55)/10)+1),1,0.9,0.05,5,50)

%% OutPut
% <PD.fig>
% N1 : The Expected Probability of Default  
% TV : Time Horizontal for the correspoding probability of default
% SG : Asset Volatility

%% Code
%%%%%%%%%%%%
Sig_Acc=10^-7;
lm=length(S);
E=S*EQ;
% Scale the values
if E>1000
    E=E/10000;
    F=F/10000;
end

LS=log(S(2:end)./S(1:end-1));
h=length(E);
SGE=std(LS);
% SG : Asset Volatility to be computed, here is given an initial value.
SG=SGE*(E(1)/(E(1)+F));

TV=TEND/N:TEND/N:TEND;
for jkk=1:N
%     i=1;
    % TM is the Asset Volatility at the previous iteration 
    % TM is initialized at the first step
    TM=100;
    while abs(SG-TM)>Sig_Acc
        for j=1:lm
            % V(j) is the asset value at time step j
            V(j)=NRMethod(F,F,E(j),r,TV(jkk),SG);
        end
        % LR is the implied asset returns ( Log returns )
        LR=log(V(2:end)./V(1:end-1));
        R=mean(LR);
        TM=SG;
        SG=std(LR)*sqrt(h);
        % Mu is the expected return of the asset value
        Mu =h*R+0.5*SG^2;
%         i=i+1;
    end
    % SG % asset volatility
    d1=-(log(V(lm)/F(1))+(Mu -(0.5*SG^2))*TV(jkk))/(SG*sqrt(TV(jkk)));
    N1(jkk)=0.5*(1+erf(d1/sqrt(2)));
end

plot(TV,N1,'b')
xlabel('Time Horizontal in Years')
ylabel('Expected Probability of Default')
return

% Date: 3rd - April - 2010
% Author : Haidar Haidar
% University of Sussex
% Email: h.haidar@sussex.ac.uk
% Newton Raphson method

function [S]=NRMethod(S,E,c,r,T,sig)
NR_Acc=10^-7;
Tem=0;
k=1;
while abs(S-Tem)>NR_Acc
    d1=(log(S/E)+(r+(0.5*sig^2))*T)/(sig*sqrt(T));
    d2=d1-(sig*sqrt(T));
    f=c-S*0.5.*(1+erf(d1/sqrt(2)))+exp(-r*(T))*E*0.5*(1+erf(d2/sqrt(2)));
    df=-0.5.*(1+erf(d1/sqrt(2)));   % the derivative
    Tem=S;
    S=Tem-f/df;
    k=k+1;
end
return

