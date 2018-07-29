function [ tone, time ] = tone_generator( sampling_frequency, duration, amplitudes, frequencies, phases, fade_durations, fade_windows )
% TONE_GENERATOR Generate pure tone or mixture of pure tones.
%
%   T=TONE_GENERATOR(FS,D,A,F,P,FD) generate and return in T samples of
%   a pure tone, or mixture of pure tones, with sampling frequency FS,
%   signal duration D, tone amplitudes A, tone frequencies F, tone 
%   phases P and fade-in and fade-out durations FD. 
%   
%   Inputs
%           FS sampling frequency (Hz).
%
%           D signal duration (ms).
%
%           A tone amplitude(s) as a scalar or vector, respectively.
%
%           F tone frequency/frequencies as a scalar or vector, respectively.
%
%           P tone phase(s) as a scalar or vector, respectively.
%
%           FD fade-in and fade-out durations (ms) as a scalar
%              (if same), or as a two element vector.
%
%   Outputs 
%           T pure tone, or a mixture of pure tones.
%
%   Examples
%           clear all; close all; clc;              % clear MATLAB environment
%
%           fs   = 16E3;                            % sampling frequency (Hz)
%           duration = 1E3;                         % pure tone duration (ms)
%
%           amplitude = 1;                          % pure tone amplitude
%           frequency = 1E2;                        % pure tone frequency (Hz)
%           phase = pi/3;                           % pure tone phase (rad/sec)
%           fade_duration = 250;                    % fade-in and fade-out duration (ms)
%           fade_window = @(N)( hanning(N).^2 );    % fade-in and fade-out window function handle
%           
%           % generate a pure tone
%           [ tone, time ] = tone_generator( fs, duration, amplitude, frequency, phase, fade_duration, fade_window );
%
%           amplitudes = [ 0.0125 0.25 1 ];         % pure tone amplitudes
%           frequencies = [ 3 10 100 ];             % pure tone frequencies (Hz)
%           phases = [ pi/3 0 pi/7 ];               % pure tone phase (rad/sec)
%           fade_durations = [ 250 100 ];           % fade-in and fade-out durations (ms)
%
%           % fade-in and fade-out window function handles
%           fade_windows = { @(N)(hanning(N).^2) @(N)(chebwin(N,100)) }; 
%           
%           % generate a mixture of pure tones
%           tones = tone_generator( fs, duration, amplitudes, frequencies, phases, fade_durations, fade_windows );
%
%           % plot generated tones
%           figure( 'Position', [ 10 10 600 800 ], 'PaperPositionMode', 'auto', 'color', 'w');    
%           
%           % plot the pure tone
%           subplot( 2,1,1 );
%           plot( time, tone );
%           xlim( [ min(time) max(time) ] );
%           ylim( [ min(tone)-0.25*max(tone) 1.25*max(tone) ] );
%           xlabel( 'Time (s)' );
%           ylabel( 'Amplitude' );
%           title( sprintf('Pure tone: %0.0f Hz',frequency) );
%           set( gca, 'box', 'off' ); 
%
%           % plot the mixture of pure tones
%           subplot( 2,1,2 );
%           plot( time, tones );
%           xlim( [ min(time) max(time) ] );
%           ylim( [ min(tones)-0.25*max(tones) 1.25*max(tones) ] );
%           xlabel( 'Time (s)' );
%           ylabel( 'Amplitude' );
%           title( sprintf('Mixture of pure tones: %s Hz', sprintf('%0.0f, ',frequencies) ) );
%           set( gca, 'box', 'off' ); 
%
%           % print figure to png file
%           print( '-dpng', 'tone_generator.png' );
%
%   See also TEST_TONE_GENERATOR, FADE.

%   Author: Kamil Wojcicki, UTD, November 2011.


    % sampling period (s)
    sampling_period = 1/sampling_frequency;

    % time vector
    time = [ 0:sampling_period:duration*1E-3 ];

    % generate separate tone (as row vectors)
    tone = diag( amplitudes ) * cos( 2*pi*diag(frequencies)*repmat(time,length(frequencies),1) + repmat(phases.',1,length(time)) ); 
    
    % combine sinusoid components
    tone = sum( tone, 1 );

    % return if fade-in and fade-out is not needed
    if nargin==5 || ( islogical(fade_durations) && fade_durations==false ), return; end;

    % fade signal boundaries
    tone = fade( tone, sampling_frequency, fade_durations, fade_windows );


% EOF
