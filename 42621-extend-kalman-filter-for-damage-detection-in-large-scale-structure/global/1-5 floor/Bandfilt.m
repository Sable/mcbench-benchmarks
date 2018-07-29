function acc=Bandfilt(y1,dt,frequp);

% ***** force and time generation *****

filter_order = 6;
wn=frequp*2*dt; %Hz
[filt_num,filt_den] = butter(filter_order,wn,'low');

%figure(1)
%freqz(filt_num,filt_den,512,1/dt);

acc = filter(filt_num,filt_den,y1);
%acc = filter(filt_num,filt_den,acc);

%figure(2)
%fftplot(acc,dt);
