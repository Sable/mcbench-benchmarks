function imageInGray_InSpatialDomain = IFFT_image(imageInGray_fft_amplitudeOnly, imageInGray_fft_phaseOnly)
%IFFT_IMAGE 

% interleaved the 2 FFT2 results
image_amplitudeWith_phaseInFreqDomain = imageInGray_fft_amplitudeOnly.*imageInGray_fft_phaseOnly;
% take only the real parts
imageInGray_InSpatialDomain = real(ifft2(image_amplitudeWith_phaseInFreqDomain));

end

