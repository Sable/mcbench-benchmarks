Fs=44100; % sampling frequency
dt=1/Fs;
T0=2; % period, sec

close all;

r = audiorecorder(Fs, 16, 1);
clc;disp('recording started...');
recordblocking(r,T0); % record next data
disp('recorded');
s00 = getaudiodata(r); % get data


L0=length(s00);

s=s00-mean(s00);

 %load('bp.mat'); % bandpass 50-4000 Hz
 load('lp.mat'); % lowpass 0-10000Hz
 
 s = filter(Num,1,s);
 
 s=s/max(abs(s)); % normalize to maximum

[op ismax]=find_all_optimums(s);
% op - optimums positions

%[z isrise]=find_zeros(s);
%op=decimate_optimums(z,op,s(op));

t=(0:L0-1)'*dt;
plot(t,s,'b-');
hold on;
plot(t(op),s(op),'rx');

% sw0=interp1(t(op),s(op),t,'nearest');
% sw1=interp1(t(op),s(op),t,'linear');
% al=0;


dop=diff(op);

% quntitize dop to [0 255]:
dop(dop>255)=255;
dop=round(dop); % not necessary


opv=s(op); % values in optimums

% quntitize opv to -128 127
opv=128*opv;
opv(opv>127)=127;
opv(opv<-128)=-128;
opv=round(opv);


% compression ratio:
szo=2*length(s); % original size as 2 byts per sample 
szc=1*length(dop)+1*length(opv); % compressed size one byte for dop element, one byte for opv element
cr=szo/szc; % compression ratio


% reconstruction
opr=[0; cumsum(dop)];
tr=opr*dt;

opvr=opv/128;

tra=0:dt:max(tr); % time for interpolation

sw=interp1(tr,opvr,t,'pchip');

soundsc(sw,Fs);

plot(t,sw,'g-');


title(['compressed in ' num2str(cr) ' times']);
legend('original','optimums','reconstructed');
