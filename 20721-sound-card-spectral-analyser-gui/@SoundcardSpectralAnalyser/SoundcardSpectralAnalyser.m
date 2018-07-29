%===============================================================================
% Description : Acquires acoustic data from default system soundcard and plot
%               in both time and frequency domain to the specified handles
%
% Parameters  : time_plot    - Plot handle into which to update raw data
%               freq_plot    - Plot handle into which to update frequency
%                                  domain data
%               'Fs'         - Acquisition sample frequency   [44000] Hz
%               'SampleSize' - Sample size                    [16] bits
%               'Channels'   - Number of channels to acquire 
%                              from sound card                [2]
%               'UpdateRate' - Polls sound card for data this 
%                              many times per second          [5] Hz
%
% Usage       : SoundcardSpectralAnalyser(p_time, p_freq);
%                 creates a SoundcardSpectralAnalyser object with default
%                 processing parameters
%
%               or using non default value pairs:
%
%               SoundcardSpectralAnalyser(p_time, p_freq, 
%                                         'Fs', 96000,
%                                         'SampleSize', 24, 
%                                         'Channels', 2, 
%                                         'UpdateRate', 10);
%
%               Alternatively the value pairs can be set using the 'set' method
%
% Author      : Rodney Thomson
%               http://iheartmatlab.blogspot.com
%===============================================================================
function this = SoundcardSpectralAnalyser(time_plot, freq_plot, varargin)

    % Initialise default parameters if not supplied
    this.Fs          = 44000;
    this.n_bits      = 16;
    this.n_channels  = 2;
    this.update_rate = 5;
    
    this.time_plot = time_plot;
    this.freq_plot = freq_plot;
    
    this.audio_recorder = [];

    this = class(this, 'SoundcardSpectralAnalyser');
    
    % Set parameters as supplied
    this = set(this, varargin{:});
    
end

