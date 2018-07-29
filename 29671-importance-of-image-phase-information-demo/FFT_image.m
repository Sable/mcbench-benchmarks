function [imageInGray_fft_amplitudeOnly, imageInGray_fft_phaseOnly] = FFT_image( imageInGray )
%FFT_IMAGE 

% perform fft2
imageInGray_fft = fft2(imageInGray);
% get the magnitude
imageInGray_fft_amplitudeOnly = abs(imageInGray_fft);
% get the phase
imageInGray_fft_phaseOnly = imageInGray_fft./imageInGray_fft_amplitudeOnly;

end

