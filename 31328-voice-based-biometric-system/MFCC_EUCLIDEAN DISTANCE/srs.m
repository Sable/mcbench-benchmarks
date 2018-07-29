%Voice Based Biometric System
%By Ambavi K. Patel.

function  srs

fs = 16000;                  % Sampling rate
intval = 3;                      % Recording time interval in seconds

choix=menu('Select one option  ','1-Browse .Wav File','2-Record Your Voice');

if choix==1
   [namefile,pathname]=uigetfile('*.wav','select the .wav file ');
   voicein=wavread(namefile);
else 
h = msgbox('Speak Your Password','Record','help');
voicein = wavrecord(intval*fs,fs, 'double');    % Record Function “wavrecord” is a Matlab function used for recording speech signals
close(h);
end;

%wavwrite(voicein,fs,'temp');
%writes the data stored in the variable ip to a WAVE file called Input
ip=preprocess(voicein,fs,intval);  % preprocessing of data
stime=0.015; %time duration in which voice is stationary
len=length(ip);
[fsize,osize,nwin]=calsize(stime,intval,len);  % to calculate frame sizes
powspc(1:floor(fsize/2),1:nwin)=0;
powspc=frm2fft(fsize,osize,nwin,ip);
noc=40;              %no. of filters or channels  in mel filter bank
mel(1:noc,1:floor(fsize/2))= 0;
mel=melfilter(fs,fsize,noc);    % to cunstruct melfilter bank
mfcc(1:13,1:nwin)=0;
mfcc=melcep(mel,powspc,noc,fsize,nwin); % to find mfcc 
mfcc=postnorm(mfcc,nwin);
[r,c]=size(mfcc);
cb(1,1:r+c)=0;
cb(1,:)=centr(mfcc);                 %to find centroid
n=5;    %no. of voice sample for each person

load db;


[r4,c5]=size(cdb);
p=floor(r4/n); % no.of speakers
nmatch(1:p)=0;
for k=1:p
   op=cmpr(cb,cdb,n,k,r,c);
   nmatch(k)=nnz(op);
end;

%display(nmatch);
disply(nmatch);





















