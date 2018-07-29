%function for calc gain per frame


function [gain_b, power_b] = f_GAIN (e, voiced_b, pitch_plot_b); %gain of 1 (current) frame is returned
                                  %pitch_plot_b = pitch period of frame
                                  %starting at data point "b"
                                  
%GAIN
if voiced_b == 0,    %if frame starting at data point "b" is unvoiced
        denom = length(e);
    power_b = sum(e (1:denom) .^2) ./ denom;
    gain_b = sqrt( power_b );
else      %if frame starting at data point "b" is voiced
        denom = ( floor( length(e)./pitch_plot_b ) .* pitch_plot_b ); %see page 270 of main book
    power_b = sum( e (1:denom) .^2 ) ./ denom;
    gain_b = sqrt( pitch_plot_b .* power_b );
end

power_b;
gain_b;