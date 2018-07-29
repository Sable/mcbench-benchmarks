%%% Harmonic Wavelets based ISAR imaging of Mig 25.
%%% Author : B. K. SHREYAMSHA KUMAR 

%%% Copyright (c) 2006 B. K. Shreyamsha Kumar 
%%% All rights reserved.

%%% Permission is hereby granted, without written agreement and without license or royalty fees, to use, copy, 
%%% modify, and distribute this code (the source files) and its documentation for any purpose, provided that the 
%%% copyright notice in its entirety appear in all copies of this code, and the original source of this code, 
%%% This should be acknowledged in any publication that reports research using this code. The research is to be 
%%% cited in the bibliography as:

%%% B. K. Shreyamsha Kumar, B. Prabhakar, K. Suryanarayana, V. Thilagavathi and R. Rajagopal, “Target 
%%% Identification using Harmonic Wavelet based ISAR Imaging”, EURASIP Journal on Advances in Signal Processing, 
%%% Vol. 2006, pp. 1-13, 2006. (doi: 10.1155/ASP/2006/86053)

%%% This program computes only the ISAR images from the RADAR returns.

close all
clear all;

load mig25.mat;
WN=4;%%window length is assumed as even. (4)

tic;
t=cputime;

X = ifft(X);%% Computes FFT along Columwise (default).
X1=X(1:1:64,1:64);
% X1=X(1:2:64,1:32);
% X1=X(1:4:64,449:512);

w=hammwin(WN);%%Hamming Window is better for this.
[m,n]=size(X1);

Xf=fft(X1,[],2);%% Take FFT along Rowwise (2).
len=length(Xf);

xtemp=Xf;
Xf=zeros(len,len+WN);%% Pad zeros to the start as well as end, to reduce the effect
Xf(:,WN/2+1:len+WN/2)=xtemp;%% of neglecting last window length points.
len=length(Xf);

for i1=1:1:m;
    xf=Xf(i1,:);
    wx=isar_hwtmapf(xf,w,len);
    [p,q]=size(wx);
    p=p-WN;  
    V(p*(i1-1)+1:p*(i1-1)+p,1:q)=wx(1+WN/2:p+WN/2,1:q);
    i1
end

V=fftshift(V);

toc
cputime-t

[m,n]=size(V);
m2 = m/n;
m1 = n;

% figure
for i1=1:1:n
    for k1=1:1:m2
        temp(k1,:)=V(i1+(k1-1)*m1,:);
    end           
    t3 = temp;
    if i1<=9
        if(i1==1)
            s='MIG-25_frame-1_HWT.dat';
            t3=t3/max(max(t3));               
            save_data_to_file(t3,s);
            figure(9);
            plothw(1,1,1,t3);  
        end
        figure(1)
        z=i1;  
        plothw(3,3,z,t3);
    elseif i1<=18
        figure(2);
        z=i1-9;
        plothw(3,3,z,t3);
    elseif i1<=27  
        figure(3);
        z=i1-9*2;
        plothw(3,3,z,t3);
    elseif i1<=36  
        if(i1 == 30)
            s='MIG-25_frame-30_HWT.dat';
            t3=t3/max(max(t3));               
            save_data_to_file(t3,s);
            figure(10);
            plothw(1,1,1,t3);  
        end
        figure(4);
        z=i1-9*3;
        plothw(3,3,z,t3);
    elseif i1<=45
        figure(5);
        z=i1-9*4;
        plothw(3,3,z,t3);
    elseif i1<=54  
        figure(6);
        z=i1-9*5;
        plothw(3,3,z,t3);
    elseif i1<=63
        figure(7);
        z=i1-9*6;
        plothw(3,3,z,t3);
    end
end