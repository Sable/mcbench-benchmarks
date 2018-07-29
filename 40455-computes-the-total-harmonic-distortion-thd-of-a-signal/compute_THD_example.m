% An example file for function 'compute_THD'.
% type 'help compute_THD' for more details.

clc;
close all;

% check cos wave:
'cos wave example'
t = 0:0.0001:1;
freq = 75;
x = 20 * cos(2*pi*freq*t + pi/4);
[ THD_cos, ph, amp ] = compute_THD( t,x, freq );
[THD_cos,  ph*180/pi,  amp]

% check square wave:
'square wave example'
freq = 10; % Hz
number_of_cycles = 4;
dt = 0.0001;
t = 0:dt:(number_of_cycles/freq);
x = (mod(t,1/freq) < 0.5/freq);
x = 1*(2*x-1);
[ THD_square, ph, amp ] = compute_THD( t,x, freq );

plot(t,x); xlabel('t [sec]'); title('square wave'); ylim([-1.1 1.1]);
[THD_square,  ph*180/pi,  amp]

%%% double check THD of square wave using the fourier series:
n = 1:10000;
freq_vec = freq*n;  % fourier series frequency vector
amp_vec = (4/pi)  * (1./n).*(mod(n,2)==1);
% compute THD by definition:
THD_square_theoretical = (sum(amp_vec(2:end).^2) / amp_vec(1)^2)^0.5;
THD_square_theoretical

 
