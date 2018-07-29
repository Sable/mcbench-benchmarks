section_initializeVariablesAndSettings;

%% read images
targetFile = {'tomo.img', 'lena.bmp', 'bridge.img'};   % images
imageChoice = 1;
targetFile1 = strcat(targetFolder, '\', char(targetFile(imageChoice)));
image1 = readImage(targetFile1, 1); 

imageChoice = 2;
targetFile2 = strcat(targetFolder, '\', char(targetFile(imageChoice)));
image2 = readImage(targetFile2, 1); 

%% process
image1InGray = setImageToGray( image1 );
image2InGray = setImageToGray( image2 );
% adjust the size   
newSize = [350 350];
image1InGray = imresize(image1InGray, newSize);
image2InGray = imresize(image2InGray, newSize);

% perform fft2, obtain magnitude and phase information
[image1InGray_fft_amplitudeOnly, image1InGray_fft_phaseOnly] = FFT_image( image1InGray );
[image2InGray_fft_amplitudeOnly, image2InGray_fft_phaseOnly] = FFT_image( image2InGray );

% interleaved the 2 FFT2 results
image1_amplitudeOnlyWithImage2_phaseOnly = image1InGray_fft_amplitudeOnly.*image2InGray_fft_phaseOnly;
image2_amplitudeOnlyWithImage1_phaseOnly = image2InGray_fft_amplitudeOnly.*image1InGray_fft_phaseOnly;
% take only the real parts
image1_amplitudeWithImage2_phase_realOnly = real(ifft2(image1_amplitudeOnlyWithImage2_phaseOnly));
image2_amplitudeWithImage1_phase_realOnly = real(ifft2(image2_amplitudeOnlyWithImage1_phaseOnly));

% recover image 1
imageInGray_InSpatialDomain = IFFT_image(image1InGray_fft_amplitudeOnly, image1InGray_fft_phaseOnly);

% display the FFT2 interleaved
section_plotResults;
% results commentary
section_resultsReporting;

