% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% The  command invfreqs
                                 

%verification of the result of the command freqs
num=[ -2/j^2 7 0];
den=[3 0 2];
w=0:.1:10;
H=freqs(num,den,w);
freqs(num,den,w)
[num1,den1]=invfreqs(H,w,2,2)

%Equivalent frequency responses
[num2,den2]=invfreqs(H,w,3,3)
freqs(num2,den2,w)

figure
[num3,den3]=invfreqs(H,w,10,7);
freqs(num3,den3,w)
