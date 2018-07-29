function ss=spectrometer
ai=analoginput('winsound')   
   addchannel(ai,1:2);
   ai.samplerate=8000;
   ai.samplespertrigger=40000;
     ai.triggertype='immediat';
   start(ai);
   [d,t]=getdata(ai);
   u1=d(:,1);
   y=fft(u1,512);
   p=y.*conj(y);
   c=abs(p.^(1/2));
   f = 0:20:5000;
   ff=f(40:200)/1.05;
   cc=c(40:200)
   plot(ff,cc)
   delete(ai)
clear ai



