function [ THD, ph, amp ] = compute_THD( t,x, freq )
% function [ THD, ph, amp ] = compute_THD( t,x, freq )
%
% Written by Dr. Yoash Levron
% February 2013.
%
% computes the Total-Harmonic-Distortion (THD)
% of a signal x(t). The amplitude and phase of the
% basic harmonic are also computed. These values
% are typically useful in power systems, audio signal
% processing, and other related fields.
%
% DC offset does not affect THD.
%
% The function computes the basic harmonic
% of the signal, in the form:
% x(t) = amp*cos(w*t - ph) + (higher Harmonics)
% where :  w = 2*pi*freq
% so 'amp' and 'ph' are the phase and amplitude
% of the basic harmonic.
%
% inputs:
% t - [sec] time vector. (should be periodical with basic harmonic 'freq')
% x - signal vector.
% freq - [Hz] frequency of the basic harmonic. 
%
% outputs:
% THD - total harmonic distortion (the scale is 1 = 100%).
% ph - [rad] phase of the basic harmonic.
% amp - Amplitude of the basic harmonic.

%%%%%%%%%%%% start function %%%%%%%%%%

%%% check that t,x are the same length
if (length(t) ~= length(x))
      'Error: t and x should be the same length'
      THD = NaN;   ph = NaN; amp = NaN;
      beep; return
end

if (size(t,2) == 1)
    t = t.';
end
if (size(x,2) == 1)
    x = x.';
end

%%% condition input time vector
input_error = 0;
%%% add two samples to complete the last cycle.
t = t - t(1);   % remove any time shift
dtt = t(end) - t(end-1);
t = [t (t(end)+dtt) (t(end)+2*dtt)];
x = [x x(end) x(end)];
T = t(end);
if (T < (1/freq) )
    input_error = 1;
end
if (input_error)
        'Error: Input time vector is illegal. Time samples should expand at least to 1/freq'
        THD = NaN;   ph = NaN; amp = NaN;
        beep; return
end

% truncate extra samples, to fit in an integer number of cycles of freq
T = floor(T * freq) /freq;

% resample on a linear grid:
% t1, x1 is the new input, not including the last sample
x = x - sum(x)/length(x);  % remove any DC offset
N = max(1e6, length(x));  % number of samples
dt = T/N;
t1 = 0:dt:(T-dt);
x1 = interp1(t,x,t1,'cubic');

%%% compute cos-sin fourier coefficients
w = 2*pi*freq;
acs = (2/T) * sum(x1.*cos(w*t1))*dt;  % basic frequency cos coefficient.
bsn = (2/T) * sum(x1.*sin(w*t1))*dt;  % basic frequency sin coefficient.
amp = (acs^2 + bsn^2)^0.5;
ph = pi/2 - sign(acs) * acos(bsn/amp);

rms22 = (2/T) * sum(x1.^2) * dt;
THD = (rms22/amp^2 - 1)^0.5;

% correct phase to be in the range [-pi : pi]
if (ph > pi)
    ph = ph - 2*pi;
end
if (ph < -pi)
    ph = ph + 2*pi;
end
    
end


