%===============================================================================
% Description : Acquire acoustic data from default system soundcard and plot
%               in both time and frequency domain.
%
% Parameters  : Fs          - Acquisition sample frequency   [44000] Hz
%               n_bits      - Sample size                    [16] bits
%               n_channels  - Number of channels to acquire 
%                             from sound card                [2]
%               update_rate - Polls sound card for data this 
%                             many times per second          [5] Hz
%
% Author      : Rodney Thomson
%               http://iheartmatlab.blogspot.com
%===============================================================================
function soundcardSpectralAnalysis(Fs, n_bits, n_channels, update_rate)

    % Initialise default parameters if not supplied
    if (~exist('Fs', 'var'))
        Fs          = 44000;
    end
    if (~exist('n_bits', 'var'))
        n_bits      = 16;
    end
    if (~exist('n_channels', 'var'))
        n_channels  = 2;
    end
    if (~exist('update_rate', 'var'))
        update_rate = 5;
    end

    plot_colors = hsv(n_channels);
    
    % Initialise plots, one above each other in a single figure window
    figure;

    % Time Domain plot
    subplot(2,1,1)
    hold on
    for i_channel = 1:n_channels
        time_domain_plots(i_channel) = plot(nan, nan, ...
                                            'Color', plot_colors(i_channel, :));
    end
    xlabel('Sample')
    ylabel('Counts')
    
    y_max = 2^(n_bits-1);
    ylim([-y_max y_max]);

    % Frequency Domain plot
    subplot(2,1,2)
    hold on
    for i_channel = 1:n_channels
        freq_domain_plots(i_channel) = plot(nan, nan, ...
                                            'Color', plot_colors(i_channel, :));
    end
    xlabel('Frequency (Hz)')
    ylabel('dB re 1 count/sqrtHz')
    xlim([0 Fs/2])
    ylim([0 70])
    
    % Setup the audiorecorder which will acquire data off default soundcard
    audio_recorder = audiorecorder(Fs, n_bits, n_channels);
    
    set(audio_recorder, 'TimerFcn', {@audioRecorderTimerCallback, ...
                                      audio_recorder,             ...   
                                      time_domain_plots,          ...
                                      freq_domain_plots});
    set(audio_recorder, 'TimerPeriod', 1/update_rate);
    set(audio_recorder, 'BufferLength', 1/update_rate);
    
    % Start the recorder
    record(audio_recorder);
    
end

%===============================================================================
% Description : Called when the AudioRecorder TimerFcn ticks. Grabs the current
%               data off the soundcard and plots both a time and frequency 
%               domain representation of the data.
%
% Parameters  : obj               - The object from which the event arose 
%                                   (audiorecorder)
%               event             - NULL
%               audio_recorder    - Unfortunately, despite not being used, this
%                                   needs to be supplied to the callback for the
%                                   timerfcn to work
%               time_domain_plots - array of time domain plots to update.
%                                   One per channel
%               freq_domain_plots - array of frequency domain plots to update.
%                                   One per channel
%===============================================================================
function audioRecorderTimerCallback(obj, event, audio_recorder, ...
                                    time_domain_plots, freq_domain_plots)

    Fs           = get(obj, 'SampleRate');
    num_channels = get(obj, 'NumberOfChannels');
    num_bits     = get(obj, 'BitsPerSample');

    try
        if (num_bits == 8)
            data_format = 'int8';
        elseif (num_bits == 16)
            data_format = 'int16';
        elseif (num_bits == 32)
            data_format = 'double';
        else
            error('Unsupported sample size of %d bits', num_bits);
        end
                                
        % stop the recorder, grab the data, restart the recorder. May miss some data
        stop(obj);
        data = getaudiodata(obj, data_format);
        record(obj);
        
        if (size(data, 2) ~= num_channels)
            error('Soundcard does not support acquisition of %d channels', ...
                  length(num_channels))
        end

        data_fft    = fft(double(data));
        fft_length  = length(data_fft);
        data_power  = 10*log10(abs(data_fft(1:fft_length/2, :)));
        freqs       = linspace(1, Fs/2, fft_length/2);

        for i_channel = 1:num_channels
            set(time_domain_plots(i_channel), 'XData', 1:size(data, 1),    ...
                                              'YData', data(:, i_channel))
                                                
            set(freq_domain_plots(i_channel), 'XData', freqs, ...
                                              'YData', data_power(:, i_channel))
        end
        
    catch
        % Stop the recorder and exit
        stop(obj)
        rethrow(lasterror)
    end
    
    drawnow;

end