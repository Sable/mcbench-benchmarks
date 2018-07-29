function signal = fade( signal, fs, T, window )
% FADE Fade (taper) signal at extremities.
%
%   FADE(SIGNAL,FS,T,WINDOW) returns SIGNAL with leading and trailing 
%   samples faded-in and faded-out, respectively. The signal is sampled
%   at FS Hz. The fade-in and fade-out durations are specified in T. 
%   The window function used for fading is supplied in WINDOW as a 
%   function handle.
%   
%   Inputs
%           SIGNAL input signal a vector.
%
%           FS sampling frequency (Hz).
%
%           T fade-in and fade-out durations (ms), as scalar (if same),
%             or as a two element vector.
%
%           WINDOW function handles for window functions used for 
%                  fading-in and fading-out of the input signal,
%                  as a single function handle, if same window 
%                  is to be used for fading-in and fading-out,
%                  or as a two element cell array of window function
%                  handles, if different window functions are to be used.
%
%   Outputs 
%           SIGNAL input signal with faded leading and trailing samples.
%
%   Examples
%           clear all; close all; clc;          % clear MATLAB environment
%
%           fs = 16E3;                          % signal sampling frequency (Hz)
%           duration = 1E3;                     % signal duration (ms)
%           length = round(duration*1E-3*fs);   % signal length (samples)
%           time = [ 0:length-1 ] / fs;         % signal time vector (s)
%           fade_durations = [ 350 100 ];       % fade-in and fade-out durations (ms)
%
%           % fade-in and fade-out window function handles
%           fade_windows = { @(N)(hanning(N).^2) @(N)(chebwin(N,100)) }; 
%           
%           original = ones( 1, length );
%           faded = fade( original, fs, fade_durations, fade_windows );
%
%           % plot generated tones
%           hfig = figure( 'Position', [ 10 10 500 300 ], 'PaperPositionMode', 'auto', 'color', 'w');
%           plot( time, original, 'r--', 'linewidth', 1.25 ); hold on;
%           plot( time, faded, 'b' );
%           xlim( [ min(time) max(time) ] );
%           ylim( [ min(faded)-0.05*max(faded) 1.05*max(faded) ] );
%           xlabel( 'Time (s)', 'FontSize', 7 );
%           ylabel( 'Amplitude', 'FontSize', 7 );
%           hleg = legend( 'Original', 'Tapered', 4 );
%           set( hleg, 'box', 'off', 'Position', get(hleg,'Position')-[0.05 0 0 0] );
%           set( gca, 'box', 'off', 'FontSize', 7 ); 
%
%           % print figure to png file
%           print( '-dpng', 'fade.png' );

%   Author: Kamil Wojcicki, UTD, November 2011.


    % check that required inputs have been supplied
    if nargin~=4, help(mfilename); return; end;

    % check that input is a vector
    if min( size(signal) )>1 
        error( 'Input signal has to be a vector.\n' );
    end

    % if only one fade was duration specified,
    % use it for both fade-in and fade-out durations
    if length(T)==1, T = [ T T ]; end;

    % if only one window was specified,
    % use it for both fade-in and fade-out windows
    if length(window)==1, window = { window window }; end;

    % get input signal length
    L = length( signal );

    % determine fade durations (samples)
    N = round( T*1E-3*fs );

    % determine whether the input signal is in row or column form
    if size(signal,1)==1, form='row';
    else size(signal,2)==1, form='col';
    end

    % design fade-in window
    fadein = fade_window( N(1), 'fadein', window{1}, form );

    % generate fade-out indices
    index = 1:N(1);

    % apply fade-in window 
    signal(index) = signal(index) .* fadein;


    % design fade-out window
    fadeout = fade_window( N(2), 'fadeout', window{2}, form );

    % generate fade-out indices
    index = L-N(2)+1:L;

    % apply fade-out window 
    signal(index) = signal(index) .* fadeout;



function window = fade_window( N, type, custom, form )
% FADE_WINDOW Design window for signal fading-in or fading-out.
%
%   FADE_WINDOW(N,TYPE,CUSTOM) returns WINDOW of length N samples 
%   for leading or trailing sample tapering of a signal as specified
%   by TYPE. Custom window function can be specified.
%   
%   Inputs
%           N fading duration (samples).
%
%           TYPE fading direction as string, 
%                i.e., 'fade-in' or 'fade-out'
%
%           CUSTOM function handle for tapering window function to 
%                  be used for fade-in or fade-out window design.
%                  Note that symmetric tapered window is assumed,
%                  and that for design purposes window of double 
%                  the length requested will be generated and then
%                  cut in half to retain the slope-up portion.
%
%           FORM specifies (as string) if the window should be 
%                in row (i.e., 'row') or column (i.e., 'col') form.
%
%   Outputs 
%           WINDOW window to be used for fading.

%   Author: Kamil Wojcicki, UTD, November 2011.


    % generate window samples
    if false
        % some hard-coded examples
%       window = triang( 2*N );
%       window = chebwin( 2*N, 100 );
        window = hanning( 2*N ).^2;
%       window = exp( linspace( -4,0,N ) );
    else
        % use a custom window instead
        window = custom( 2*N );
    end

    % ensure correct vector form
    switch lower( form )
    case 'col', window = window(:);
    case 'row', window = window(:).';
    end

    % truncate to half length (if 2*N was used)
    window = window(1:N);

    % scale to unit magnitude
    window = window / max( abs(window) );

    % time reverse for 'fade-out' option, ignore otherwise
    switch lower( type )
    case { 'fadeout', 'fade-out' },window = window(end:-1:1);
    end


% EOF
