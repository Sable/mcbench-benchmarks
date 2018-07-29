function [qrswav]=qrs_wav(x,a_qrswav,d_qrswav,li)
l=li;
a=a_qrswav;
b=(2*l)/d_qrswav;
n=100;
qrs1=(a/(2*b))*(2-b);
qrs2=0;
for i = 1:n
    harm=(((2*b*a)/(i*i*pi*pi))*(1-cos((i*pi)/b)))*cos((i*pi*x)/l);
    qrs2=qrs2+harm;
end
qrswav=qrs1+qrs2;