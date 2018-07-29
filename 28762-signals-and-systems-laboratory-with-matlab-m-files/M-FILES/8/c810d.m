% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Problem 4-  Equivalent Frequency Response  to  
%                                         
% 
% 
%             3(jw)^2-4jw+1 
%      H(jw)=---------------
%             (jw)^3 +2jw 


num1=[3 -4 1];
den1=[1 0 2 0];
[H1,w]=freqs(num1,den1);
freqs(num1,den1)
title('H_1(\Omega)')

figure
[num2,den2]=invfreqs(H1,w,3,4)
freqs(num2,den2)
