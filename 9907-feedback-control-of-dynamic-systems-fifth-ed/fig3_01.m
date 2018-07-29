%  Figure 3.1      Feedback Control of Dynamic Systems, 5e
%                        Franklin, Powell, Emami
%script to generate Fig. 3.1
%% fig3_01.m Example 3.4  
% Frequency response
clf;
k=1;
num=1;                      % form numerator
den=[1 k];                  % form denominator
sys=tf(num,den);            % form system
% frequency range
w=logspace(-2,2);
[mag,phase]=bode(sys,w);    % compute frequency response
%plot frequency response
subplot(2,1,1); loglog(w,mag(:));xlabel('\omega (rad/sec)');
ylabel('M');title('Figure 3.1: Magnitude, phase');grid;
subplot(2,1,2); semilogx(w,phase(:));xlabel('\omega (rad/sec)');
ylabel('\phi (deg)');grid;
