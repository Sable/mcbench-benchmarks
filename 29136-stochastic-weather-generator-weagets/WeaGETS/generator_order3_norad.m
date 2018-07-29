function generator_order3_norad(filenameout,GeneratedYears,TempScheme,idistr,...
    parp0000,parp0010,parp0100,parp0110,parp1000,parp1010,parp1100,parp1110,...
    parlbd,parnu,A,B,aC0,aC1,aC2,aD1,aD2,sC0,sC1,sC2,sD1,sD2,PrecipThreshold,...
    MarkovChainOrder)
%
%  THIS PROGRAM GENERATES DAILY TIME SERIES OF PRECIPITATION, MAX AND MIN
%  TEMPERATURES. PARAMETERS OF THE MODEL HAVE BEEN CALCULATED BY THE
%  WEATHER ANALYZER PROGRAM. A RANDOM GENERATOR APPROACH IS USED TO CREATE
%  SYNTHETIC TIME SERIES
%
% the preciptiation occurrence is generated using the third order markov
% chain and the parameters are smoothed from 14 days to daily scale with
% this weather generator
%
% 'filenameout' is the filename (string) to save the generated variables
% gP, gTmax, gTmin
%
Y=GeneratedYears;
h = waitbar(0,'Initialisation...');

A=A';
B=B';
waitbar(0.1,h);
%
% generation of time series
%
% time series for precipitation
%
%  create vectors of daily p00, p10, lbd values from Fourier series
%
day=1:365;
tot=365*Y;
t=1:tot;
T=365/(2*pi);
waitbar(0.2,h);

[p0000]=fseries(parp0000,t,T);
p0001=1-p0000;
[p0010]=fseries(parp0010,t,T);
p0011=1-p0010;

waitbar(0.35,h);

[p0100]=fseries(parp0100,t,T);
p0101=1-p0100;
[p0110]=fseries(parp0110,t,T);
p0111=1-p0110;

waitbar(0.5,h);

[p1000]=fseries(parp1000,t,T);
p1001=1-p1000;
[p1010]=fseries(parp1010,t,T);
p1011=1-p1010;

waitbar(0.65,h);

[p1100]=fseries(parp1100,t,T);
p1101=1-p1100;
[p1110]=fseries(parp1110,t,T);
p1111=1-p1110;

waitbar(0.8,h);
%
% add one element to verctors p00, p01, p10 and p11 to avoid put an if
% statement in the loop to generate time series of wet dry days
%
p0000(tot+1)=0;
p0010(tot+1)=p0000(tot+1);
p0100(tot+1)=p0000(tot+1);
p0110(tot+1)=p0000(tot+1);
p1000(tot+1)=p0000(tot+1);
p1010(tot+1)=p1000(tot+1);
p1100(tot+1)=p1000(tot+1);
p1110(tot+1)=p1000(tot+1);
[lbd]=fseries(parlbd,t,T);
if idistr == 2
    [nu]=fseries(parnu,t,T);
end
waitbar(1,h);
close(h);
%
% generate time series of dry (X=0) and wet (X=1) days
% pn is the marginal distribution of X on day n
%
% assume that day 0 is dry.  state=0 when day is dry,  state=1 when day is wet
%
% loop to generate time series
%
n=Y*365;

markov=zeros(1,n);
markov(1)=0;
markov(2)=0;
markov(3)=0;

h = waitbar(0,'Generation of precipitation occurrence...');
wbt=round(n/100);

for i=1:n-3;
    Ru=rand(1);
            if markov(i)==0&markov(i+1)==0&markov(i+2)==0;
                Pr=p0000(i);
            elseif markov(i)==0&markov(i+1)==0&markov(i+2)>0;
                Pr=p0010(i);
            elseif markov(i)==0&markov(i+1)>0&markov(i+2)==0;
                Pr=p0100(i);;
            elseif markov(i)==0&markov(i+1)>0&markov(i+2)>0;
                Pr=p0110(i);
            elseif markov(i)>0&markov(i+1)==0&markov(i+2)==0;
                Pr=p1000(i);
            elseif markov(i)>0&markov(i+1)==0&markov(i+2)>0;
                Pr=p1010(i);
            elseif markov(i)>0&markov(i+1)>0&markov(i+2)==0;
                Pr=p1100(i);
            elseif markov(i)>0&markov(i+1)>0&markov(i+2)>0;
                Pr=p1110(i);
            end

    % establish if day i is dry or wet
   if Ru <= Pr;
      % dry day
      markov(i+3)=0;
   else
      % wet day
      markov(i+3)=1;
   end
   if i/wbt - round(i/wbt) == 0   % update waitbar at every 100th interval
       waitbar(i/n,h);
   end   
end

close(h);
clear p0000 p0010 p0100 p0110 p1000 p1010 p1100 p1110;
clear p0001 p0011 p0101 p0111 p1001 p1011 p1101 p1111;

X=markov;
XX=find(X==1);
mat=XX;
nw=length(XX);

%
% generate time series of precipitation amounts
%
tol=0.00001;    % tolerance criteria for iteration
r=zeros(1,n);
rr=zeros(1,n);

h = waitbar(0,'Generation of precipitation quantity...');
wbt=round(nw/100);

if idistr == 1
    
%     assuming exponential distribution
    
    for i=1:nw
       P=rand(1);
       r(XX(i))=-log(1-P)/lbd(XX(i));  
       if i/wbt - round(i/wbt) == 0   % update waitbar every 1/100th
            waitbar(i/(nw*1.1),h);  % waitbar at 90% after this step
       end
    end

else   
    %
    % assuming 2-parameter gamma distribution
    %    
    for i=1:nw  % for each wet day, draw a random number and get precip using
                % inverse of gamma CDF
       Px=rand(1);   
       r(XX(i))=gaminv(Px,nu(XX(i)),1/lbd(XX(i)));

       if i/wbt - round(i/wbt) == 0   % update waitbar every 1/100th
           waitbar(i/(nw*1.1),h);      % waitbar at 90% after this step
       end     
    end
end

clear lbd;
%
%  time series of min temperature, max temperature and solar radiation
%
%  we first generate the fourier estimates of average and standard deviations
%  of the time series
%
for j=1:4
   ay(j,:)=aC0(j)+aC1(j)*sin(t/T+aD1(j))+aC2(j)*sin(2*t/T+aD2(j));
   sy(j,:)=sC0(j)+sC1(j)*sin(t/T+sD1(j))+sC2(j)*sin(2*t/T+sD2(j));
    waitbar(0.9+j*0.025,h);
end
clear t;
%
%  procedure is started by assuming that the residuals are equal to 0
%  random component eps is normally distributed N(0,1)
%
res=[0; 0];
ksi=zeros(2,n);   % fbri7

close(h);
h = waitbar(0,'Generation of Tmin, Tmax...');
wbt=round(n/100);

for i=1:n
   eps=randn(2,1);
   res=A*res+B*eps;
   ksi(:,i)=res;
   if i/wbt - round(i/wbt) == 0   % update waitbar every 1/100th
       waitbar(i/(n*1.33),h);          % waitbar at 75% when this step is over
   end
end
%
% the means and standard deviations obtained by Fourier time series are conditioned
% on the wet or dry status of the day determined by using the Markov chain model
%
v=ones(2,1);
XX=kron(v,X);
waitbar(0.78,h);
clear X;

cay=XX.*ay(1:2,:)+(1-XX).*ay(3:4,:);
waitbar(0.83,h);
clear ay;
csy=XX.*sy(1:2,:)+(1-XX).*sy(3:4,:);
waitbar(0.86,h);
clear sy XX;
%
if TempScheme==1;
    % the daily values of the three weather variables are found by multiplying the
    % residuals by the standard deviation and adding the mean
    %
    Xp=ksi.*csy+cay;
    clear cay csy ksi;
    Tmax=Xp(1,:);
    Tmin=Xp(2,:);
    clear Xp;
    % insure that Tmin is always smaller than Tmax (diff arbitrarily set up at 1)
    t0=find(Tmax-Tmin < 1);
    Tmin(t0)=Tmax(t0)-1;
elseif TempScheme==2;
    % the Tmax and Tmin are generated conditioned on each other (Jie Chen modified)
    % the smaller standard deviation of Tmax or Tmin is used as a base, and the
    % other parameter is generated conditioned on the chosen parameter. If the
    % standard deviation of Tmax is larger than or equal to the standard
    % deviation of Tmin, daily temperatures are generated by:
    % Tmin=Mean(min)+Std(min)*rand
    % Tmax=Tmin+(Mean(max)-Mean(min))+(Std(max)^2-Std(min)^2)^0.5*rand
    % If the standard deviation of Tmax is less than those of Tmin, daily
    % temperatures are genareted by:
    % Tmax=Mean(max)+Std(max)*rand
    % Tmin=Tmax-(Mean(max)-Mean(min))-(Std(min)^2-Std(max)^2)^0.5*rand

    for i=1:length(ksi)
        if csy(1,i)>=csy(2,i)
            Xp(2,i)=ksi(2,i)*csy(2,i)+cay(2,i);
            Xp(1,i)=ksi(1,i)*(csy(1,i)^2-csy(2,i)^2)^(1/2)+(cay(1,i)-cay(2,i))+Xp(2,i);
        else
            Xp(1,i)=ksi(1,i)*csy(1,i)+cay(1,i);
            Xp(2,i)=ksi(2,i)*(csy(2,i)^2-csy(1,i)^2)^(1/2)-(cay(1,i)-cay(2,i))+Xp(1,i);
        end
    end

    % range control the Tmin, insure that Tmin is always small than Tmax
    for i=1:length(ksi)
        if Xp(1,i)<=Xp(2,i)
            Xp(2,i)=Xp(1,i)-abs(Xp(1,i))*0.2;
        end
    end 
    Tmax=Xp(1,:);
    Tmin=Xp(2,:);
end

waitbar(0.9,h);
%
% store results in matrices
%
gP=reshape(r,365,Y);
gP=gP';
clear r;
waitbar(0.93,h);

jj=find(gP>0);   % add precipitation threshold
gP(jj)=gP(jj)+PrecipThreshold;
clear jj;

gTmax=reshape(Tmax,365,Y);
gTmax=gTmax';
waitbar(0.96,h);
clear Tmax;
gTmin=reshape(Tmin,365,Y);
gTmin=gTmin';  
clear Tmin;
%
% plot the first year results
%
figure
subplot(2,1,1)
bar(day,gP(1,:))
ylabel('daily precip. mm')
titre=['Generated daily precip of the first year'];
title(titre)
subplot(2,1,2)
plot(day,gTmax(1,:),day,gTmin(1,:),'r-')
ylabel(' air temp,oC')
titre=['Generated daily Tmax and Tmin of the first year'];
title(titre)
legend('Tmax','Tmin','Location','Best')
%
% store results in files
%
save(filenameout,'gP','gTmax','gTmin');    % results stores in matrices [nYears 365]

waitbar(1,h);

close(h);

