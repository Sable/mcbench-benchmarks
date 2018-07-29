function [vFrequency, vAmplitude] = fastfft(vData, SampleRate, Plot)

%FASTFFT   Create useful data from an FFT operation.
%   Usage: [vFrequency, vAmplitude] = fastfft(vData, SampleRate, [Plot])
%   
%   (no plot will be shown if the last input == 0 or is not included)
%
%   This function inputs 'vData' as a vector (row or column),
%   'SampleRate' as a number (samples/sec), 'Plot' as anything,
%   and does the following:
%
%     1: Removes the DC offset of the data
%     2: Puts the data through a hanning window
%     3: Calculates the Fast Fourier Transform (FFT)
%     4: Calculates the amplitude from the FFT
%     5: Calculates the frequency scale
%     6: Optionally creates a Bode plot
%
%   Created 7/22/03, Rick Auch, mekaneck@campbellsville.com

%Make vData a row vector
if size(vData,2)==1
    vData = vData';
end

%Calculate number of data points in data
n = length(vData);

%Remove DC Offset
vData = vData - mean(vData);

%Put data through hanning window using hanning subfunction
vData = hanning(vData);

%Calculate FFT
vData = fft(vData);

%Calculate amplitude from FFT (multply by sqrt(8/3) because of effects of hanning window)
vAmplitude = abs(vData)*sqrt(8/3);

%Calculate frequency scale
vFrequency = linspace(0,n-1,n)*(SampleRate/n);

%Limit both output vectors due to Nyquist criterion
DataLimit = ceil(n/2);
vAmplitude = vAmplitude(1:DataLimit);
vFrequency = vFrequency(1:DataLimit);

if exist('Plot', 'var')==1 & Plot~=0
    plot(vFrequency, vAmplitude);
    title('Bode Plot');
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
end


%------------------------------------------------------------------------------------------
%Hanning Subfunction
function vOutput = hanning(vInput)
% This function takes a vector input and outputs the same vector,
% multiplied by the hanning window function

%Determine the number of input data points
n = length(vInput);

%Initialize the vector
vHanningFunc = linspace(0,n-1,n);

%Calculate the hanning funtion
vHanningFunc = .5*(1-cos(2*pi*vHanningFunc/(n-1)));

%Output the result
vOutput = vInput.*vHanningFunc;