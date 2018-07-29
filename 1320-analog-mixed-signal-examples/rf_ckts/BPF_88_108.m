% bpf_88_108.m
% Band Pass Filter Design for FM band
% Copyright 2002-2013 The Mathworks, Inc.
% Dick Benson

%% Low pass to band pass transformation from Handbook of Filter Synthesis,
% Anatol I. Zverev. pp 154 section 5.5 
fbp1    =    88e6;   % low end of FM band
fbp2    =   108e6;   % high end of FM band
fbpslo  =    82e6;   % stopband on low freq side
fbpshi  =   114e6;   % stopband on high side
Z0      =   200;     % drive point impedance

fm    = sqrt(fbp1*fbp2)  % center freq (geo mean)
% normalized bpf freqs
w_b2  = fbp2/fm;
w_b1  = fbp1/fm;
w_s1  = fbpslo/fm;
w_s2  = fbpshi/fm;


a        = fm/(fbp2-fbp1);   % the "a" is from from pp 155, eq 5.5.3 
w_lps_s1 = a*(w_s1 - 1/w_s1);
w_lps_s2 = a*(w_s2 - 1/w_s2);
w_lps    = a*min((1/w_s1-w_s1),(w_s2-1/w_s2));


% c0550 theta = 43 filter low pass proto type should do it 
% from filter tables in Zverev
c_lp1 =  2.142;   % capacitor values
c_lp2 =  0.2113;
c_lp3 =  2.631;
c_lp4 =  0.5837;
c_lp5 =  1.856;
l_lp1 =  0.9208;  % inductor values
l_lp2 =  0.7402;

%% Now transform the network to the bandpass configuration
% pp 157 Table 5.4 
% first || LC
L(1)  = 1/(a*c_lp1);
C(1)  = a*c_lp1;

% first series LC (makes 2 of them)
w_inf  = 1/sqrt(c_lp2*l_lp1);
b      = sqrt( (2*a/w_inf)^2+1);
L(2)   = (1/(a*c_lp2))*((b-1)/(2*b));
C(3)   = 1/L(2);  % yup next cap 
L(3)   = (1/(a*c_lp2))*((b+1)/(2*b));
C(2)   = 1/L(3); % yup previous cap

res1 = L(2)+L(3) -1/(a*c_lp2)   % should be zero or darn close to it .... 

% second || LC
L(4)   = 1/(a*c_lp3);
C(4)   = a*c_lp3;


% second series LC (makes 2 of them)
w_inf  = 1/sqrt(c_lp4*l_lp2);
b      = sqrt( (2*a/w_inf)^2+1);
L(5)   = (1/(a*c_lp4))*((b-1)/(2*b));
C(6)   = 1/L(5);  % yup next cap 
L(6)   = (1/(a*c_lp4))*((b+1)/(2*b));
C(5)   = 1/L(6); % yup previous cap, 
res1   = L(5)+L(6) -1/(a*c_lp4)   % should be zero

% third || LC
L(7)   = 1/(a*c_lp5);
C(7)   = a*c_lp5;

% scale the elements for the Zo and actual frequency .... 
l_scale = Z0/(2*pi*fm);
c_scale = 1/(Z0*2*pi*fm);
Lval = L*l_scale;
Cval = C*c_scale;

Fres = (1./(2*pi*(Lval.*Cval).^0.5))';  % resonant frequencies of parallel LC sections

%% Create RF circuit object version of filter and check freq response
LCBPF_Ideal = analyze_BPF(Lval,Cval,Z0); % guts are in this function

%% Plot the frequency response. 
hold on
hline= plot(LCBPF_Ideal,'S21','dB')
xlim = get(hline,'Xdata');
title('FM Band Pass Filter, Ideal components');
xlabel('MHz'); ylabel('dB');
axis([xlim(1),xlim(end),-100 10]);



%% Check freq response with std value caps 
Creal = standard_values(Cval)';
LCBPF_Real_Caps = analyze_BPF(Lval,Creal,Z0); % guts are in this function
hline = plot(LCBPF_Real_Caps,'S21','dB');
set(hline,'color',[1 0 0])
title('FM Band Pass Filter, Std Caps');
legend('Ideal','Std Caps','Location','South');

%% Now adjust L values to maintain resonance with standard C values
New_L = 1./(Creal.*((2*pi*Fres).^2));
LCBPF_Real_Caps_New_L = analyze_BPF(New_L,Creal,Z0); % guts are in this function

hline = plot(LCBPF_Real_Caps_New_L,'S21','dB');
set(hline,'color',[0 0 0])
title('FM Band Pass Filter, Std Caps, Tweaked Inductors');
legend('Ideal','Std Caps','Std Caps and Tweaked Inductors','Location','South');


%% An HP 250 RX bridge will be used to build and adjust the inductors. 
%  One arm of bridge balances with a C readout. 
Ftest=100e6;    % use 100 MHz as test freq
CRX_pf = 1e12./((2*pi*Ftest).^2*New_L)   % for using HP 250 RX 
