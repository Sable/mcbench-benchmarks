%This m file is for locating a good enough "M". For a good value of "M",
%"PG" will be high. But it also adds computational load as we increase "M".
%Run this for different frames of "x" and see for yourself. Define the 
%starting values of frames by defining a value to "b" at line 25.

%Here,  array of "k"=Reflection C-oefficients
%       array of "a"=LPCs
%       array of "R"=autocorrelation co-efficients
%every notation is according to page 112 [chapter4] of Speech Coding
%Algorithms by W. C. Chu.

%the indexes in this code is "+1" from the indexes in the book in some
%cases because there is no index "0" in matlab

clear all
% close all
clc

for M=3:100,
    
% INITIALIZATION:
inpfilenm = 's1ofwb.wav';
[x, fs]=wavread(inpfilenm);%"t_16k_2s.wav" is the file I used. Change according 
                      %to your case.
% length(x)
b=3841;        %index no. of starting data point of current frame
fsize = 30e-3;    %frame size
frame_length = round(fs .* fsize);  %=number of data points in each framesize 
                                    %of "x"
N= frame_length - 1;        %N+1 = frame length = number of data points in 
                            %each frame
sk=0;       %initializing summartion term "sk"
a=[zeros(M+1);zeros(M+1)]; %defining a matrix of zeros for "a" for init.

%FRAME SEGMENTATION:
    y1=x(b:b+N);    %"b+N" denotes the end point of current frame.
                    %"y" denotes an array of the data points of the current 
                    %frame
    y = filter([1 -.9378], 1, y1);  %pre-emphasis filtering

%MAIN BODY OF THIS PROGRAM STARTS FROM HERE>>>>>>>>>>>>>>
z=xcorr(y);

%finding array of R[l]
R=z( ( (length(z)+1) ./2 ) : length(z)); %R=array of "R[l]", where l=0,1,2,
                                         %...(b+N)-1
                                         %R(1)=R[lag=0], R(2)=R[lag=1], 
                                         %R(3)=R[lag=2]... etc 

%GETTING OTHER PARAMETERS OF PREDICTOR OF ORDER "0":
s=1;        %s=step no.
J(1)=R(1);          %J=array of "Jl", where l=0,1,2...(b+N)-1
                    %J(1)=J0, J(2)=J1, J(3)=J2 etc

%GETTING OTHER PARAMETERS OF PREDICTOR OF ORDER "(s-1)":
for s=2:M+1,
    sk=0;               %clearing "sk" for each iteration
    for i=2:(s-1),
        sk=sk + a(i,(s-1)).*R(s-i+1);
    end                 %now we know value of "sk", the summation term
                        %of formula of calculating "k(l)"
    k(s)=(R(s) + sk)./J(s-1);
    J(s)=J(s-1).*(1-(k(s)).^2);
    
    a(s,s)= -k(s);
    a(1,s)=1;
    for i=2:(s-1),
        a(i,s)=a(i,(s-1)) - k(s).*a((s-i+1),(s-1));
    end
end


a_final=a((1:s),s)';
est_y = filter([0 -a_final(2:end)],1,y);    % = s^(n) with a cap on page 92 of the book
e = y - est_y;      %supposed to be a white noise

pg(M) = 10.*log10( (sum(y.^2)) ./ (sum(e.^2)) );       %prediction gain
end
figure;
subplot(2,1,1), plot(x); title(['original speech file, ',inpfilenm]);
subplot(2,1,2),plot(pg);
title('Prediction Gain (PG) vs Prediction Order (M) for frame starting at data point "b"');
xlabel('M');
ylabel('PG');

disp('This m file is simply "func_lev_durb.m" with a little modification. If you run this for many frames, you will see that PG is good enough for M = a value around "10" for most of the frames');


