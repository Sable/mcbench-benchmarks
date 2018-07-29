function [bit_stream ] =msk_demod( signal_ip,frequency,Tb)
%msk_demod program for minimum shift keying demodulation
% %   Detailed explanation goes here
% clc;clear all;close all;
% s1=0;s2=0;s3=0;s4=0;
d1=0;d2=0;d3=0;d4=0;
d11=0;d22=0;d33=0;d44=0;
bit_odd=0;bit_even=0;
% data=[1 0 0 1 1 1 0 0 1 0 1 0 1 1 0 1 0 1 0 1 0 0 0 0 1 1 1 1]
% data=[1 0 0 1 1 1 0 0]
% Tb=0.1;
% signal_ip=msk_mod(data,7,Tb,1);
% 
% frequency=7;

s1=msk_mod([0 0],frequency,Tb,1);
s2=msk_mod([0 1],frequency,Tb,1);
s3=msk_mod([1 0],frequency,Tb,1);
s4=msk_mod([1 1],frequency,Tb,1);


l=length(signal_ip);

n_samp=l/1000;

loop=0;ind=1;
for i=1:n_samp
    samp=signal_ip(1,loop+1:loop+1000);
    
    d1=samp.*s1;
    d2=samp.*s2;
    d3=samp.*s3;
    d4=samp.*s4;
    d11=0;d22=0;d33=0;d44=0;
    for k=1:1000
        if (d1(1,k)>0.0000000001)
            d11=d11+1;
        end
        if (d2(1,k)>0.0000000001)
            d22=d22+1;
        end
        if (d3(1,k)>0.0000000001)
            d33=d33+1;
        end
        if (d4(1,k)>0.0000000001)
            d44=d44+1;
        end
    end
    if (d11 > d22) && (d11 > d33) &&(d11 > d44)
        bit_odd=0;
        bit_even=0;
    end
     if (d22 > d11) && (d22 > d33) &&(d22 > d44)
        bit_odd=0;
        bit_even=1;
     end
     if (d33 > d22) && (d33 > d11) &&(d33 > d44)
        bit_odd=1;
        bit_even=0;
     end
     if (d44 > d22) && (d44 > d33) &&(d44 > d11)
        bit_odd=1;
        bit_even=1;
     end
     bit_stream(1,ind)=bit_odd;
     bit_stream(1,ind+1)=bit_even;
     ind=ind+2;
     loop=loop+1000;
end

% bit_stream;
end
