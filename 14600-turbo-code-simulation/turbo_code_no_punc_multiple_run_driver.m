% Unpuncture turbo code driver for multiple runs
% script to invoke the SIMULINK Turbo code model
% Revised 8/24/2011
% In Soo Ahn, Dept. of ECE, Bradley University
% calculate the BERs under different Eb/No's.
clear all
close all

MaxdB = 3.0; % maximum Eb/No in dB for simulation
EbNo_incr = 0.5;  % Eb/No increment in dB
No_pts = MaxdB/EbNo_incr; % number of points for EbNo plot

Iter = 6;    % number of iterations
%trellis = poly2trellis(3, [7 5],7); 
trellis = poly2trellis(5, [37 21],37);
code_rate = 1/3;
multiplier = 1/code_rate;       % multiplier = symbol_period/sample_time
% you can change this to other trellis.
Len = 1024*1024; 
% size of interleaver, try a smaller or larger size.
Turbo_Pb = zeros(Iter,No_pts); % allocate the storage
Seed = 54123;
Ps = 1;      % signal power
for i = 1:No_pts+1,
    EbNodB = EbNo_incr*(i-1);  % in dB
    EbNo = 10.0.^(0.1*EbNodB);
    EsNo = EbNo/code_rate;     % Average symbol energy vs Noise PSD in linear scale
    Variance = Ps*multiplier/EsNo;  % Calculate channel noise variance. See Help of AWGN
    sim('turbo_code_no_punc_multiple_run'); % open the simulink model.
    Turbo_Pb(:, i) = bit_error_rate.signals.values(:,:,4);
end
%%  Turbo_Pb can be plotted for the probability of bit errors.
x_index = (0:No_pts)*EbNo_incr;
figure(1)

for i = 1:Iter,
    semilogy(x_index, Turbo_Pb(i,:), '.-');
    hold on;
end
grid, xlabel('Eb/No in dB'), ylabel('Prob of bit error')
title('Turbo code (unpuntured) with 6 iterations')
