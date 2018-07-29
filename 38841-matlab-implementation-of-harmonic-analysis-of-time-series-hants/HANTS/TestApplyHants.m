%%
disp('Loading Data ...')
ncid=netcdf.open('./sTs.nc','NC_NOWRITE');
Ts=netcdf.getVar(ncid,0);
% Data must be dimensioned [time,lat,lon]
Ts=permute(Ts,[3,2,1]);

%%
nb=366;
nf=3;
low=250;
high=400;
fet=2.0;
dod=1;
delta=0.1;
HiLo='none';

%%
disp('Smoothing and filling the missing data ...')
[Ts_HANTS, amp, phi]=ApplyHants(Ts,nb,nf,fet,dod,HiLo,low,high,delta);

% Note: now you can store only amp and phi to reconstruct Ts_HANTS.
%       This can be used as sort of lossless image compression method.
% To reconstruct Ts_HANTS using amp and phase issue:
% Ts_HATNS_Recon=ReconstructImage(amp,phi,nb);
%% FillValue/MissingValue=-2
Ts(Ts==-2)=NaN;
line=15;
sample=15;

plot(Ts(:,line,sample),'b.');
hold on
plot(Ts_HANTS(:,line,sample),'r.');
xlim([1 366]);
xlabel('Day of Year (2008)')
ylabel('Surface Temperature (K)')
title('Surface Temperature - MODIS, WA');
legend('Original Data Set','Smoothed Data Set using HANTS','Location','South')

