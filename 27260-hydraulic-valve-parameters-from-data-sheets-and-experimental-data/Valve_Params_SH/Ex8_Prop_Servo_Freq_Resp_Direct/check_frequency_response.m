function F  = ...
    check_frequency_response(x,frequency_20,frequency_100, method)
% Checks the result of optimization by plotting phase characteristics at
% optimal parameters and computing the frequencies at -pi/2 phase shift.
% The frequency responses of a nonlinear system are obtained by processing
% the pulse transient characteristics with the FFT algorithm. 
% Copyright 2010 MathWorks, Inc.

% frequency_20   - frequency (Hz) at phase shift in -pi/2 at 20% input signal
% frequency_100  - frequency (Hz) at phase shift in -pi/2 at 100% input signal
% method - method to check the results, can be set to 'FFT' or 'direct'.

if strcmpi(method, 'FFT')
    model = 'actuator_freq_testrig_pulse_FFT_method';
elseif strcmpi(method, 'direct')
    model = 'actuator_freq_testrig_direct_method';
else
    error('Unspecified method');
end

load_system(model);

assignin('base','gain', x(1));
assignin('base','time_const', x(2));
assignin('base','saturation', x(3));

sim(model);

if strcmpi(method, 'FFT')
    
    y_20 = yout(:,2);               % Pulse transient characteristic at 20% input
    y_100 = yout(:,1);              % Pulse transient characteristic at 100% input
    fs = 1000;                      % Sampling frequency
    n = length(y_20);               % Window length = Transform length
    y_20_fft = fft(y_20,n);         % Discrete Fourier Transform
    y_100_fft = fft(y_100,n);       % Discrete Fourier Transform
    f0 = (0:n/2-1)*(fs/n);          % Shifted frequency range, positive region
    y_20_0 = fftshift(y_20_fft);    % Shifted DFT at 20% input
    y_100_0 = fftshift(y_100_fft);  % Shifted DFT at 100% input
    % Phase characteristic at 20% input for positive frequencies after unwrap
    phase_20 = unwrap(angle(y_20_0(257:end))); 
    % Phase characteristic at 100% input for positive frequencies after unwrap
    phase_100 = unwrap(angle(y_100_0(257:end)));

    % Computing frequency at 90 deg phase shift by interpolation of phase
    % characteristics
    frq_20 = interp1(phase_20,f0,-pi/2);
    frq_100 = interp1(phase_100,f0,-pi/2);


    % Computing frequency at phase shift in -pi/2 by interpolation of phase
    % characteristics
    frq_20 = interp1(phase_20,f0,-pi/2);
    frq_100 = interp1(phase_100,f0,-pi/2);
    % Computing errors
    error_20 = (frequency_20 - frq_20)/frequency_20 * 100;
    error_100 = (frequency_100 - frq_100)/frequency_100 * 100;


    disp(['******************************************************************']);  
    disp(['     System Characteristics with FFT at Obtained Parameters']);
    disp(['     Frequencies at -90 deg phase shift and 20% input:']);
    disp(['Target:  ', num2str(frequency_20),' Hz', ...
        '  Found:  ',num2str(frq_20),' Hz', ...
        '   Error :   ',num2str(error_20),'%']);
    disp(['     Frequencies at -90 deg phase shift and 100% input']);
    disp(['Target:  ', num2str(frequency_100),' Hz', ...
        ' Found:     ',num2str(frq_100),' Hz', ...
        '   Error:   ',num2str(error_100),'%']);

    
    % Plotting the phase frequency characterictics
    semilogx(f0,phase_20*180/pi,'LineWidth',3);
    hold on
    semilogx(f0,phase_100*180/pi,'r--','LineWidth',3), grid on;
    xlabel('Frequency (Hz)','FontSize',14)
    ylabel('Phase (degrees)','FontSize',14)
    title('Frequency Response (Phase)','FontWeight','Bold','FontSize',16)
    legend({'20% Input' '100% Input'},'FontSize',12);
    axis([2 40 -100 0]);
    plot(frq_100,-90,'ro','MarkerSize',10,'MarkerFaceColor','r')
    plot(frq_20,-90,'bo','MarkerSize',10,'MarkerFaceColor','b')
    hold off
    

else    % Direct measurement. yout contains input and output values of
        % both signals
        
    % Phase angle at specified frequency and input signal in 100%
    phase_100 = phase_computation(yout(:,[1,2]), tout, frequency_100,4);
    % Phase angle at specified frequency and input signal in 20%
    phase_20 = phase_computation(yout(:,[3,4]), tout, frequency_20,6);

    error_20 = (phase_20 + 90)/90 * 100;
    error_100 = (phase_100 +90)/90 * 100;


    disp(['******************************************************************']);  
    disp(['     System Characteristics after Direct Measurement at Obtained Parameters']);
    disp(['     Phase shift at ',num2str(frequency_20),'Hz',' and 20% input:']);
    disp(['Target:  ',' -90 deg', ...
        '  Found:  ',num2str(phase_20),' deg', ...
        '   Error :   ',num2str(error_20),'%']);
    disp(['     Phase shift at ',num2str(frequency_100),'Hz',' and 100% input']);
    disp(['Target:  ',' -90 deg', ...
        '  Found:   ',num2str(phase_100),' deg', ...
        '   Error:   ',num2str(error_100),'%']);
    disp(['******************************************************************']);  

end
end

function [phase] = phase_computation(yout, tout, freq_at_90, N)
% Function computes phase angle by processing sinusoids stored in yout

% yout(:,1)- input; yout(:,2) - output
% tout - simulation step time
% freq_at_90 - frequency at which phase angle equals -90 deg
% N - number of periods to settle the transients

% Measurement time. Time in N periods is assumed to be enough to settle
% down the transients. The input signal at this time is equal zero

t_s = 1/freq_at_90 * N;             % Start time
t_end = t_s + 1/freq_at_90;         % End time

% yout index at measurement time
for j = 1:length(tout)- 1
    if t_s >= tout(j) && t_s < tout(j+1)
        k_start = j;                % First array index after start time
        t_corr_1 = tout(j) - t_s;   % Correction due to discretization
    end
    if t_end >= tout(j) && t_end < tout(j+1)
        k_end = j-1;                  % Last array index within period
    end
end
% Computing time the output signal crosses zero
for j = k_start : k_end
    if yout(j,2) <= 0 && yout(j+1,2) > 0
        t_tab_cross = tout(j);   % First value in the table after crossing
        % Approximating real crossing time
        t_corr_2 = -yout(j,2) / (yout(j+1,2) - yout(j,2)) * ...
            (tout(j+1) - tout(j));
    end
end
% Crossing time for the output signal
t_cross = t_tab_cross + t_corr_1 + t_corr_2;
% Phase angle
phase = -(t_cross - t_s) / (1/freq_at_90) * 360;

end


% EOF