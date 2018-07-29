% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
%                                         
% Problem 3-  Frequency Response  Graph 
%                                         
% 
% 
%             8jw^2+2w-9 
%      H(jw)=---------------
%             3w^3+3jw^2+w-10 


num=[8/j^2 0 2/j -9];
den=[3/j^3 3/j 1/j -10];
w=0:.1:20;
H=freqs(num,den,w);
plot(w,abs(H));
legend(' | H(\Omega) | ')

figure
plot(w,angle(H));
legend('\angle H(\Omega)')
