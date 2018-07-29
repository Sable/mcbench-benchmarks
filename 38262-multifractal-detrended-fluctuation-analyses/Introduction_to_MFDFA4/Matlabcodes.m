close all; clear all
load fractaldata.mat

%Matlab code 1-------------------------------------------
RW1=cumsum(whitenoise-mean(whitenoise));
RW2=cumsum(monofractal-mean(monofractal));
RW3=cumsum(multifractal-mean(multifractal));
plot1;

%Matlab code 2-------------------------------------------
RMS_ordinary=sqrt(mean(whitenoise.^2));
RMS_monofractal=sqrt(mean(monofractal.^2));
RMS_multifractal=sqrt(mean(multifractal.^2));
plot2;

%Matlab code 3-------------------------------------------
X=cumsum(multifractal-mean(multifractal));
X=transpose(X);
scale=1000;
m=1;
segments=floor(length(X)/scale);
for v=1:segments
    Idx_start=((v-1)*scale)+1;
    Idx_stop=v*scale;
    Index{v}=Idx_start:Idx_stop;
    X_Idx=X(Index{v});
    C=polyfit(Index{v},X(Index{v}),m);
    fit{v}=polyval(C,Index{v});
    RMS{1}(v)=sqrt(mean((X_Idx-fit{v}).^2));
end
plot3;

%Matlab code 4-------------------------------------------
F=sqrt(mean(RMS{1}.^2));

%Matlab code 5-------------------------------------------
X=cumsum(multifractal-mean(multifractal));
X=transpose(X);
scale=[16,32,64,128,256,512,1024];
m=1;
for ns=1:length(scale),
    segments(ns)=floor(length(X)/scale(ns));
    for v=1:segments(ns),
        Idx_start=((v-1)*scale(ns))+1;
        Idx_stop=v*scale(ns);
        Index{v,ns}=Idx_start:Idx_stop;
        X_Idx=X(Index{v,ns});
        C=polyfit(Index{v,ns},X(Index{v,ns}),m);
        fit{v,ns}=polyval(C,Index{v,ns});
        RMS{ns}(v)=sqrt(mean((X_Idx-fit{v,ns}).^2));
    end
    F(ns)=sqrt(mean(RMS{ns}.^2));
end

plot4;

%Matlab code 6-------------------------------------------
C=polyfit(log2(scale),log2(F),1);
H=C(1);
RegLine=polyval(C,log2(scale));
plot5;

%Matlab code 7-------------------------------------------
q=[-5,-3,-1,0,1,3,5];
for nq=1:length(q),
    qRMS{1}=RMS{1}.^q(nq);
    Fq(nq)=mean(qRMS{1}).^(1/q(nq));
end
Fq(q==0)=exp(0.5*mean(log(RMS{1}.^2)));
plot7;

%Matlab code 8-------------------------------------------
X=cumsum(multifractal-mean(multifractal));
X=transpose(X);
scale=[16,32,64,128,256,512,1024];
q=[-5,-3,-1,0,1,3,5];
m=1;
for ns=1:length(scale),
    segments(ns)=floor(length(X)/scale(ns));
    for v=1:segments(ns),
        Index=((((v-1)*scale(ns))+1):(v*scale(ns)));
        C=polyfit(Index,X(Index),m);
        fit=polyval(C,Index);
        RMS{ns}(v)=sqrt(mean((X(Index)-fit).^2));
    end
    for nq=1:length(q),
        qRMS{nq,ns}=RMS{ns}.^q(nq);
        Fq(nq,ns)=mean(qRMS{nq,ns}).^(1/q(nq));
    end
    Fq(q==0,ns)=exp(0.5*mean(log(RMS{ns}.^2)));
end

%Matlab code 9-------------------------------------------
for nq=1:length(q),
    C=polyfit(log2(scale),log2(Fq(nq,:)),1);
    Hq(nq)=C(1);
    qRegLine{nq}=polyval(C,log2(scale));
end
plot8;

%Matlab code 10------------------------------------------
tq=Hq.*q-1;

%Matlab code 11------------------------------------------
hq=diff(tq)./(q(2)-q(1));
Dq=(q(1:end-1).*hq)-tq(1:end-1);
plot9;

%Matlab code 12------------------------------------------
X=cumsum(multifractal-mean(multifractal));
X=transpose(X);
scale_small=[7,9,11,13,15,17];
halfmax=floor(max(scale_small)/2);
Time_index=halfmax+1:length(X)-halfmax;
m=1;
for ns=1:length(scale_small),
    halfseg=floor(scale_small(ns)/2);
    for v=halfmax+1:length(X)-halfmax;
        T_index=v-halfseg:v+halfseg;
        C=polyfit(T_index,X(T_index),m);
        fit=polyval(C,T_index);
        RMS{ns}(v)=sqrt(mean((X(T_index)-fit).^2));
    end
end


%Matlab code 13------------------------------------------
C=polyfit(log2(scale),log2(Fq(q==0,:)),1);
Regfit=polyval(C,log2(scale_small));
maxL=length(X);
for ns=1:length(scale_small);
    RMSt=RMS{ns}(Time_index);
    resRMS{ns}=Regfit(ns)-log2(RMSt);
    logscale(ns)=log2(maxL)-log2(scale_small(ns));
    Ht(ns,:)=resRMS{ns}./logscale(ns)+Hq(q==0);
end
plot12;

%Matlab code 14------------------------------------------
Ht_row=Ht(:);
BinNumb=round(sqrt(length(Ht_row)));
[freq,Htbin]=hist(Ht_row,BinNumb);
Ph=freq./sum(freq);
Ph_norm=Ph./max(Ph);
Dh=1-(log(Ph_norm)./-log(mean(scale)));
plot13;

%Matlab code 15------------------------------------------
scmin=16;
scmax=1024;
scres=19;
exponents=linspace(log2(scmin),log2(scmax),scres);
scale=round(2.^exponents);

%Example: MFDFA1-----------------------------------------
load fractaldata
scmin=16;
scmax=1024;
scres=19;
exponents=linspace(log2(scmin),log2(scmax),scres);
scale=round(2.^exponents);
q=linspace(-5,5,101);
m=1;
signal1=multifractal;
signal2=monofractal;
signal3=whitenoise;
[Hq1,tq1,hq1,Dq1,Fq1]=MFDFA1(signal1,scale,q,m,1);
[Hq2,tq2,hq2,Dq2,Fq2]=MFDFA1(signal2,scale,q,m,1);
[Hq3,tq3,hq3,Dq3,Fq3]=MFDFA1(signal3,scale,q,m,1);

%Example: MFDFA2-----------------------------------------
load fractaldata
scale=[7,9,11,13,15,17];
m=2;
signal1=multifractal;
signal2=monofractal;
signal3=whitenoise;
[Ht1,Htbin1,Ph1,Dh1] = MFDFA2(signal1,scale,m,1);
[Ht2,Htbin2,Ph2,Dh2] = MFDFA2(signal2,scale,m,1);
[Ht3,Htbin3,Ph3,Dh3] = MFDFA2(signal3,scale,m,1);
%---------------------------------------------------------









