%% Quantitative High-Throughput Gene Expression Imaging
%
% Knowledge of spatial and temporal patterns of gene expression is crucial
% for understanding the developmental processes in the embryo. To
% investigate these patterns, researchers typically stain an embryo with
% fluorescently tagged antibodies that bind to the product of an individual
% gene. The stain stains only those parts of the embryo in which the gene
% is expressed. This is known as _immunofluorescent histochemistry_. The
% embryo is then imaged using confocal microscopy, and visually inspected.
% Visual inspection of many images is slow and repetitive work. Automated
% image analysis to quantify the gene expression in the embryo remains an
% important task for bioinformatics.
%
% This demo uses the Image Processing and Curve Fitting Toolboxes.
%
% Sam Roberts

%   Copyright 2006 The MathWorks, Inc.

%% Load in and display an image
%
% The FlyEx database (http://flyex.ams.sunysb.edu/flyex/ and
% http://urchin.spbcas.ru/flyex) is a quantitative atlas of segmentation
% gene expression images. It contains images of fruit fly (_Drosophila
% melanogaster_) embryos at various stages of development (cleavage cycles
% 10-14A), as well as quantitative data extracted from these images. The
% images are stained with fluorescently tagged antibodies for the products
% of genes that are involved in the processes which begin to segment the
% fly embryo into different sections. We downloaded one image from cleavage
% cycle 14A, which has been stained with markers for the _even-skipped_
% (eve), _caudal_ and _bicoid_ genes.

iptsetpref('ImshowInitialMagnification','fit');

im = imread('rot_images/ab11-1-rot.jpg');

hfig1 = figure('WindowStyle','docked');
imshow(im)
title('Embryo ab11 (Cleavage Cycle 14A)');

%% Display image and the separate RGB channels
%
% We display the channels separately, and can see that the expression
% levels of the three genes varies along the anterior-posterior axis of the
% blastoderm. The expression of the genes in these areas causes the
% segmentation of the embryo.

subplot(2,2,1)
imshow(im)
title('Original Image')

colormap gray

subplot(2,2,2)
imshow(im(:,:,1))
title({'Red Channel -';'{\iteven-skipped} stained by RxR'})

subplot(2,2,3)
imshow(im(:,:,2))
title({'Green Channel -';'{\itcaudal} stained by Cy5'})

subplot(2,2,4)
imshow(im(:,:,3))
title({'Blue Channel -';'{\itbicoid} stained by FITC'})

%% Rotate the image to be in a standard position
%
% When the images are originally acquired from a confocal microscope, the
% embryos are positioned in arbitrary orientations.
%
% We would like to quantify the way that these genes are varying along the
% anterior-posterior axis. First we would like to rotate the image so that
% the anterior-posterior axis lies along the x-axis.
%
% Because the images as stored in the FlyEx database have been pre-aligned
% to horizontal, we have rotated the image by a random angle in order to
% demonstrate how we could align the images ourselves.

%% Calculate maximum of all three channels
%
% The first thing we need to do is to find the boundary of the embryo. The
% RGB color channels aren't going to help us with this. so we will
% calculate the maximum of the three channels.

RGBmax = max(im,[],3);

hfig2 = figure('WindowStyle','docked');

colormap gray

subplot(2,2,1)
imshow(RGBmax)
title({'Maximum of R, G and B';'channels'})

%% Find the brightness threshold of the embryo boundary
%
% If we look closely at the boundary of the embryo, we can see that whereas
% the brightness outside the embryo is fairly uniformly close to zero,
% within the boundary the brightness rapidly rises above 20. We can there
% fore construct a 'mask' of the embryo boundary by thresholding the image
% at a brightness of 20.
%
% Use the Pixel Region tool to interactively examine areas of the image
% close to the boundary.

hpixregtool = impixelregion(hfig2);

%% Get rid of the pixel region tool

close(hpixregtool);

%% Construct a mask by thresholding at 20

mask = im2bw(RGBmax,20/255);

subplot(2,2,2)
imshow(mask)
title('Thresholded at 20')

%% Remove some noise
%
% We use median filtering to remove some noise in the detected boundary.

mask = medfilt2(mask,[3,3]);

subplot(2,2,3)
imshow(mask)
title('Median filtered')

%% Smooth by dilating and eroding the boundary
%
% Finally we smooth the boundary using the closure operation.

mask = imclose(mask,strel('disk',5,0));

subplot(2,2,4)
imshow(mask)
title('Smoothed')

%% View the results
% 
% To see the results, we extract the perimeter of the mask and plot it
% superimposed on the original. We show a close-up view as well.

perim = bwperim(mask);
RGBmaxtemp = RGBmax;
RGBmaxtemp(perim) = 255;

hfig3 = figure('WindowStyle','docked');
colormap gray

subplot(1,2,1)
imshow(RGBmaxtemp)
title({'Boundary sumperimposed';'on original image'})

subplot(1,2,2)
imshow(RGBmaxtemp(500:700,200:400))
title('Close Up')

%% Find the angle of the major axis to the horizontal
%
% Now that we have estimated the boundary well, we can find some of its
% properties: in particular, since we are attempting to rotate the image to
% a standard orientation with a horizontal anterior- posterior axis, we
% will need to find the length and orientation of its major and minor axis.

L = bwlabel(mask);

stats = regionprops(L,...
    {'Orientation','MajorAxisLength','MinorAxisLength'});

disp(['The angle of the major axis to the horizontal is: ',...
    num2str(stats.Orientation),' degrees']);

%% Rotate the original image to be in a standard orientation
%
% We can use the calculated orientation to rotate the image so that the
% anterior-posterior axis is horizontal.

stdim = imrotate(im,-stats.Orientation);

%% Crop the image around the boundary
%
% We can use the calculated lengths of the major and minor axes of the
% boundary to crop the image to the boundary edges. Because not every
% boundary has the same size, this operation sometimes gives rise to
% half-pixel positions; rather than deal with this directly, for
% convenience we turn MATLAB's warning off before the operation and turn it
% back on afterwards.

ymidpoint = size(stdim,1)/2;
xmidpoint = size(stdim,2)/2;
yhalfheight = stats.MinorAxisLength/2;
xhalfheight = stats.MajorAxisLength/2;

warning off MATLAB:colon:nonIntegerIndex
stdim = stdim(ymidpoint-yhalfheight:ymidpoint+yhalfheight,...
    xmidpoint-xhalfheight:xmidpoint+xhalfheight,:);
warning on MATLAB:colon:nonIntegerIndex

hfig4 = figure('WindowStyle','docked');
imshow(stdim)
title({'Rotated and cropped'})

%% Find the outlines of the cell nuclei
%
% Having aligned the image to horizontal, the next task is to find
% boundaries for the cell nuclei. In order to do that we need to remove
% some of the background in the image and clean up some noise by smoothing
% the image.

%% Clear up windows
close([hfig1,hfig2,hfig3,hfig4]);

%% Recreate the RGB maximum channel
%
% The image has been rotated, so we will recreate a new RGB maximum image.

RGBmax = max(stdim,[],3);

hfig5 = figure('WindowStyle','docked');
colormap gray

subplot(2,1,1)
imshow(RGBmax)
title('Original Image')

%% Perform local histogram equalization
%
% We increase the contrast in local areas throughout the image using
% _adaptive histogram equalisation_. This runs through the image in blocks
% of 13-by-13 pixels, and in each block stretches the range of pixel
% intensities to ensure that they cover the full range of light to dark.
%
% We choose a block size of 13-by-13 as this roughly corresponds to the
% size of a cell nucleus.

RGBequal = adapthisteq(RGBmax,'NumTiles',...
    [ceil(size(RGBmax,1)/13),ceil(size(RGBmax,2)/13)]);

subplot(2,1,2)
imshow(RGBequal)
title('After Histogram Equalisation')

%% Perform Median Filtering
%
% We can remove some noise in the image as well using median filtering.

RGBequal = medfilt2(RGBequal);

subplot(2,1,2)
imshow(RGBequal)
title('After Median Filtering')

%% Threshold and label areas of image
%
% This time we threshold the image at 105, a reasonable level that
% represents the brightness of the edge of a nucleus.

bw = im2bw(RGBequal,105/255);
[L,num] = bwlabel(bw,4);

subplot(2,1,2)
imshow(bw)
title('After Thresholding')

%% Calculate the amount of the genes in each nucleus
%
% Having extracted the boundaries of the cell nuclei, we would now like to
% calculate the expression levels of the three genes in each nucleus and
% relate them to the position of the nucleus along the anterior-posterior
% axis.

%% Extract centroid and pixel list of each nucleus
%
% We extract the centroids of each detected nucleus, and the list of pixels
% contained within its boundary.

stats = regionprops(L,'Centroid','PixelIdxList');

%% Find average intensity in each channel for each nucleus
%
% For each of the detected nuclei, we calculate the average intensity over
% all of the pixels within its boundary. We do this for each of the RGB
% channels separately. We also extract the coordinates of the centroid of
% each nucleus, as a percentage of the length of the anterior-posterior
% axis.

r = squeeze(stdim(:,:,1));
g = squeeze(stdim(:,:,2));
b = squeeze(stdim(:,:,3));
[rows,columns,tmp] = size(stdim);
data(num,5) = 0;
for i=1:num
    data(i,1:2) = stats(i).Centroid./[columns,rows]*100;
    data(i,3) = mean(r(stats(i).PixelIdxList));
    data(i,4) = mean(g(stats(i).PixelIdxList));
    data(i,5) = mean(b(stats(i).PixelIdxList));
end

%% Plot the expression levels of the genes against their A-P position
%
% We plot the intensities of the three genes against their position on the
% anterior-posterior axis.

figure('WindowStyle','docked');

subplot(2,1,1)
imshow(stdim)

subplot(2,1,2);
hold on
scatter(data(:,1),data(:,3),'r.')
scatter(data(:,1),data(:,4),'g.')
scatter(data(:,1),data(:,5),'b.')
legend({'eve','caudal','bicoid'});
xlabel('Anterior-Posterior Position (%)');
ylabel('Intensity')
xlim([0,100]);

%% Focus on the middle strip
%
% The images are a little out of focus towards the upper and lower
% boundaries of the cells, and this is leading to the detected intensities
% being lower in nuclei in those areas. Because we are only interested in
% the gradient of the gene expression along the anterior-posterior axis, we
% can focus on the middle 20% strip.

middlestrip = (data(:,2)>40 & data(:,2)<60);
middledata = data(middlestrip,:);

subplot(2,1,2);
cla
hold on
scatter(middledata(:,1),middledata(:,3),'r.')
scatter(middledata(:,1),middledata(:,4),'g.')
scatter(middledata(:,1),middledata(:,5),'b.')
legend({'eve','caudal','bicoid'});
xlabel('Anterior-Posterior Position (%)');
ylabel('Intensity')
xlim([0,100]);

%% Fit a smoothing spline model to each channel
%
% We use the curve-fitting toolbox to create a smoothed gene expression
% gradient for each channel.

opts = fitoptions('smoothingspline','SmoothingParam',0.01);

fitresultr = fit(middledata(:,1),middledata(:,3),'smoothingspline',opts);
fitresultg = fit(middledata(:,1),middledata(:,4),'smoothingspline',opts);
fitresultb = fit(middledata(:,1),middledata(:,5),'smoothingspline',opts);

rsmooth = feval(fitresultr,0:100);
gsmooth = feval(fitresultg,0:100);
bsmooth = feval(fitresultb,0:100);

subplot(2,1,2);
cla
hold on
plot(0:100,rsmooth,'r')
plot(0:100,gsmooth,'g')
plot(0:100,bsmooth,'b')
legend({'eve','caudal','bicoid'});
xlabel('Anterior-Posterior Position (%)');
ylabel('Intensity')
xlim([0,100]);

%% References
%
% Poustelnikova E, Pisarev A, Blagov M, Samsonova M, Reinitz J (2004). A
% database for management of gene expression data _in situ_.
% _Bioinformatics_ 20:2212-2221. Available from
% http://flyex.ams.sunysb.edu/FlyEx/Flyex_bioinf.pdf
%
% Myasnikova E, Samsonova M, Kosman D, Reinitz J (2005). Removal of
% background signal from _in situ_ data on the expression of segmentation
% genes in _Drosophila_. _Development, Genes and Evolution_ 215(6):320-326.
% 
% Myasnikova E, Samsonova A, Samsonova M, Reinitz J (2002). Support vector
% regression applied to the determination of the developmental age of a
% _Drosophila_ embryo from its segmentation gene expression patterns.
% _Bioinformatics_ 18:S87-S95.
% 
% Myasnikova E, Samsonova A, Kozlov K, Samsonova M, Reinitz J (2001).
% Registration of the expression patterns of _Drosophila_ segmentation
% genes by two independent methods. _Bioinformatics_ 17(1):3-12. 
% 
% Myasnikova E, Kosman D, Reinitz J, Samsonova M (1999). Spatio-temporal
% registration of the expression patterns of _Drosophila_ segmentation
% genes. _Seventh International Conference on Intelligent Systems for
% Molecular Biology_ 195 - 201. Menlo Park, California: AAAI Press.
% 
% Kosman D, Reinitz J, Sharp DH (1999). Automated assay of gene expression
% at cellular resolution. In Altman R, Dunker K, Hunter L, Klein T
% (_eds._), _Proceedings of the 1998 Pacific Symposium on Biocomputing_ 6 -
% 17.
% 
% Kosman D, Small S, Reinitz J (1998). Rapid preparation of a panel of
% polyclonal antibodies to _Drosophila_ segmentation proteins. _Dev Genes
% Evol_ 208:290 -294.



