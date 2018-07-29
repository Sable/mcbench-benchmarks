%Voice Based Biometric System
%By Ambavi K. Patel.

function ip2=preprocess(ip1,fs1,intval1)
[rw,cm]=size(ip1);

if rw==1
    ip1=ip1';
else ip1=ip1;
end;

ip1=ip1(:,1);                %to make one dimentional
ip1=ip1-mean(ip1);
len1=length(ip1);
i = 1;

while abs(ip1(i)) < 0.02 && i<48000% Silence detection
i = i + 1;
end

ip1(1:i) = [];

ip1=ip1*2;                 % amplification
len1=length(ip1);
i=fs1*intval1;
ip2=zeros(i,1);        % to make uniform dimention size

if len1<i
    ip2(1:len1)=ip1(1:len1);
else 
    ip2(1:i)=ip1(1:i);
end;
    