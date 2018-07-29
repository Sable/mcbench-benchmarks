% Snippets of code to show how PerkinElmer imaging data may be used.
%
% The images and plots are set to look similar to their display in
% PerkinElmer software such as SpectrumIMAGE.

% Load a full spectral image and play it
[data4, xaxis4, yaxis4, zaxis4, misc4] = fsmload('c:\pel_data\Spotlight\Tutorial\lamdemo.fsm');
fsmplaydata(data4, 5);          % 5 frames per second

% Display the first single wavelength image in colour with axes
imagesc(xaxis4, yaxis4, data4(:,:,1));
set(gca, 'YDir', 'normal');

% Display a grey scale image using the Imaging Toolbox imshow function.
imshow(data4(:,:,1), [], 'InitialMagnification', 'fit');
set(get(gca, 'XLabel'), 'string', misc4(1, 2));
set(get(gca, 'YLabel'), 'string', misc4(2, 2));

% Plot the spectrum from the top left point in the image
plot(zaxis4, reshape(data4(1, 1, :), size(zaxis4)));
if zaxis4(1) > zaxis4(2)
    set(gca, 'XDir', 'reverse')
end

% Load an intensity map and display it in colour using the standard imagesc function.
% This auto-ranges the colour key.
% The Y axis defaults to 'reverse' so has to be set 'normal'.
[data3, xaxis3, yaxis3, misc3] = impload('c:\pel_data\spotlight\tablet\sucrose.imp');
imagesc(xaxis3/1000, yaxis3/1000, data3);               % assumes source is micrometers
set(gca, 'YDir', 'normal');
set(get(gca, 'XLabel'), 'string', 'mm');
set(get(gca, 'YLabel'), 'string', 'mm');
set(get(gca, 'Title'), 'string', misc3(4,2));           % fourth element is alias

% Load a spectrum and plot it
[data2, xaxis2, misc2] = spload('c:\pel_data\Spotlight\Calibration\ng11.sp');
plot(xaxis2, data2);
if xaxis2(1) > xaxis2(2)
    set(gca, 'XDir', 'reverse')
end

% Load a line scan and display
% This uses fsmload() as lsc files are based on single row fsm files.
[data1, xaxis1, yaxis1, zaxis1, misc1] = fsmload('c:\pel_data\Spotlight\Tutorial\lam1a.lsc');
imagesc(zaxis1, xaxis1, permute(data1, [2 3 1]));
if zaxis1(1) > zaxis1(2)
    set(gca, 'XDir', 'reverse')
end
set(gca, 'YDir', 'normal');


% Load a line scan and display
% This uses lscload() which retrieves angle and thus stage position information as well.
[data1, waxis1, daxis1, xaxis1, yaxis1, misc1] = lscload('c:\pel_data\Spotlight\Tutorial\lam1a.lsc');
imagesc(waxis1, daxis1, data1);
if waxis1(1) > waxis1(2)
    set(gca, 'XDir', 'reverse')
end
set(gca, 'YDir', 'normal');


% imshow from the Imaging Toolbox can open Spotlight/AutoIMAGE .vis files
% directly.
imshow('c:\pel_data\Spotlight\Tutorial\lamdemo.vis');

% To get the image size information, use visload().
% visload() uses imread() from the Imaging Toolbox to read the bitmap.
[data0, xaxis0, yaxis0] = visload('c:\pel_data\Spotlight\Tutorial\lamdemo.vis');
imagesc(xaxis0, yaxis0, data0);
set(gca, 'ydir', 'normal');



