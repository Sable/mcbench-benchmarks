
% Ha T. Nguyen and Minh N. Do, Hybrid Filter Banks with Fractional Delays:
% Minimax Design and Application to Multichannel Sampling, vol. 56, no. 7,
% pp. 3180-3190, July 2008.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Values of variables/ parameters used in demo

M = 2;             % Super-resolution rate
N = 2;             % Number of low-resolution channels
m0 = 10;           % System delay
h = 1;             % Sampling rate of the fast ADC

% If FIR synthesis filters F_i(z) are to be designed, M*n+1 is the maximum
% length of F_i(z) 
n = 10;

% N fractional delays randomly chosen in [0, M*h]
% D = rand(1,N) * M * h;
D = [1.2 0.6 ];

% The Butterworth filter
wc = .5;                            
numphi = wc^2;
denphi = [1 2*wc wc^2];
sys = tf(numphi, denphi);
[Aphi, Bphi, Cphi, Dphi] = tf2ss(numphi, denphi);

phi = cell(N+1,1);

for i = 1:N+1
    phi{i}{1} = Aphi;
    phi{i}{2} = Bphi;
    phi{i}{3} = Cphi;
    phi{i}{4} = Dphi;    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some possible input functions (bandlimited function and step function)

% Number of samples interested of the high-resolution signal y_0[n]
L = 100 * M;

% Simulation of an analog system
dt = 1/100;                 % Time increment
t = 0:dt:round(3*L/2);      % Discrete instances used to simulate the analog system

% A step function us
nt0 = 30;
t0 = nt0*dt;                % Step function with jump at t0
us = ones(1,length(t));
us(1:nt0) = zeros(1,nt0);     

% A bandlimited function
uf = cos(0.3 * t) + cos( 0.8*t );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose an input, either the step function us or the bandlimited function
% uf defined above
f = us;

% The high-resolution signal y_0[n]
sys = ss(phi{1}{1}, phi{1}{2}, phi{1}{3}, phi{1}{4});
y0 = analog_conv((1:L)*h-m0*h, sys, f, t, dt);

% Low resolution signals x_i[n]
x = cell(1,N);
for i = 1:N
    sys = ss(phi{i+1}{1}, phi{i+1}{2}, phi{i+1}{3}, phi{i+1}{4});
    x{i} = analog_conv((1:L)*h - D(i), sys, f, t, dt);
    x{i} = x{i}(1:M:end);
end
