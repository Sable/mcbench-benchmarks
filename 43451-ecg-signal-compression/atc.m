function [Out_Sig, Sig] = atc(In_Sig,th)
% This function atc implements Amplitude Thresholding compression as
% mentioned in paper Methods for ECG signal compression with reconstruction
% via cubic spline approximation by Olga Malgina, Jana Milenkovi, Emil
% Plesnik, Matej Zajc, Andrej Košir and Jurij F. Tasi.
% INPUT:
%         In_Sig = row vectors containing samples of input ECG signals
%         th = single element vector specifying threshold for amplitude
% OUTPUT:
%         Out_Sig = Compressed ECG signal
%         Sig = Output signals containing actual number of samples with
%               not stored samples

% Checking input arguments
if nargin<2||isempty(th),th = 0.07;end
if nargin<1||isempty(In_Sig),error('Not enough input arguments');end

% Implmentation starts here
N = length(In_Sig); % Number of samples in an Input ECG signal
Sig = In_Sig;   % Temporary variable
% Amplitude Thresholding compression
for k = 1:N-2
    if abs((In_Sig(k) - In_Sig(k+2))) < th
        Sig(k+1) = NaN;
    end
end
% Neglect not stored samples
Sig = Sig(~isnan(Sig));
% Cubic Spline approximation
Out_Sig = spline(1:length(Sig),Sig,linspace(1,length(Sig),length(Sig)));