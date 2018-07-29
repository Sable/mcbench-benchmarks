% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
%    Discrete Time Frequency Response Graph
%                                         
% 
% 
%             3+5exp(-jw)-7exp(-2jw) 
%      H(w)= -----------------------
%                2-4exp(-jw)  


w=0:.1:2*pi;
num=[3 5 -7];
den=[2 -4];
H=freqz(num,den,w);
plot(w,abs(H))
legend('| H(\omega)| ')
xlim([0 2*pi])

figure
plot(w,angle(H))
xlim([0 2*pi])
legend('\angle H(\omega)')

figure
freqz(num,den,w);

figure
freqz(num,den);


%   Equivalent Discrete Time Frequency Responses
figure
[num1,den1]=invfreqz (H,w,2,1)
freqz(num1,den1,w)

figure
[num2,den2]=invfreqz (H,w,4,4)
freqz(num2,den2,w)


