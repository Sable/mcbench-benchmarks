function [idistr,ap000,ap010,ap100,ap110,alambda,nu,A,B,aC0,aC1,aC2,...
    aD1,aD2,sC0,sC1,sC2,sD1,sD2,PrecipThreshold,MarkovChainOrder]=...
    analyzer_order2_norad_no(filenamein,PrecipThreshold,idistr)
%
% THIS PROGRAM ANALYSES DAILY TIME SERIES OF PRECIPITATION AND MAX AND MIN
% TEMPERATURES.

% the preciptiation occurrence is generated using the second order markov
% chain and the parameters are not smoothed from 14 days to saily scale with
% this weather generator

% monthly matrices of daily precip are read in, starting in January
% feb 29 omitted. 
%
% The following matrices must be included in the matlab file named
% 'filenamein' (string):
%
% P = daily precipitation in mm in the matrix format [nyears x 365]
% Tmax = maximal daily temperature in C in the matrix format [nyears x 365]
% Tmin = minimal daily temperature in C in the matrix format [nyears x 365]
% yearT =  vector of years with Tdata
% yearP = vector of years with Precip data
% missing values must be -999
% 
% 'filenameout' is a string for the filename to which results will be
% written to (.mat).  This filename can be used by the generator for
% generation of synthetic data
% 'station_name' is a string for the station name for graphing purposes
%
% PrecipThreshold: amount of precipitation that is considered to determine 
% whether a given day is wet 
% idistr: 1=exponential, 2=gamma  (distribution function to be fitted to precip) 
% harm_order: order of harmonics used to fit the yearly distribution of the
% markov parameters and distribution functions.
%
%Indicate wich order was used to analyse the data.
%This is necessary to save this attributes in the output file.
%It will determine the generator order to be used.

MarkovChainOrder = 2;

load(filenamein);
%
% we start the analysis of the precipitation time series
%
% generate matrix of precip - no precip (PnP)
%
[Y,D]=size(P);      % years, days
PnP=zeros(Y,D);
[k]=find(P>PrecipThreshold);        % finds days with significant precipitation
PnP(k)=1;           % a value of 1 means that significant precipitation occured
%
% adjust precipitation to threshold: substract threshold to precipitation
% values so to be able to use the 1-parameter exponential funtion of
% 2-parameter gamma funtion.  The threshold will be added back by the
% generator

[k2]=find(P<=PrecipThreshold & P>0); 
P(k2)=0;
P(k)=P(k)-PrecipThreshold;
%
% put NaN for missing values instead of -999
%
[kn]=find(P<0);
PnP(kn)=NaN;
%
%  calculate transition state a00, a01, a10, a11 (Woolhiser and Pegram, 1979)
%
% matrix 'a' is a [4 365] matrix that contains the number of years over Y
% where a00 (line 1) a01 (line 2) a10 (line 3) and a11 (line 4) was
% observed.  As such, the sum of each column of matrix 'a' is equal to Y
% (in fact it is equal to Y-Days_without_data)

[a] = transition2(PnP,Y,D);
%
% calculate average p00 and p10 using maximum likelihood estimator
% on 14-days periods (Woolhiser and Pegram, 1979)
%
n14=round(D/14);
for i=1:n14
   A000(i)=sum(a(1,14*(i-1)+1:14*i));
   A001(i)=sum(a(2,14*(i-1)+1:14*i));
 
   A010(i)=sum(a(3,14*(i-1)+1:14*i));
   A011(i)=sum(a(4,14*(i-1)+1:14*i));
  
   A100(i)=sum(a(5,14*(i-1)+1:14*i));
   A101(i)=sum(a(6,14*(i-1)+1:14*i));
 
   A110(i)=sum(a(7,14*(i-1)+1:14*i));
   A111(i)=sum(a(8,14*(i-1)+1:14*i));
end

ap000=A000./(A001+A000);
ap001=1-ap000;

ap010=A010./(A010+A011);
ap011=1-ap010;

ap100=A100./(A101+A100);
ap101=1-ap100;

ap110=A110./(A110+A111);
ap111=1-ap110;

%
t=1:n14;
t=t';
T14=n14/(2*pi);
%
n=1:D;
T=D/(2*pi);
%
%  we now process the precipitation amounts
%  an exponential distribution (Richardson, 1981), or a 2-parameter Gamma
%  distribution is usede
%
%  we first create a precipitation matrice containing positive
% precipitation amounts when precipitation has been recorded and
% zero values (when there is no precipitation or when data is missing)
% otherwise.  This requires to replace NaN values in PnP matrice
% by 0 values.  Position of NaN values in vector kn
%
PnP(kn)=0;
PP=P.*PnP;
sPtot=sum(PP); %total precipitation amounts on given calendar day for all years analysed
stot=sum(PnP); % # of days with precip. on a given calendar day for all years analysed
sPtot2=sum(PP.^2);
%
%  select exponential or gamma distribution
%
if idistr == 1   % exponential distribution
    %
    %  mle of parameter lambda of the exponential distribution taken over 14-day periods
    %
    for i=1:n14
        alambda(i)=sum(stot(14*(i-1)+1:14*i))/sum(sPtot(14*(i-1)+1:14*i));
    end
    %
    nu=-999;       % just so that the variable is defined to avoid errors in the SAVE portion

elseif idistr == 2   %  2-parameter gamma distribution
   
    kzero=find(PP==0);
    PP(kzero)=1e-20;
    logPP=log(PP);
    logPP(kzero)=0;
    %
    %  estimates of the lambda and nu parameters of the Gamma
    %  distribution taken over 14-day periods
    %
    slogPtot=sum(logPP);
    for i=1:n14
        aa(i)=sum(stot(14*(i-1)+1:14*i));
        xmean(i)=sum(sPtot(14*(i-1)+1:14*i))/aa(i);
        xvar(i)=(sum(sPtot2(14*(i-1)+1:14*i))-aa(i)*xmean(i)^2)/(aa(i)-1);
        meanlogx(i)=sum(slogPtot(14*(i-1)+1:14*i))/aa(i);
    end
    logxmean=log(xmean);
    y=logxmean-meanlogx;
    
    % MLM
    
        nu=(1+sqrt(1+4*y/3))./(4*y);
        nu=(aa-3).*nu./aa;
   
    alambda=nu./xmean;
end
% 
n=n';
%
% we start the analysis of the climatic (temperature, radiation) time series
%
%
%  PnP:  matrix with elements = 1 for wet days only (=0 for dry and missing
%  days)
%
%  PnPm1:  matrix with elements = 1 for dry days only (=0 when wet and
%  missing days).
%
PnPm1=1-PnP;  % here elements = 1 include dry and missing precipitation days
PnPm1(kn)=0;   % missing precipitation days are removed from the matrix
%
%  make sure that all matrices P and Tmin, Tmax and Rad are the same size

% take the years that are common only

[int_vec,ind_P,ind_T]=intersect(yearP,yearT);

P=P(ind_P,:);
PnP=PnP(ind_P,:);
PnPm1=PnPm1(ind_P,:);
Tmin=Tmin(ind_T,:);
Tmax=Tmax(ind_T,:);
[Y,D]=size(P);
%
% add 0.0001 to all temperatures and radiations equal to zero.
% this is required to efficiently and correctly
% calculate the mean and standard deviations
%
x=find(Tmax==0);
Tmax(x)=0.0001;
x=find(Tmin==0);
Tmin(x)=0.0001;
%
% separate the matrices Tmin, Tmax and Rad into wet and dry components
%
Tmaxw=Tmax.*PnP;
Tminw=Tmin.*PnP;
%
Tmaxd=Tmax.*PnPm1;
Tmind=Tmin.*PnPm1;
%
% calculate daily means and standard deviations for Tmaxw, Tmaxw, etc..
% missing values (-999) should not be included in the analysis.  A matrix
% of zeros and ones is created for each climate variable (Tmax, Tmin, Rad)
% to identify missing values.  Missing values are replaced by 0.
%
Mtmax=ones(Y,D);  Mtmin=Mtmax; 
mx=find(Tmax==-999);  mn=find(Tmin==-999); 
Mtmax(mx)=0;  Mtmin(mn)=0; 
Tmaxw(mx)=0;  Tmaxd(mx)=0;
Tminw(mn)=0;  Tmind(mn)=0;
%
% daily averages and standard deviations are calculated
%la fonction stats2.m est utilis?a la place de stats.m pour éviter les
%valeurs égales a NaN.(Annie 2004)
v=ones(Y,1);
[aTmaxw,sTmaxw] = stats(Tmaxw,PnP.*Mtmax,v);
[aTminw,sTminw] = stats(Tminw,PnP.*Mtmin,v);
[aTmaxd,sTmaxd] = stats(Tmaxd,PnPm1.*Mtmax,v);
[aTmind,sTmind] = stats(Tmind,PnPm1.*Mtmin,v);
%
% smooth the series using Fourier transform with 2 harmonics (Richardson, 1981)
%
%  means
%
X=[ones(size(n)) sin(n/T)  cos(n/T) sin(2*n/T) cos(2*n/T)];
[aTmaxwest2,aC0(1),aC1(1),aC2(1),aD1(1),aD2(1)]=fourier(X,aTmaxw,n,T);
[aTminwest2,aC0(2),aC1(2),aC2(2),aD1(2),aD2(2)]=fourier(X,aTminw,n,T);
[aTmaxdest2,aC0(3),aC1(3),aC2(3),aD1(3),aD2(3)]=fourier(X,aTmaxd,n,T);
[aTmindest2,aC0(4),aC1(4),aC2(4),aD1(4),aD2(4)]=fourier(X,aTmind,n,T);
%
% standard deviations
%
[sTmaxwest2,sC0(1),sC1(1),sC2(1),sD1(1),sD2(1)]=fourier(X,sTmaxw,n,T);
[sTminwest2,sC0(2),sC1(2),sC2(2),sD1(2),sD2(2)]=fourier(X,sTminw,n,T);
[sTmaxdest2,sC0(3),sC1(3),sC2(3),sD1(3),sD2(3)]=fourier(X,sTmaxd,n,T);
[sTmindest2,sC0(4),sC1(4),sC2(4),sD1(4),sD2(4)]=fourier(X,sTmind,n,T);
%
%  plot the results
%
aTmaxwest2=aTmaxwest2';
aTmaxdest2=aTmaxdest2';
sTmaxwest2=sTmaxwest2';
sTmaxdest2=sTmaxdest2';
aTminwest2=aTminwest2';
aTmindest2=aTmindest2';
sTminwest2=sTminwest2';
sTmindest2=sTmindest2';
%
% calculate the residuals using the smoothed means and standard deviations
% one series of residuals per variables
%
[resTmax]=residual(Tmaxw,Tmaxd,aTmaxwest2,aTmaxdest2,sTmaxwest2,sTmaxdest2,Y,D);
[resTmin]=residual(Tminw,Tmind,aTminwest2,aTmindest2,sTminwest2,sTmindest2,Y,D);
%
% calculate the covariance matrix M0 (lag 0) and M1 (lag 1)
%
l=Y*D;
lag=0;
M0=covar2(resTmax,resTmin,lag,l);
lag=1;
M1=covar2(resTmax,resTmin,lag,l);
%
% calculate matrices A and C=BB' (Richardson (1981))
%
A=M1*inv(M0);
C=M0-M1*inv(M0)*M1';

% the correlation matrix has to be positive definite. When dealing with 
% measured data, observational errors, biases and missing data all 
% contaminate the true correlation and in some cases this results in 
% negative eigenvalues and the cholesky decomposition is not possible.
% thus, if the eigenvalues are not positive, simple set it close to zero.
[V,D] = eig(C);

i=find(D<0);      % find eigenvalues smaller than 0

if length(i)>=1 
        D(i)=0.000001;    % set the negative eigenvalues close to zero
        C=(V*D*inv(V));   % reconstruct matrix
end

%
%  produce a diagonal matrix lambda whose elements are eigenvalues of C
%  because C is symmetric (M0 is symmetric) and positive definite (elements
% in diagonal are positive), the eigenvalues will all be positive and real
%
lambda=diag(eig(C));
%
%  we have lambda = B'B (Matalas, 1967).  Therefore, the Cholesky factorisation
%  can be used to obtain B
%
B=chol(lambda);
