%Voice Based Biometric System
%By Ambavi K. Patel.


function adddb
%to store database of passwords .write in command window ex.adddb('database') 

 n=5;   % no. of voice samples for each person
 %if want to change n, also chage in srs
 fs = 16000;    % Sampling rate
 intval = 3;    % Recording time interval in seconds
 len=fs*intval; %total length of voice sample
 stime=0.015;   %time duration in which voice is stationary
 
[fsize,osize,nwin]=calsize(stime,intval,len);   % to calculate frame sizes
 noc=40;    %no. of filters or channels  in mel filter bank


choix1=menu('Select one option  ','1-Erase old and Load new Database','2-Add another Database');
if choix1==1
    p=cell2mat(inputdlg('Enter Total No. of Speaker & Pres OK','Total Speakers',1)); %no. of speakers
    p=str2double(p);
   cd(1:n*p,13+nwin)=0;    %13 is no. of channels of filter bank taken
else
    
   
    p=cell2mat(inputdlg('Enter  No. of Speaker & Pres OK','New Speaker',1)); %no. of speakers
    p=str2double(p);
    cd(1:n,13+nwin)=0;
end;

for t1=1:p
    
    if choix1==2
        t1=1;
    end;
    
    for t2=1:n
    crnt={'Speaker No.',num2str(t1),' Sample No:',num2str(t2)};
    g=msgbox(crnt,'speaker');
    choix2=menu('Select one option  ','1-Browse .Wav File','2-Record Your Voice');
    
        if choix2==1
           [namefile,pathname]=uigetfile('*.wav','select the .wav file ');
           voicein=wavread(namefile);
        else 
        %no = inputdlg('Enter your no.','number');
        h = msgbox('Speak Your Password','Record','help');
        voicein = wavrecord(intval*fs,fs, 'double');    % Record Function “wavrecord” is a Matlab function used for recording
        close(h);
        end;
        
    h=waitbar(1,'wait');
    %wavwrite(voicein,fs,'dtest1');
    %writes the data stored in the variable ip to a WAVE file called Input
    ip=preprocess(voicein,fs,intval);  % preprocessing of data
    powspc(1:floor(fsize/2),1:nwin)=0;
    powspc=frm2fft(fsize,osize,nwin,ip);    %converting time domain to frequency domain
    mel(1:noc,1:floor(fsize/2))= 0;
    mel=melfilter(fs,fsize,noc);    %creating a mel filterbank
    mfcc(1:13,1:nwin)=0;
    mfcc=melcep(mel,powspc,noc,fsize,nwin); % to find mel frequency cepstrul coefficient
    mfcc=postnorm(mfcc,nwin);   %postnormalisatiom
    [r,c]=size(mfcc);
    cd((n*(t1-1))+t2,:)=centr(mfcc);  %to find centroid of each row and column 
    
    close(g);
    close(h);
    end;
    
    if choix1==2
        load db.mat;
        cdb((n*(p-1))+1:(n*(p-1))+n,1:13+nwin)=cd(1:n,:); 
        break;

    end;
    
    end;
  if choix1==1
      cdb=cd;
  end;
    
save ('db','cdb'); % saving database cd in dbname.mat




