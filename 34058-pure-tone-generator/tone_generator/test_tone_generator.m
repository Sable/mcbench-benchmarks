% TEST_TONE_GENERATOR Demo for the TONE_GENERATOR routine.
%
%   See also TONE_GENERATOR.

%   Author: Kamil Wojcicki, UTD, November 2011.

clear all; close all; clc; randn('seed',0); rand('seed',0); fprintf('.\n');


    % inline function for periodogram spectrum computation
    psd = @(x,w,nfft)( 10*log10(abs(fftshift(fft(x(:).'*diag(w(length(x))),nfft))).^2/length(x)) );

    
    % define common parameters
    fs = 16E3;                              % sampling frequency (Hz)
    duration = 60;                          % signal duration (ms)
    N = floor(duration*1E-3*fs);            % signal length (samples)
    nfft = 2^nextpow2( 4*N );               % FFT analysis length
    freq = [ 0:nfft-1 ]/nfft*fs - fs/2;     % frequency vector (Hz)
%   window = @hanning;                      % analysis window function
%   window = @(N)( chebwin(N,40) );         % analysis window function
    window = @(N)( chebwin(N,100) );        % analysis window function
 

    % define parameters specific to generation of the single pure tone signal
    amplitude = 1;                          % pure tone amplitude
    frequency = 5E2;                        % pure tone frequency (Hz)
    phase = pi/16;                          % pure tone phase (rad/sec)
    fade_duration = 20;                     % fade-in and fade-out duration (ms)
    fade_window = @(N)( hanning(N).^2 );    % fade-in and fade-out window function handle
    
    % generate a pure tone
    [ tone, time ] = tone_generator( fs, duration, amplitude, frequency, phase, fade_duration, fade_window );

    % compute spectrum of the pure tone signal
    P.tone = psd( tone, window, nfft ); 


    % define parameters specific to generation of the mixture of pure tones
    amplitudes = [ 0.25 0.025 1 ];          % pure tone amplitudes
    frequencies = [ 1E2 5E2 1E3 ];          % pure tone frequencies (Hz)
    phases = [ pi/3 0 pi/7 ];               % pure tone phase (rad/sec)
    fade_durations = [ 30 10 ];             % fade-in and fade-out durations (ms)
 
    % fade-in and fade-out window function handles
    fade_windows = { @(N)(hanning(N).^2) @(N)(chebwin(N,100)) }; 
    
    % generate a mixture of pure tones
    tones = tone_generator( fs, duration, amplitudes, frequencies, phases, fade_durations, fade_windows );

    % compute spectrum of the mixture of pure tones
    P.tones = psd( tones, window, nfft ); 

 
    % plot generated tones
    hfig = figure( 'Position', [ 1038 363 800 500 ], 'PaperPositionMode', 'auto', 'color', 'w');    
    
    % plot single-tone waveform
    subplot( 2,2,1 );
    plot( time, tone );
    xlim( [ min(time) max(time) ] );
    ylim( [ min(tone)-0.25*max(tone) 1.25*max(tone) ] );
    xlabel( 'Time (s)' );
    ylabel( 'Amplitude' );
    title( sprintf('Pure tone waveform: %0.0f Hz (Fs=%i Hz)',frequency,fs) );
    set(gca, 'box', 'off'); 
 
    % plot multi-tone waveform
    subplot( 2,2,2 );
    plot( time, tones );
    xlim( [ min(time) max(time) ] );
    ylim( [ min(tones)-0.25*max(tones) 1.25*max(tones) ] );
    xlabel( 'Time (s)' );
    ylabel( 'Amplitude' );
    title( sprintf('Mixture of pure tones waveform: %s Hz (Fs=%i Hz)',sprintf('%0.0f, ',frequencies),fs) );
    set(gca, 'box', 'off');

    % plot single-tone spectrum
    subplot( 2,2,3 );
    plot( freq, P.tone );
    xlim( 2.5*[-max(frequency) max(frequency)] );
    ylim( [-120 20] );
    xlabel( 'Frequency (Hz)' );
    ylabel( 'Magnitude (dB)' );
    title( sprintf('Pure tone spectrum: %0.0f Hz',frequency) );
    set(gca, 'box', 'off'); 
 
    % plot multi-tone spectrum
    subplot( 2,2,4 );
    plot( freq, P.tones );
    xlim( 2.5*[-max(frequencies) max(frequencies)] );
    ylim( [-120 max(P.tones) ] );
    xlabel( 'Frequency (Hz)' );
    ylabel( 'Magnitude (dB)' );
    title( sprintf('Mixture of pure tones spectrum: %s Hz',sprintf('%0.0f, ',frequencies)) );
    set(gca, 'box', 'off'); 


    % print figure to png
    print( '-dpng', sprintf('%s.png',mfilename) );


% EOF
