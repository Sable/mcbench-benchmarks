%% plotFFTdiffs.m
%This script is used to show the differences between just taking the fft of
%a function, and zeropadding the fft, and windowing the fft, and windowing
%with zeropadding. This script uses findFFT to calculate the ffts and then
%plots them.
%
%Notice how the normal fft does not give the correct amplitudes and
%has spectral leakage, while the windowed zeropadded fft gives both the
%correct amplitudes as well as very minimum spectral leakage. This is
%easily seen when looking at the peaks at frequencies 48 and 50. It is
%nearly impossible to determine if the peak at 50 is spectral leakage or
%not with the normal fft but with the windowed zeropadded fft it is clearly
%a frequency from the original signal.
%
%References
%   For an excellent introduction to FFTs, zeropadding, and windowing
%   http://blinkdagger.com/category/control-systems/
%
%   For an excellent article on windowing
%   http://www.ee.iitm.ac.in/~nitin/_media/ee462/fftwindows.pdf?id=jan07%3A
%   ee462%3Arefs&cache=cache
 
%To check that the corresponding amplitudes to frequencies are correct in 
%the fft you can modify them here, along with the other parameters
%
%Available window types are
% hann,hamming,flattopwin,blackman,kaiser,bohmanwin,gausswin
%zeronum is how many times bigger you want to zeropad the data
% i.e if your data has 100 datapoints and zeronum is ten then it will
% zeropad your data and give a vector with 1000 data points where the first
% 100 are the original and the rest are zeros
%
%--------------------------------------------------------------------------
%The sampling Frequency
sampFreq = 10000;
%Create the time vector
t = 0:1/sampFreq:3;
amps =  [10 20 12 15 5 35 27  2 58 34 68 48  46 71];
freqs = [10 20 35 15 50 2 63 96 54 71 48 68 105 87];
windowtype = 'hann';
zeronum = 10;
%--------------------------------------------------------------------------

%Create the signal
if length(amps) == length(freqs)
    for iter = 1:length(amps)
        if iter == 1
            y = amps(iter)*sin(2*pi.*t*freqs(iter));
        else
            y = amps(iter)*sin(2*pi.*t*freqs(iter)) + y;
        end
    end
else
    disp('Error: amps and freqs must be the same length');
    return
end

%Get the FFTs for all the different ways
[normamp freqnorm] = findFFT(y,'-sampFreq',sampFreq);
[zeropadamp freqzeropad] = findFFT(y,'-sampFreq',sampFreq,'-zeropad',zeronum);
[windowamp freqwindow] = findFFT(y,'-sampFreq',sampFreq,'-window',windowtype);
[windowzeropadamp freqwindowzeropad] = findFFT(y,'-sampFreq',sampFreq,'-window',windowtype,'-zeropad',zeronum);
%%
%Prepare the legend
legh_ = []; legt_ = {};

%Plot all the different FFTs on the same plot
figure2 = figure('Units','pixels','Position',[10 55 1200 860]);
h_ = plot(freqnorm,normamp,'b');
hold on;
legh_(end+1) = h_;
legt_{end+1} = 'Normal FFT';
h_ = plot(freqzeropad,zeropadamp,'r');
legh_(end+1) = h_;
legt_{end+1} = 'Zeropad FFT';
h_ = plot(freqwindow,windowamp,'k');
legh_(end+1) = h_;
legt_{end+1} = 'Windowed FFT';
h_ = plot(freqwindowzeropad,windowzeropadamp,'Color',[0 .8 .5]);
legh_(end+1) = h_;
legt_{end+1} = 'Windowed Zeropad FFT';

%Create legend
leginfo_ = {'Orientation', 'vertical', 'Location', 'NorthEast'};
h_ = legend(gca,legh_,legt_,leginfo_{:});

ind = find(freqs == max(freqs));
xlim([0 freqs(ind)+5]);
xlabel('Frequency');
ylabel('Amplitude');

%%
%This part is to check that the amplitude output is the correct values.
%Uncomment if desired
%maxout = max(windowzeropadamp);
%maxamp = max(amps);
%ampratio = maxout/maxamp;
%msgbox(['The output amplitude is ',num2str(ampratio),' times the input'],'Error');

























