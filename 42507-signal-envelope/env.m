function [sigenv1,sigenv1y] = env(data,fs)
%% Envelope Detection 
le_data = length(data);
if le_data<1500     DownsampleFactor=3; end
if le_data>=1500&&le_data<=2000 DownsampleFactor=round(le_data/375); end
if le_data>2000&&le_data<=2500 DownsampleFactor=round(le_data/400); end
if le_data>2500&&le_data<=3000 DownsampleFactor=round(le_data/400);end
if le_data>3000&&le_data<=3500 DownsampleFactor=round(le_data/425);end
if le_data>3500&&le_data<=4500 DownsampleFactor=round(le_data/425);end    
if le_data>4500    DownsampleFactor=round(le_data/1125);end  
numSamples = 10000;
frameSize = 10*DownsampleFactor;
Fs=fs;
for i=1:numSamples/frameSize
% Envelope detector 
    sig=data;
    %squaring
    sigsq =4*sig.*sig;
    % downsampling
    hm = mfilt.firsrc(1,DownsampleFactor,[1 1]);
    des=filter(hm,sigsq);
    %low pass
    a1= firpm(30, [0 0.003 0.1 1], [1 1 0 0]);
    len_des=length(des);
    len=mod(len_des,length(a1));
    add=15;
    all=len_des+add;
    des2=zeros(all,1);
    des2(1:len_des,1)=des; 
    a2=filter(a1,1,des2);
    sigenv1 = sqrt(a2);
    sigenv1y=sigenv1(15:end,1); 
end

%% show 
le_s1=length(sigenv1y);
le_data=length(data);
ads1=le_data/le_s1;
t1=1:ads1:le_data;
plot(t1,sigenv1y,'r');
xlabel('sample number');
ylabel('amplitude')
hold on
plot(data,'b');