%Voice Based Biometric System
%By Ambavi K. Patel.


function cb=fextr()

fs = 16000;                  % Sampling rate
intval = 3;                      % Recording time interval in seconds
% Record Function “wavrecord” is a Matlab function used for recording speech signals
choix=menu('Select one option  ','1-Browse .Wav File','2-Record Your Voice');
if choix==1
   [namefile,pathname]=uigetfile('*.wav','select the .wav file ');
   voicein=wavread(namefile);
else 
h = msgbox('Speak Your Password','Record','help');
voicein = wavrecord(intval*fs,fs, 'double');

close(h);
end;
%wavwrite(voicein,fs,'atest1');
%writes the data stored in the variable ip to a WAVE file called Input

ip=preprocess(voicein,fs,intval);  % preprocessing of data


stime=0.015; %time duration in which voice is stationary
len=length(ip);
[fsize,osize,nwin]=calsize(stime,intval,len);  % to calculate frame sizes
powspc(1:floor(fsize/2),1:nwin)=0;
powspc=frm2fft(fsize,osize,nwin,ip);
noc=40;              %no. of filters or channels  in mel filter bank
mel(1:noc,1:floor(fsize/2))= 0;
mel=melfilter(fs,fsize,noc); % to cunstruct melfilter bank
mfcc(1:12,1:nwin)=0;
mfcc=melcep(mel,powspc,noc,fsize,nwin);% to find mfcc 
mfccn=postnorm(mfcc,nwin);
cb(1,:)=centr(mfccn);


