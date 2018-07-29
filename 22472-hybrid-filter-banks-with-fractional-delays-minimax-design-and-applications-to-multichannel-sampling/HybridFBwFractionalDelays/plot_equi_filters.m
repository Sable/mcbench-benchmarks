% Ha T. Nguyen and Minh N. Do, Hybrid Filter Banks with Fractional Delays:
% Minimax Design and Application to Multichannel Sampling, vol. 56, no. 7,
% pp. 3180-3190, July 2008.

% This m file plot Fig. 12 in the paper. For generality, this code results
% in system with 8 input instead of 4 as in the example used for Fig. 12 in
% the paper. However, there are only four different analysis filters Hi(z)
% whose magnitudes and phases are plot in this m file.

initialization;

% Get the ingeter and residual of the delays
m = floor(D(:)/h);
d = D(:) - m * h;

% Get the digital system as in Prop. 1 and 2
Ad = getAd(phi, h, d);
Bd = getBd(phi, h, d);
Cd = getCd(phi, h, d);
Dd = zeros(size(Cd,1), size(Bd,2));

% % The Integer Delay Operator
% sysd = IntDelayOp([m0; m]);
% 
% % Get the digital system as in Prop. 3 by taking into account the integer
% % delay operators
% % sys = sminreal( sysd * ss(Ad, Bd, Cd, Dd, -1) );
% sys = sysd * ss(Ad, Bd, Cd, Dd, -1);
% 
% [AH, BH, CH, DH] = ssdata(sys);

i = 1;

[num1, den1] = ss2tf(Ad,Bd,Cd(i,:),zeros(1,size(Bd,2)),1);
[num2, den2] = ss2tf(Ad,Bd,Cd(i,:),zeros(1,size(Bd,2)),2);
[num3, den3] = ss2tf(Ad,Bd,Cd(i,:),zeros(1,size(Bd,2)),3);
[num4, den4] = ss2tf(Ad,Bd,Cd(i,:),zeros(1,size(Bd,2)),4);
[num5, den5] = ss2tf(Ad,Bd,Cd(i,:),zeros(1,size(Bd,2)),5);
[num6, den6] = ss2tf(Ad,Bd,Cd(i,:),zeros(1,size(Bd,2)),6);
[num7, den7] = ss2tf(Ad,Bd,Cd(i,:),zeros(1,size(Bd,2)),7);
[num8, den8] = ss2tf(Ad,Bd,Cd(i,:),zeros(1,size(Bd,2)),8);

figure(10); hold on;
freqz(num1,den1); hold on;
freqz(num2,den2); hold on;
freqz(num5,den5); hold on;
freqz(num8,den8); hold on;
legend(['H' num2str(i-1) '1'],['H' num2str(i-1) '2'],['H' num2str(i-1) '3'],['H' num2str(i-1) '4']);
