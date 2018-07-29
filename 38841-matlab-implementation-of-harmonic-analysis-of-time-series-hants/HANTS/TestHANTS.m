%% Simple Data Set
y= [5.0,  2.0,  5.0, 10.0, 12.0, 18.0, 20.0, 23.0, 27.0, 	...
    30.0, 40.0, 60.0, 66.0, 70.0, 90.0,120.0,160.0,190.0,	...
	105.0,210.0,104.0,200.0, 90.0,170.0, 50.0,120.0, 80.0,	...
	60.0, 50.0, 40.0, 30.0, 28.0, 24.0, 20.0, 15.0, 10.0 ];
y=y';

%%
ni=36;
nb=36;
nf=3;
ts=1:36;
low=0.0;
high=255;
fet=5.0;
dod=1;
delta=0.1;
Opt.FirstRun=true;

%%
[amp_none,phi_none,yr_none]=HANTS(ni,nb,nf,y,ts,'none',low,high,fet,dod,delta);

%%
[amp_Lo,phi_Lo,yr_Lo]=HANTS(ni,nb,nf,y,ts,'Lo',low,high,fet,dod,delta);

%%
[amp_Hi,phi_Hi,yr_Hi]=HANTS(ni,nb,nf,y,ts,'Hi',low,high,fet,dod,delta);

%% plotting
plot(y,'b.-');
hold on;
plot(yr_Lo,'r.-');
plot(yr_Hi,'k.-');
plot(yr_none,'g.-');
legend('Original Data','HANTS - Lo','HANTS - Hi','HANTS - none');
title('Testing HANTS 2009 Algorithm')