%DECODER PORTION

function synth_speech = f_DECODER (aCoeff, pitch_plot, voiced, gain);


%re-calculating frame_length for this decoder,
frame_length=1;
for i=2:length(gain)
    if gain(i) == 0,
        frame_length = frame_length + 1;
    else break;
    end
end

%decoding starts here,
for b=1 : frame_length : (length(gain)),    %length(gain) should be very close 
                                            %(i.e less than a frame_length error) to length(x)
    
    %FRAME IS VOICED OR UNVOICED
    if voiced(b) == 1,   %voiced frame
            pitch_plot_b = pitch_plot(b);
        syn_y1 = f_SYN_V (aCoeff, gain, frame_length, pitch_plot_b, b);
    else syn_y1 = f_SYN_UV (aCoeff, gain, frame_length, b); %unvoiced frame
    end
    
    synth_speech(b:b+frame_length-1) = syn_y1;
end