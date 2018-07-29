% this program is designed to correct the monthly variability for weather
% generator generated daily precip according to the monthly precip generated
% by FFT using a simple linear relationship

function [monthly_corrected_precip]=monthly_precip_correction(filenameout)
% load WG generated data
load(filenameout)
n=size(gP,1);

% load FFT generated monthly precip
monthly_FFT=zeros(n,12);
load('Pnew1')
monthly_FFT(:,1)=Pnew';
load('Pnew2')
monthly_FFT(:,2)=Pnew';
load('Pnew3')
monthly_FFT(:,3)=Pnew';
load('Pnew4')
monthly_FFT(:,4)=Pnew';
load('Pnew5')
monthly_FFT(:,5)=Pnew';
load('Pnew6')
monthly_FFT(:,6)=Pnew';
load('Pnew7')
monthly_FFT(:,7)=Pnew';
load('Pnew8')
monthly_FFT(:,8)=Pnew';
load('Pnew9')
monthly_FFT(:,9)=Pnew';
load('Pnew10')
monthly_FFT(:,10)=Pnew';
load('Pnew11')
monthly_FFT(:,11)=Pnew';
load('Pnew12')
monthly_FFT(:,12)=Pnew';

% calculate the monthly precip for the generated data
monthly_generated=zeros(n,12);
for i=1:n
    monthly_generated(i,1)=sum(gP(i,1:31));
    monthly_generated(i,2)=sum(gP(i,32:59));
    monthly_generated(i,3)=sum(gP(i,60:90));
    monthly_generated(i,4)=sum(gP(i,91:120));
    monthly_generated(i,5)=sum(gP(i,121:151));
    monthly_generated(i,6)=sum(gP(i,152:181));
    monthly_generated(i,7)=sum(gP(i,182:212));
    monthly_generated(i,8)=sum(gP(i,213:243));
    monthly_generated(i,9)=sum(gP(i,244:273));
    monthly_generated(i,10)=sum(gP(i,274:304));
    monthly_generated(i,11)=sum(gP(i,305:334));
    monthly_generated(i,12)=sum(gP(i,335:365));
end

% calculate the ratio of FFT generated data to WG generated data (monthly ratio)
monthly_ratio=zeros(n,12);
for i=1:n
    for j=1:12
        if monthly_generated(i,j)==0
            monthly_generated(i,j)=monthly_FFT(i,j);
        else monthly_ratio(i,j)=monthly_FFT(i,j)/monthly_generated(i,j);
        end
    end
end
monthly_ratio=monthly_ratio';
monthly_ratio=reshape(monthly_ratio,[],1);

% extend the above monthly ratio to daily scale,the data in each month are the same
monthly_ratio2=zeros(365*n,1);
j=0;
for i=0:365:365*n-1
    monthly_ratio2(i+1:i+31,1)=monthly_ratio(j+1,1);
    monthly_ratio2(i+32:i+59,1)=monthly_ratio(j+2,1);
    monthly_ratio2(i+60:i+90,1)=monthly_ratio(j+3,1);
    monthly_ratio2(i+91:i+120,1)=monthly_ratio(j+4,1);
    monthly_ratio2(i+121:i+151,1)=monthly_ratio(j+5,1);
    monthly_ratio2(i+152:i+181,1)=monthly_ratio(j+6,1);
    monthly_ratio2(i+182:i+212,1)=monthly_ratio(j+7,1);
    monthly_ratio2(i+213:i+243,1)=monthly_ratio(j+8,1);
    monthly_ratio2(i+244:i+273,1)=monthly_ratio(j+9,1);
    monthly_ratio2(i+274:i+304,1)=monthly_ratio(j+10,1);
    monthly_ratio2(i+305:i+334,1)=monthly_ratio(j+11,1);
    monthly_ratio2(i+335:i+365,1)=monthly_ratio(j+12,1);
    j=j+12;
end

% generate the years, months and days
daily_generated=zeros(365*n+1,6); 
for i=1:366
    daily_generated(i,:)=datevec(i);
end
% delete the 60th row because it is the Feb 29th
daily_generated(60,:)=[];
% delete the fifthly and sixthly columns
daily_generated(:,6)=[];
daily_generated(:,5)=[];
% extend the date of the first to all years
j=1;
for i=366:365:365*n
    daily_generated(i:i+365-1,:)=daily_generated(1:365,:);
    daily_generated(i:i+365-1,1)=j;
    j=j+1;
end

% correct the WG generatd data
[n,m]=size(gP);
gP=gP';
j=1;
for i=1:365:m*n
    daily_generated(i:i+364,4)=gP(:,j);
    j=j+1;
end

monthly_adjust=zeros(size(daily_generated));
monthly_adjust(:,1:3)=daily_generated(:,1:3);
for i=1:365*n
    monthly_adjust(i,4)=daily_generated(i,4)*monthly_ratio2(i,1);
end
monthly_corrected_precip=monthly_adjust;
save('monthly_corrected_precip','monthly_corrected_precip')


        

