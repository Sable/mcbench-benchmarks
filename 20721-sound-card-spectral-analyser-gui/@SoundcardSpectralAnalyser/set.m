% SoundcardSpectralAnalyser/set - Set processing parameters
%===============================================================================
% 'Fs'         - Acquisition sample frequency (Hz)
% 'SampleSize' - Sample size (bits)
% 'Channels'   - Number of channels to acquire from sound card
% 'UpdateRate' - Polls sound card for data this many times per second (Hz)
%===============================================================================
function this = set (this, varargin)
    
    if (mod(length(varargin), 2) ~= 0)
        warning('Parameters must be supplied in Key/Value pairs.');
        return;
    end
    
    for i_param = 1:2:(length(varargin) - 1)
        
        switch varargin{i_param}
            case 'Fs'
                this.Fs = varargin{i_param+1};
            case 'SampleSize'
                this.n_bits = varargin{i_param+1};
            case 'Channels'
                this.n_channels = varargin{i_param+1};
            case 'UpdateRate'
                this.update_rate = varargin{i_param+1};
            otherwise
                warning('Unknown parameter : %s\n', varargin{i_param});
        end
    end
end