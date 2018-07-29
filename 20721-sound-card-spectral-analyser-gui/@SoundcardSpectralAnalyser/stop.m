% SoundcardSpectralAnalyser/stop - Stop SoundcardSpectralAnalyser processing
%===============================================================================
function this = stop(this)    

    if (~isempty(this.audio_recorder))
        stop(this.audio_recorder);
    end    
end