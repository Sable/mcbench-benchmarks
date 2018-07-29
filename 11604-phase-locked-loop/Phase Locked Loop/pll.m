function pll

% STUDYING THE PHASE LOCKED LOOP (PLL) CHARACHTERISTICS

    % Step response of 1st order closed loop transmittance of pll
    kv = 1;
    kd = 1;
    dt = .01;
    t = 0 : dt : 2;
    step = ones(1,length(t));
    clt_1 = tf([2*pi*kv*kd],[1 2*pi*kv*kd]);
    [out_1 t] = lsim(clt_1,step,t);
    figure
    subplot(3,1,1)
    plot(out_1);
    xlabel('Time in seconds')
    ylabel('Amplitude')
    TITLE ('Step Response of 1st Order Transmittance of PLL')
    grid on;
    
    % Step response of 1st order closed loop error transmittance of pll
    clt_e1 = tf([1 0],[1 2*pi*kv*kd]);
    [out_e1 t] = lsim(clt_e1,step,t);
    subplot(3,1,2)
    plot(out_e1)
    xlabel('Time in seconds')
    ylabel('Amplitude')
    TITLE ('Step Response of 1st Order Error Transmittance of PLL')
    grid on;
    
    % Step response of 1st order transmittance between VCO & Input
    clt1 = tf([kd 0],[1 2*pi*kv*kd]);
    [out1 t] = lsim(clt1,step,t);
    subplot(3,1,3)
    plot(out1)
    xlabel('Time in seconds')
    ylabel('Amplitude')
    TITLE ('Step Response of 1st Order Transmittance between VCO & Input')
    grid on;
    
    % Step resonse of 2nd order closed loop transmittance of pll
    a = 3.15;
    zeta = sqrt((pi*kv*kd)/(2*a));
    wn = sqrt(2*pi*kv*kd*a);
    clt_2 = tf([2*zeta*wn wn^2],[1 2*zeta*wn wn^2]);
    [out_2 t] = lsim(clt_2,step,t);
    figure
    subplot(3,1,1)
    plot(out_2)
    xlabel('Time in seconds')
    ylabel('Amplitude')
    TITLE ('Step Response of 2nd Order transmittance of PLL')
    grid on;
    
    % Step response of 2nd order closed loop error transmittance of pll
    clt_e2 = tf([1 0 0],[1 2*zeta*wn wn^2]);
    [out_e2 t] = lsim(clt_e2,step,t);
    subplot(3,1,2)
    plot(out_e2)
    xlabel('Time in seconds')
    ylabel('Amplitude')
    TITLE ('Step Response of 2nd Order Error Transmittance of PLL')
    grid on;
    
    % Step response of 2nd order transmittance between VCO & Input
    clt2 = tf([kd kd*a 0],[1 2*pi*kv*kd 2*pi*kv*kd*a]);
    [out2 t] = lsim(clt2,step,t);
    subplot(3,1,3)
    plot(out2)
    xlabel('Time in seconds')
    ylabel('Amplitude')
    TITLE ('Step Response of 2nd Order Transmittance between VCO & Input')
    grid on;
    
% IMPLEMENTATION OF PHASE LOCKED LOOP IN A FREQUENCY DEMODULATOR
    
    % Signal generation
    t0 = .15;                           % signal duration
    ts = 0.0005;                     	% sampling interval
    fc = 200;                        	% carrier frequency
    kf = 50;                         	% modulation index
    fs = 1/ts;                       	% sampling frequency
    t = [0:ts:t0];                   	% time vector
    df = 0.25;                          % required frequency resolution
    c = cos(2*pi*fc*t);                 % carrier signal
    m = [2*ones(1,t0/(3*ts)),-2*ones(1,t0/(3*ts)),zeros(1,t0/(3*ts)+1)];
    
    % Frequency modulation    
    int_m(1) = 0;
    for (i = 1 : length(t)-1)                  	% integral of m
        int_m(i+1) = int_m(i) + m(i)*ts;
    end
    u = cos(2*pi*fc*t + 2*pi*kf*int_m);         % modulated signal
    figure
    subplot (3,1,1)
    plot (m(1:300))
    TITLE ('Modulating Signal')
    grid on;
    subplot (3,1,2)
    plot (c(1:300))
    TITLE ('Carrier Signal')
    grid on;
    subplot (3,1,3)
    plot (u(1:300))
    TITLE ('Frequency Modulated Signal')
    grid on;
        
    % Frequency demodulation
    t = [0:ts:ts*(length(u)-1)];	  % finding phase of modulated signal
    x = hilbert(u);
    z = x.*exp(-j*2*pi*250*t);
    phi = angle(z);
    
    phi = unwrap(phi);            	  % restoring original phase
    dem = (1/(2*pi*kf))*(diff(phi)/ts); 	% demodulated signal
    
    figure
    subplot (3,1,1)
    plot (c(1:300))
    TITLE ('Carrier Signal')
    grid on;
    subplot (3,1,2)
    plot (u(1:300))
    TITLE ('Frequency Modulated Signal')
    grid on;
    subplot (3,1,3)
    dem = smooth(dem,7) + 1;
    plot (dem(1:300))
    axis ([0 300 -2 2]);
    TITLE ('De-Modulated Signal')
    grid on;
end