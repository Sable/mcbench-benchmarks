% SoundcardSpectralAnalyser/start - Start SoundcardSpectralAnalyser processing
%===============================================================================
function this = start(this)  
    
    % Setup the audiorecorder which will acquire data off default soundcard
    this.audio_recorder = audiorecorder(this.Fs, this.n_bits, this.n_channels);

    set(this.audio_recorder, 'TimerFcn', {@audioRecorderTimerCallback, ...
                                          this.time_plot, this.freq_plot});
    set(this.audio_recorder, 'TimerPeriod', 1/this.update_rate);
    set(this.audio_recorder, 'BufferLength', 1/this.update_rate);
    
    record(this.audio_recorder);    
end

%===============================================================================
% Description : Called when the AudioRecorder TimerFcn ticks. Grabs the current
%               data off the soundcard and plots both a time and frequency 
%               domain representation of the data.
%
% Parameters  : obj               - The object from which the event arose 
%                                   (audiorecorder)
%               event             - NULL
%               time_domain_plots - array of time domain plots to update.
%                                   One per channel
%               freq_domain_plots - array of frequency domain plots to update.
%                                   One per channel
%===============================================================================
function audioRecorderTimerCallback(obj, event, time_plot, freq_plot)

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
            set(time_plot(i_channel), ...
                'XData', 1:size(data, 1), 'YData', data(:, i_channel))
                                                
            set(freq_plot(i_channel), ...
                'XData', freqs, 'YData', data_power(:, i_channel))
        end        
    catch
        % Stop the recorder and exit
        stop(obj)
        rethrow(lasterror)
    end
    
    % Update the screen
    drawnow;

end