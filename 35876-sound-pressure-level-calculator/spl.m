function [SPL] = spl(p_Pa,ref)
% Calculate sound pressure level (in dB) of given pressure signal 'p_Pa'.
% Chad Greene 2012
% Pressure signal input p_Pa must be in units of pascals.  
% Pressure signal vector should be long enough to capture nature of the
% signal.  In other words, a single pressure value is not sufficient for
% root-mean-square calculation.
% Note that this does account for frequency content.  A-weighted decibels
% (dBA) are frequency-dependent.  This function does not compute dBA. 
% 
% Example using Matlab's built-in train whistle sound: 
% 
% load train % (let's assume y is has pascals as its units)
% spl(y,'air')
% ans = 
%        84.6
%    
% The example above gives the same as the following:
% load train % (let's assume y is has pascals as its units)
% spl(y,20*10^-6)
% ans = 
%        84.6
%
% Note: Typically we only write decibels to integer values or one decimal
% place.  Anything on the hundredth-of-a-decibel level is probably just
% noise and can be ignored. 

% Calculate root mean square value of pressure signal
p_rms = sqrt(mean(p_Pa.^2));

% Define the correct reference pressure: 
switch ref
    case {'air','Air','AIR','gas','Gas','GAS'}
        p_ref = 20*1e-6; % reference pressure in air is typically 20 uPa

    case {'water','Water','WATER','liquid','Liquid','LIQUID','SALTWATER','saltwater','Saltwater'}
        p_ref = 1*1e-6; % reference pressure in water is typically 1 uPa
        
    otherwise
        p_ref = ref; % reference pressure can be any user-defined value 'ref'
end

SPL = 20*log10(p_rms/p_ref);
end



