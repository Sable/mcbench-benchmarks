%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% MANN-KENDALL TEST MODIFIED by Hamed and Rao, (1998) %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[H,p_value]=Mann_Kendall_Modified(V,alpha)
%%%%%%%%%%%%%%%%%
%%% Performs Mann-Kendall test modified to account for autocorrelation on the time series 
%%% The null hypothesis of trend
%%% absence in the vector V is tested,  against the alternative of trend. 
%%% The result of the test is returned in H = 1 indicates
%%% a rejection of the null hypothesis at the alpha significance level. H = 0 indicates
%%% a failure to reject the null hypothesis at the alpha significance level.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INPUTS
%V = time series [vector]
%alpha =  significance level of the test [scalar]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% From Matlab Help %%%%%%%%%%%%%%%
%The significance level of a test is a threshold of probability a agreed
%to before the test is conducted. A typical value of alpha is 0.05. If the p-value of a test is less than alpha,
%the test rejects the null hypothesis. If the p-value is greater than alpha, there is insufficient evidence 
%to reject the null hypothesis. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OUTPUTS
%H = test result [1] Reject of Null Hypthesis [0] Insufficient evidence to reject the null hypothesis
%p_value = p-value of the test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% From Matlab Help %%%%%%%%%%%%%%%
%The p-value of a test is the probability, under the null hypothesis, of obtaining a value
%of the test statistic as extreme or more extreme than the value computed from
%the sample.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% References 
%Mann, H. B. (1945), Nonparametric tests against trend, Econometrica, 13, 
%245– 259.
%Kendall, M. G. (1975), Rank Correlation Methods, Griffin, London.
%Hamed, K. H., and A. R. Rao (1998), A modified Mann-Kendall trend test
%for autocorrelated data, J. Hydrol., 204, 182–196.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Simone Fatichi -- simonef@dicea.unifi.it
%   Copyright 2009
%   $Date: 2009/10/03 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
V=reshape(V,length(V),1); 
alpha = alpha/2; %
n=length(V);
i=0; j=0; S=0;
for i=1:n-1
    for j= i+1:n
        S= S + sign(V(j)-V(i));
    end
end
VarSo=(n*(n-1)*(2*n+5))/18;
%%%%%%%%%%%%%%%%%%%%%%%%
ANSW = 3;  %%% It depends on computational time
switch ANSW
    case 1
        xx=1:n;
        aa=polyfit(xx,V,1);
        yy=aa(1,1)*xx+aa(1,2);
        V=V-yy';
    case 2
        [b]=Sen_Slope(V);
        xx=1:n;
        yy=b*xx+ (mean(V) -(b*n)/2);
        V=V-yy';
    case 3
        V=detrend(V);
end
%%%%%%%%%%%%%%%%%%%%%%%%%
[V,I]=sort(V); %% I = ranks
[Acx,lags,Bounds]=autocorr(I,n-1);
%[Acx,lags]=xcov(I,I,n-1,'coeff'); %%
%Acx=Acx(n:end);
ros=Acx(2:end); %% Autocorrelation Ranks
i=0; sni=0;
for i=1:n-2
    if ros(i)<= Bounds(1) && ros(i) >= Bounds(2)
        sni=sni;
    else
        sni=sni+(n-i)*(n-i-1)*(n-i-2)*ros(i);
    end
end
nns=1+(2/(n*(n-1)*(n-2)))*sni;
VarS=VarSo*(nns);
StdS=sqrt(VarS);
if S >= 0
   Z=((S-1)/StdS)*(S~=0);
else
   Z=(S+1)/StdS;
end
p_value=2*(1-normcdf(abs(Z),0,1)); 
pz=norminv(1-alpha,0,1); 
H=abs(Z)>pz; %
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Trend Magnitude ---> Sen (1968)%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[b]=Sen_Slope(X)
i=0; % 
n=length(X);
V= zeros(1,(n^2-n)/2);
for j=2:n
    for l=1:j-1
        i=i+1;
        V(i)=(X(j)-X(l))/(j-l);
    end
end
b=median(V);
end


