function tone=note(keynum, dur)

fs=11025;
tt = 0:(1/fs):dur;

%  This generates white noise for whatever duration specified..  good snare
%  sound with the right envelope, but matlab developed timing problems with this.  I'll probably
%  try to get these running sometime after lab
 if keynum == 2
     tone=rand(1,length(tt));
     return;
 end

%generates rests
if keynum == 0 
%for kk = 1:length(tt)
    tone([1:length(tt)]) = 0;
    %end
return;
end


%adding these octaves rounded out the sound.  
freq=440*2^((keynum-49)/12);
freq3=freq*3;
freq5=freq*5;
freq9=freq*9;
freq7=freq*7;
tone1 = .75*sin(2*pi*freq*tt);
 tone3 = .65*sin(2*pi*freq3*tt);
 tone5=.5*sin(2*pi*freq5*tt);
 tone9 = .222*sin(2*pi*freq9*tt);
 tone7 = .12*sin(2*pi*freq7*tt);
 tone12= 1*sin(2*pi*freq*12*tt);

tone=tone1+tone3+tone5+tone7+tone9;%+tone12;



