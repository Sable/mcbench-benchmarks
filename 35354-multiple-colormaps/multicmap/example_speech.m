% EXAMPLE_SPEECH Multicmap demo for speech (spectrogram) plots.
%
%   Optional requirements: MATLAB Signal Processing Toolbox.
%
%   See also MULTICMAP, EXAMPLE_TWO_IMAGES, EXAMPLE_THREE_IMAGES.

%   Author: Kamil Wojcicki, UTD, February 2012.

clear all; close all; clc; fprintf('.\n');


    % Anonymous function for custom colormap generation
    custom_colormap = @(N,red,green,blue)( [ ones(N,1).*linspace(red(1),red(2),N).' ones(N,1).*linspace(green(1),green(2),N).' ones(N,1).*linspace(blue(1),blue(2),N).' ] );

    % Anonymous function for generating indices that can be 
    % used to convert a vector into overlapped blocks 
    blocking_indices = @( Nw, Ns, M )( repmat(Ns*[0:(M-1)].',1,Nw) + repmat([1:Nw],M,1) );  % (blocks as rows)
    blocking_indices = @( Nw, Ns, M )( repmat(Ns*[0:(M-1)],Nw,1) + repmat([1:Nw].',1,M) );  % (blocks as columns)

    % Anonymous function for spectrogram computation 
    % without the need for the signal processing toolbox
    myspectrogram = @(frames,nfft,window)( abs(fft(diag(window(size(frames,1)))*frames,nfft,1)) );

    % Read clean and noisy speech data from file
    [ speech.noisy, fs , nbits ] = wavread( 'noisy.wav' );
    [ speech.clean, fs , nbits ] = wavread( 'clean.wav' );

    % Specify analysis settings
    Tw = 32;                    % analysis frame duration (ms)
    Ts = Tw/8;                  % analysis frame shift (ms)
    Nw = round( Tw*1E-3*fs );   % analysis frame length (samples)
    Ns = round( Ts*1E-3*fs );   % analysis frame shift (samples)
    nfft = 2^nextpow2( 4*Nw );  % FFT analysis length
    window = @hanning;          % analysis window function handle

    % Compute spectrograms (using MATLAB Signal Processing Toolbox)
    if false

        [ specgram.noisy, F, T ] = spectrogram( speech.noisy, window(Nw).', Nw-Ns, nfft, fs );
        [ specgram.clean, F, T ] = spectrogram( speech.clean, window(Nw).', Nw-Ns, nfft, fs );

    % Compute spectrograms (without MATLAB Signal Processing Toolbox)
    else

        % Number of overlapped segments
        M = floor( (length(speech.clean)-Nw)/Ns );
    
        % Truncate the speech signal to get exact number of segments
        speech.noisy = speech.noisy(1:M*Ns+Nw);
        speech.clean = speech.clean(1:M*Ns+Nw);
    
        % Generate matrix of segment indices 
        indices = blocking_indices( Nw, Ns, M );
        
        % Divide speech signals to frames
        frames.noisy = speech.noisy( indices );
        frames.clean = speech.clean( indices );
    
        % Compute STFT power spectrum
        specgram.noisy = myspectrogram( frames.noisy, nfft, window );
        specgram.clean = myspectrogram( frames.clean, nfft, window );

        % Define time and frequency vectors
        T = [ 0:M-1 ] * Ts * 1E-3;
        F = [ 0:nfft-1 ] / nfft * fs;

    end

    % Normalize and convert to dB
    specgram.noisy = 20*log10( abs(specgram.noisy) / max(abs(specgram.noisy(:))) );
    specgram.clean = 20*log10( abs(specgram.clean) / max(abs(specgram.clean(:))) );
    
    % Define colormaps
    maps.noisy = 1-gray(512);
    maps.clean = custom_colormap( 128, [0 0], [0.7 1], [0 0] );

    % Specify dynamic ranges limits (lower, upper) in dB for the spectrogram plots
    dranges.noisy = [ -55 0 ];
    dranges.clean = [ -42 0 ];

    % Define transparency for visible parts of each image
    alpha.noisy = 1;           % fully opaque
    alpha.clean = 0.25;        % 75% transparency

    % Define which parts of the second image are to be fully transparent (invisible)
    AlphaData.clean = ones( size( specgram.clean ) ) * alpha.clean;
    AlphaData.clean( specgram.clean<=dranges.clean(1) ) = 0;


    %% Plot spectrograms with their respective colormaps

    % Create a figure
    hfig = figure( 'Position', [ 745 345 800 350 ], 'PaperPositionMode', 'auto', 'color', 'w' );

    % Make sure both images get retained in the current axes
    hold on;

    % Plot images and retain handles to the image objects
    h.noisy = image( T, F, specgram.noisy );
    h.clean = image( T, F, specgram.clean );

    % Apply transparency settings
    set( h.noisy, 'AlphaData', alpha.noisy );
    set( h.clean, 'AlphaData', AlphaData.clean );

    % Apply axes limits 
    xlim( [ min(T) max(T) ] );
    ylim( [ 100 fs/2-300 ] );

    % Make sure our images are not up-side-down
    axis xy

    % Label the axes
    xlabel( 'Time (s)' );
    ylabel( 'Frequency (Hz)' );
    
    % Apply separate colormaps to noisy and clean speech
    multicmap( h, maps, dranges );

    % Print figure to png file
    print( '-dpng', mfilename );


% EOF
