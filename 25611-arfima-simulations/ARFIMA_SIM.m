%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Z] = ARFIMA_SIM(N,F,O,d,stdx,er)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%The code performs the simulation of time series with autoregressive 
%fractionally integrated moving average (ARFIMA) models that generalize 
%ARIMA (autoregressive integrated moving average) and ARMA autoregressive
%moving average models.  ARFIMA models allow non-integer values of the
%differencing parameter and are useful in modeling time series with long memory.
%The model is generally represented  as ARFIMA(p,d,q) model where d is the differencing parameter 
%and p and q are the order of the autoregressive and moving average parts of the model respectively. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% INPUTS
%%%->N =  # % Length of the time series we would like to generate  
%%%->F = [ F1 F2 F3 .... ] % Parameters of the AR model, length(F) is the order p. Default p = 0
%%%->O = [ O1 O2 O3 .... ] % Parameters of the MA model, length(O) is the order q. Default q = 0   
%%%->d = # ; % Fractionally differencing parameter, default d = 0 
%%%->stdx = % Optional input: parameter to force the standard deviation of the
%output time series. Impose std(Z)==stdx    
%%%-->er = % Optional input: predefined time seres of white noise  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% THE ARFIMA PROCESS IS DEFINED AS:  
%%%% F(B)[(1-B)^d]Z=O(B)er 
%%%% F(B)Z=[(1-B)^-d]O(B)er
%%%%%%% where B is the backshift operator,
%%%% F(B)= 1+ B F1 + B^2 F2 ... + B^p Fp --> AR PART 
%%%% O(B)= 1+ B O1 + B^2 O2 ... + B^q Oq --> MA PART  
%%%% er = white noise, it can be specified as an input 
%%% Note that F(B) and O(B) are both defined with plus sign as in the "armax" function of matlab 
%and in  Box et al., (1994).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% REFERENCES 
%Box, G., Jenkins, G. M. and  Reinsel G. C. (1994) 
%Time Series Analysis: Forecasting and Control, third edition. Prentice-Hall.
%Beran, J. (1994), Statistic for Long-Memory Processes, Chapman and Hall,
%New York.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% OUTPUTS
%-->Z =  Time series simulated with the ARFIMA model 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% EXAMPLES 
%%% White noise 
%[Z] = ARFIMA_SIM(N); 
%%% AR(1) model 
%[Z] = ARFIMA_SIM(N,[F1]); 
%%% MA(1) model 
%[Z] = ARFIMA_SIM(N,[],[O1])
%%% ARMA(2,2) model 
%[Z] = ARFIMA_SIM(N,[F1,F2],[O1,O2])
%%% ARFIMA(0,d,0)
%[Z] = ARFIMA_SIM(N,[],[],d)
%%% ARFIMA(1,d,1)
%[Z] = ARFIMA_SIM(N,[F1],[O1],d)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Simone Fatichi -- simonef@dicea.unifi.it
%   Copyright 2009
%   $Date: 2009/10/19 $
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%inizialization 
X=zeros(1,N); Y=zeros(1,N); Z=zeros(1,N); 
%%%% FI(B)[(1-B)^d]Z=O(B)e 
%%%% FI(B)Z=[(1-B)^-d]O(B)e
%%%% FI(B)= 1+ B F1 + B^2 F2 ... 
%%%% O(B) = 1+ B O1 + B^2 O2 ... 
switch nargin
    case 1
        d=0;
        F=[];
        O=[];
        t=0;
        stdx=NaN;
    case 2
        d = 0;
        O =[];
        t = 0;
        stdx=NaN;
    case 3
        d = 0;
        t=0;
         stdx=NaN;
    case 4
        t=0;
         stdx=NaN;
    case 5
        t=0;
    case 6
        t=1;
    otherwise
        msgbox('ERROR: Not enough or too much input arguments')
        Z=[];
        return 
end
e=normrnd(0,1,N,1);
if t==1
    e=er;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(O) && isempty(F) && (d==0)
    Z=e; 
    return
end 
%%%%% N =length
MA_ord=length(O);
AR_ord=length(F);
%%%%%%%%%%%% Computing part: MA(q)
t=0;
if MA_ord >= 1
    for t=1:N
        j=0;map=0;
        for j=1:MA_ord
            if t > j
                map = map + O(j)*e(t-j);
            end
        end
        X(t)= e(t)+ map;
    end
else
    X=e;
end
t=0;
%%%%%%%%%%% Computing part: d
if d == 0
    Y=X;
else
    infi =100; s=0;
    for s=0:infi
        %b(s+1)=((-1)^s)*gamma(-d+1)./(gamma(s+1)*gamma(-d-s+1));
        b(s+1)=gamma(s+d)/(gamma(s+1)*gamma(d));
    end
    for t=1:N
        Y(t)=0;
        for s=0:infi
            if t > s
                Y(t)= Y(t)+ b(s+1)*X(t-s);
            end
        end
    end
end
%%%%%%%%%%%%% Computing part: AR(p)
t  = 0;
if AR_ord >= 1
    for t=1:N
        j=0; arp=0;
        for j=1:AR_ord
            if t > j
                arp = arp - F(j)*Z(t-j);
            end
        end
        Z(t)= Y(t)+ arp;
    end
else
    Z=Y;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Z=Z';
if not(isnan(stdx))
    Z=Z*stdx/std(Z);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

