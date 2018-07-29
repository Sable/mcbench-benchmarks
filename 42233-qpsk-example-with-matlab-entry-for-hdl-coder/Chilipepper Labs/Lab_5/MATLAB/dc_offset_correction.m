function [i_out, q_out, rssi_out, rssi_en_out, dir_out, dir_en_out] = ...
    dc_offset_correction(i_in, q_in, alpha_in, gain_en_in, ...
        rssi_low_goal_in, rssi_high_goal_in, rx_en_in)

persistent i_dc q_dc i_mean q_mean
persistent counter rssi_sum
persistent dir_state
persistent rssiHold
persistent noise_offset noise_inc noise_dec

alpha = alpha_in/2^12;

if isempty(i_dc)
    i_dc = 0;
    q_dc = 0;
    i_mean = 0;
    q_mean = 0;
    counter = 0;
    noise_inc = 0;
    noise_dec = 0;
    noise_offset = 0;
    rssi_sum = 0;
    dir_state = 0;
    rssiHold = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DC Correction section
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if rx_en_in == 1
    i_mean = (1-alpha)*i_mean + alpha*i_in;
    q_mean = (1-alpha)*q_mean + alpha*q_in;

    i_dc = (1-alpha)*i_dc + alpha*i_in; %update the i dc offset
    q_dc = (1-alpha)*q_dc + alpha*q_in; %update the q dc offset

    if abs(i_mean) > (50 + noise_offset)  % too much noise, raise cieling.
        noise_inc = noise_inc + 1;
        i_dc = 0;
    else
        noise_dec = noise_dec + 1;
    end
    if abs(q_mean) > (50 + noise_offset)  % too much noise, raise cieling.
        noise_inc = noise_inc + 1;
        q_dc = 0;
    else
        noise_dec = noise_dec +1;
    end
    if (noise_inc > 10)
        %there is a high dc_offset value that needs to be corrected
        noise_offset = noise_offset + 10;
        noise_inc = 0;
    end
    if (noise_dec > 100000)
        %dc offset threshold is higher than needed
        noise_offset = noise_offset - 10;
        noise_dec = 0;
    end
end
i_out = i_in - i_dc;
q_out = q_in - q_dc;
%correct false positive/nagatives
if (abs(i_mean) < 50)
    noise_inc = 0;
end
if (abs(i_mean) > noise_offset - 10)
    noise_dec = 0;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RSSI Estimation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rssi_inst = i_out*i_out + q_out*q_out;
rssi_en_out = 0;
rssi_out = 0;

if rx_en_in == 1
    if counter == 0 && rssi_inst > 2*50*50
        counter = 1;
        rssi_sum = 0;
    end

    if counter ~= 0
        if rssi_inst < 2*50*50
            counter = 0;
        else
            counter = counter + 1;
            rssi_sum = rssi_sum + rssi_inst;

            if (counter >= 2^8 && i_mean < 50)
                counter = 0;
                rssi_out = round(rssi_sum/2^8);
                rssiHold = rssi_out;
                rssi_en_out = 1;
            else
                
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gain Correction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dir_out = 0;
dir_en_out = 0;

% dir_out = 0 - do nothing
% dir_out = 1 - increase
% dir_out = 2 - decrease
ai = abs(i_in);
aq = abs(q_in);
% only increase power if the rssi is away from the mean
rssi_diff = abs(rssiHold-(i_mean*i_mean+q_mean*q_mean));
if rx_en_in == 1
    switch dir_state
        case 0 % wait for some action and the processor is done (only runs when AGC function called)
            if (gain_en_in == 0)
                if rssi_en_out == 1
                    if rssi_diff < rssi_low_goal_in %too low - increase
                        dir_out = 1;
                        dir_en_out = 1;
                        dir_state = 1;
                    end
                    if rssi_diff > rssi_high_goal_in %too high - decrease
                        dir_out = 2;
                        dir_en_out = 1;
                        dir_state = 1;
                    end
                end
                % we're saturating the ADC so decrease gain
                % this overrides anything else
                if (ai > 1500) || (aq > 1500) 
                    dir_out = 2; % decrease
                    dir_en_out = 1;
                    dir_state = 1;
                end
            end
        case 1 % see if the MCU has done something and if so reset
            if (gain_en_in == 1)
                dir_out = 0;
                dir_en_out = 1;
                dir_state = 0;
            end
        otherwise
            dir_state = 0;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
