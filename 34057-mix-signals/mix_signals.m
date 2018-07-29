function [ mixed ] = mix_signals( base, signal, fs, location )
% MIX_SIGNALS Mix two signals at a given location.
%
%   MIXED=MIX_SIGNALS(BASE,SIGNAL,FS,LOCATION) mix by addition 
%   the mix-in SIGNAL within the BASE signal at LOCATION ms.
%   Each signal is assumed to be sampled at FS Hz. 
%
%   Inputs
%           BASE base input signal as vector.
%
%           SIGNAL mix-in input signal as vector.
%
%           FS sampling frequency (Hz).
%
%           LOCATION location (ms) where the mix-in signal is 
%                    to be mixed (added) with the base signal.
%
%   Outputs 
%           MIXED mixed base and mix-in signals as vector.
%
%   Examples
%           clear all; close all; clc;                      % clear MATLAB environment
%
%           fs = 16E3;                                      % sampling frequency (Hz)
%
%           base.duration = 1E3;                            % base signal duration (ms)
%           base.length = round(base.duration*1E-3*fs);     % base signal length (samples)
%           base.time = [ 0:base.length-1 ] / fs;           % base signal time vector (s)
%
%           % generate base signal: 1 second of white Gaussian noise (WGN)
%           base.signal = randn( 1, base.length ) .* sqrt( 1E-4 ); 
%
%           mixin.duration = 5E2;                           % mix-in signal duration (ms)
%           mixin.length = round(mixin.duration*1E-3*fs);   % mix-in signal length (samples)
%           mixin.location = 2E2;                           % mix-in signal location (ms) within the base signal
%           mixin.time = [ 0:mixin.length-1 ] / fs;         % mix-in signal time vector (s)
%
%           % generate mix-in signal: 500 millisecond decaying chirp from 0 Hz to 150 Hz
%           mixin.signal = chirp( mixin.time, 0, mixin.duration*1E-3, 150 ); 
%           mixin.signal = mixin.signal .* exp(linspace(0,-5,mixin.length));
%
%           % mix the base and mix-in signals
%           [ mixed.signal ] = mix_signals( base.signal, mixin.signal, fs, mixin.location );
%
%           % plot generated tones
%           hfig = figure( 'Position', [ 10 10 500 300 ], 'PaperPositionMode', 'auto', 'color', 'w');
%           plot( base.time, mixed.signal, 'k-' ); 
%           xlim( [ min(base.time) max(base.time) ] );
%           ylim( [ min(mixed.signal)-0.05*max(mixed.signal) 1.05*max(mixed.signal) ] );
%           xlabel( 'Time (s)', 'FontSize', 7 );
%           ylabel( 'Amplitude', 'FontSize', 7 );
%           set( gca, 'box', 'off', 'FontSize', 7 ); 
%
%           % print figure to png file
%           print( '-dpng', 'mix_signals.png' );

%   Author: Kamil Wojcicki, UTD, November 2011.


    % check that required inputs have been supplied
    if nargin~=4, help(mfilename); return; end;

    % length of the base signal
    B = length( base );

    % length of the signal to mix-in with the base signal
    S = length( signal );

    % location (in samples) where the mix-in signal 
    % should be added within the base signal
    L = round( location*1E-3*fs );

    % sanity check...
    if L+S-1>B
        error( sprintf('The mix-in signal has to be placed within base signal.\nPlease check the lengths of the base signal (%i samples), the mix-in signal (%i samples)\nand the location (%i samples) where the mix-in signal is to be placed within the base signal.',B,S,L) ); 
    end

    % index range within the base signal 
    % where mix-in signal is to be placed
    index = L:L+S-1;

    % mixed signal is composed of the base signal
    mixed = base;

    % as well as the additive mix-in signal
    mixed(index) = mixed(index) + signal;


% EOF
