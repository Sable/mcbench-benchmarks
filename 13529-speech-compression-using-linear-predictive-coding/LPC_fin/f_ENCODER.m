%ENCODER PORTION

%here,  fs = sampling frequency
%       aCoeff = LP coefficients
%       pitch = pitch periods
%       v = voiced or unvoiced decision bit
%       g = gain of frames

function [aCoeff, pitch_plot, voiced, gain] = f_ENCODER(x, fs, M);

if (nargin<3), M = 10; end   %prediction order=10; 


%INITIALIZATION;
b=1;        %index no. of starting data point of current frame
fsize = 30e-3;    %frame size
frame_length = round(fs .* fsize);   %=number data points in each framesize 
                                %of "x"
N= frame_length - 1;        %N+1 = frame length = number of data points in 
                            %each framesize

                            
%VOICED/UNVOICED and PITCH;     [independent of frame segmentation]
[voiced, pitch_plot] = f_VOICED (x, fs, fsize);



%FRAME SEGMENTATION for aCoeff and GAIN;
for b=1 : frame_length : (length(x) - frame_length),
    y1=x(b:b+N);     %"b+N" denotes the end point of current frame.
                %"y" denotes an array of the data points of the current 
                %frame
    y = filter([1 -.9378], 1, y1);  %pre-emphasis filtering

    %aCoeff [LEVINSON-DURBIN METHOD];
    [a, tcount_of_aCoeff, e] = func_lev_durb (y, M); %e=error signal from lev-durb proc
    aCoeff(b: (b + tcount_of_aCoeff - 1)) = a;  %aCoeff is array of "a" for whole "x"

    %GAIN;
        pitch_plot_b = pitch_plot(b); %pitch period
        voiced_b = voiced(b);
    gain(b) = f_GAIN (e, voiced_b, pitch_plot_b);
end
