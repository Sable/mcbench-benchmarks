%  Figure 3.3      Feedback Control of Dynamic Systems, 6e
%                        Franklin, Powell, Emami
% script to generate Fig. 3.3
%% fig3_03.m Example 3.4  
% Frequency response
clf;
k=1;
num=1;                      % form numerator
den=[1 k];                  % form denominator
sys=tf(num,den);            % form system
% frequency range
w=logspace(-2,2);
[mag,phase]=bode(sys,w);    % compute frequency response
% plot frequency response
subplot(2,1,1); loglog(w,mag(:));xlabel('\omega (rad/sec)');
ylabel('M');title('Figure 3.3: Magnitude, phase');grid;
subplot(2,1,2); semilogx(w,phase(:));xlabel('\omega (rad/sec)');
ylabel('\phi (deg)')
grid;
% Bode grid
bodegrid


