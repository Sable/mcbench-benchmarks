%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To run:  Edit user options in mtfcalc.m and execute the code.
%
% This code is intended to accompany the paper:
% 
% S. N. Friedman, G. S. K. Fung, J. H. Siewerdsen, and B. M. W. Tsui.  "A
% simple approach to measure computed tomography (CT) modulation transfer 
% function (MTF) and noise-power spectrum (NPS) using the American College 
% of Radiology (ACR) accreditation phantom," Med. Phys. 40, 051907-1 -  
% 051907-9 (2013).
% http://dx.doi.org/10.1118/1.4800795
%
% This code is free to distribute (see below).
%
% This program requires the following 2 files:
%   mtfcalc.m
%   license.txt
%
% Purpose:  To calculate the 1D radial (axial) MTF using CT data of the  
%           American College of Radiology (ACR) accreditation phantom.
%
% Input:    Two consecutive scans of the phantom are needed.  The program 
%           requires a data directory to be selected in which there are 
%           only two subdirectories containing only CT slices corresponding 
%           to the third module of the phantom.  Be careful of partial
%           volume effects with surrounding modules.
%
%           i.e.,  datadir
%                      |-> scan 1 dir
%                      |           | -> only module 3 slices
%                      |        
%                      |-> scan 2 dir
%                                  |-> only module 3 slices
%
% Copyright 2012 Saul N. Friedman
%   Distributed under the terms of the "New BSD License."  Please see
%   license.txt.
%
% N.B.:  This code assumed the data are already organized such that only
%        relevant axial slices are contained within the data directory.
%        ESF = edge spread function
%        LSF = line spread function
%        MTF = modulation transfer function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc;

fprintf('****************************************************************************\n');
fprintf('CT MTF Calculation\n\n')
fprintf('This code is intended to accompany the paper:\n');
fprintf('S. N. Friedman, G. S. K. Fung, J. H. Siewerdsen, and B. M. W. Tsui.  "A\n')  
fprintf('simple approach to measure computed tomography (CT) modulation transfer \n')
fprintf('function (MTF) and noise-power spectrum (NPS) using the American College \n') 
fprintf('of Radiology (ACR) accreditation phantom," Med. Phys. 40, 051907-1 - \n')
fprintf('051907-9 (2013).\n')
fprintf('http://dx.doi.org/10.1118/1.4800795\n\n')
fprintf('This code can be freely distributed.  Please see license.txt for details.\n');
fprintf('****************************************************************************\n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% User selected options
%

selectdir = 1;   % 1 = prompt for directly locations via dialogue box, 0 = hardcode locations below
    datadir = fullfile('data'); 
    resultsdir = fullfile('results',datadir);

saveresults = 1;  % Choose whether to save the calculated MTF to disk in text files

showfig = 3;  % decide how important a figure should be in order to be plotted, 1 = no figures, 4 = all figures

rstep = 0.1; %  Choose bin size in mm (i.e., effective pixel size) for oversampled edge spread function (ESF)

window = 1;  % Decide whether to apply a Hann window to the LSF before calculating the MTF (typically applied)

% Background and foreground values:  1 = prompted to draw rectangle to select ROI, 0 = use values below
manualROI = 1; 
   % box border for background ROI in pixels
   BGxROI1 = 1;
   BGxROI2 = 100;
   BGyROI1 = 1;
   BGyROI2 = 100;
   
   % box border for foreground ROI in pixels
   FGxROI1 = 205;
   FGxROI2 = 305;
   FGyROI1 = 208;
   FGyROI2 = 308;

% 2D map of good pixels (1) and bad pixels (0) to use in calculation
% 1 = prompted to draw rectangle(s) to select ROI(s), 0 = use values below 
manualmask = 1;
selectmask = 1; %prompt for image to use when creating data mask (only applicable if manualmask = 1)
    mask = ones(512,512);
    mask(450:512,1:125) = 0;
    mask(450:512,400:512) = 0;
    mask(400:425,84:105) = 0;
    mask(410:430,400:420) = 0;
    mask(220:230,279:288) = 0;
    mask(371:381,138:147) = 0;

% Determine which angles of data to use in radians (-pi to pi to use all)
thlim1 = -pi;
thlim2 = pi;

%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Start of analysis code
%

homedr = cd;

if selectdir ==1
    fprintf('Select the data directory.\n\n');
    datadir = uigetdir(homedr,'Pick data directory');
    if saveresults == 1
        fprintf('Select the results directory.\n\n');
        resultsdir = uigetdir(homedr,'Pick results directory');
    end
else       
    datadir = fullfile(homedr,datadir);    
    resultsdir = fullfile(homedr,resultsdir);
end

if saveresults == 1
    mkdir(resultsdir)
end

cd(datadir)

scandir = dir;

cd(homedr)

while or(strcmp(scandir(1).name,'.'),strcmp(scandir(1).name,'..'))
    scandir = scandir(2:end);
end

Nscan = size(scandir,1);
Nscan = 1;

nfilescheck = 0;

for i = 1:Nscan
    cd(fullfile(datadir,scandir(i).name))
    
    % get list of filenames
    
    ffiles = dir;
    
    cd(homedr)
    
    while or(strcmp(ffiles(1).name,'.'),strcmp(ffiles(1).name,'..'))
        ffiles = ffiles(2:end);
    end
    
    Nz = size(ffiles,1);
    
     if nfilescheck ~= Nz && nfilescheck ~=0
        fprintf('Error.  Scan directories do not contain the same number of slices.\n')
        return
    end
    
    nfilescheck = Nz;
    
    if i == 1
        
        % Read DICOM header info and determine correct mapping function to get HU
        % values as well as voxel sizes.
        
        im = single(dicomread(fullfile(datadir,scandir(i).name,ffiles(1).name)));
        
        imheader = dicominfo(fullfile(datadir,scandir(i).name,ffiles(1).name));
        
        b = imheader.RescaleIntercept;
        m = imheader.RescaleSlope;
        
        im = im.* m + b;
        
        pixelx = imheader.PixelSpacing(1);
        pixely = imheader.PixelSpacing(2);
        pixelz = imheader.SliceThickness;
        
        if showfig > 2
            figure
            imagesc(im)
            colormap gray
            hold on
            axis image;
            impixelinfo;
        end
        
        Nx = size(im,2);
        Ny = size(im,1);
        
        imaxisx = [1:Nx] .* pixelx;
        imaxisy = [1:Ny] .* pixely;
        
        imavg = zeros(Ny,Nx);
        im3D = zeros(Ny,Nx,Nz);
    end
    
    % Load data into memory and calculate an average 2D image to later
    % determine phantom location
    
    for z = 1:Nz
        im = single(dicomread(fullfile(datadir,scandir(i).name,ffiles(z).name)));
        im = im.* m + b;
        im3D(:,:,z,i) = im;
        imavg = imavg + im;
    end
    
end

imavg = imavg ./(Nz*Nscan);

if selectmask == 1 && manualmask == 1
    fprintf('Select the DICOM image to use for mask creation.\n\n');
    [imfile impath] = uigetfile('*','Pick a DICOM image to use for mask creation',datadir);
    if isequal(imfile,0) || isequal(impath,0)
        im = imavg;
    else
        im = single(dicomread(fullfile(impath,imfile)));
        im = im.* m + b;
    end
else
    im = imavg;
end

% Plot sample slice.  Use to create mask image if set to manual selection.

imaxisx = [1:size(im,2)] .* pixelx;
imaxisy = [1:size(im,1)] .* pixely;

if showfig > 3 || manualmask == 1
    figure
    imagesc(im)
    xlabel('pixel')
    ylabel('pixel')
    colormap gray
    hold on
    axis image;
    impixelinfo;
end

if manualmask ==1
    
    mask = ones(size(im));
    
    selectROI = 1;
    
    fprintf('Select the ROIs corresponding to bad data.\n\n');
    
    while selectROI == 1
        choice = menu('Select additional ROI of bad data?','Yes','No');
        
        if choice == 2
            selectROI = 0;
            hold off
        else
            h = imrect;
            ptmask = wait(h);
            
            maskx1 = round(ptmask(1));
            maskx2 = maskx1 + round(ptmask(3));
            masky1 = round(ptmask(2));
            masky2 = masky1 + round(ptmask(4));
            
            % force selected ROI to be within the bounds of the image
            maskx1 = min(maskx1,size(im,2));
            maskx2 = min(maskx2,size(im,2));
            masky1 = min(masky1,size(im,1));
            masky2 = min(masky2,size(im,1));
            maskx1 = max(maskx1,1);
            maskx2 = max(maskx2,1);
            masky1 = max(masky1,1);
            masky2 = max(masky2,1);
            
            mask(masky1:masky2,maskx1:maskx2) = 0;
            
            plot([maskx1,maskx2,maskx2,maskx1,maskx1],[masky1,masky1,masky2,masky2,masky1],'r-')
        end
    end
end

% Plot mask image overlying sample image to verify mask

if showfig > 3
    figure
    imagesc([imaxisy(1) imaxisy(end)],[imaxisx(1) imaxisx(end)],(im+100).*mask)
    xlabel('mm')
    ylabel('mm')
    colormap gray
    hold on
    axis image;
    impixelinfo;
end

% Show averaged image if desired or needed

if showfig > 2 || manualROI == 1
    figure
    imagesc(imavg)
    xlabel('pixel')
    ylabel('pixel')
    colormap gray
    hold on
    axis image;
    impixelinfo;
end

% Determine background and foreground values to properly normalized the
% data to range [0,1]

if manualROI == 1
    fprintf('Click and drag to create a rectangular ROI representing the background.  Double click the ROI when finished.\n\n');
    
    h = imrect;
    ptROI = wait(h);
    
    
    BGxROI1 = round(ptROI(1));
    BGxROI2 = BGxROI1 + round(ptROI(3));
    BGyROI1 = round(ptROI(2));
    BGyROI2 = BGyROI1 + round(ptROI(4));
    
    % force selected ROI to be within the bounds of the image
    BGxROI1 = min(BGxROI1,size(im,2));
    BGxROI2 = min(BGxROI2,size(im,2));
    BGyROI1 = min(BGyROI1,size(im,1));
    BGyROI2 = min(BGyROI2,size(im,1));
    BGxROI1 = max(BGxROI1,1);
    BGxROI2 = max(BGxROI2,1);
    BGyROI1 = max(BGyROI1,1);
    BGyROI2 = max(BGyROI2,1);
end

BGvalue = mean(mean(imavg(BGyROI1:BGyROI2,BGxROI1:BGxROI2)));

if manualROI == 1
    fprintf('Click and drag to create a rectangular ROI representing the foreground.  Double click the ROI when finished.\n\n');
    
    h = imrect;
    ptROI = wait(h);
    
    FGxROI1 = round(ptROI(1));
    FGxROI2 = FGxROI1 + round(ptROI(3));
    FGyROI1 = round(ptROI(2));
    FGyROI2 = FGyROI1 + round(ptROI(4));
    
    % force selected ROI to be within the bounds of the image
    FGxROI1 = min(FGxROI1,size(im,2));
    FGxROI2 = min(FGxROI2,size(im,2));
    FGyROI1 = min(FGyROI1,size(im,1));
    FGyROI2 = min(FGyROI2,size(im,1));
    FGxROI1 = max(FGxROI1,1);
    FGxROI2 = max(FGxROI2,1);
    FGyROI1 = max(FGyROI1,1);
    FGyROI2 = max(FGyROI2,1);
end

FGvalue = mean(mean(imavg(FGyROI1:FGyROI2,FGxROI1:FGxROI2)));

if or(showfig > 2,manualROI ==1)
    plot([BGxROI1,BGxROI2,BGxROI2,BGxROI1,BGxROI1],[BGyROI1,BGyROI1,BGyROI2,BGyROI2,BGyROI1],'r-')
    plot([FGxROI1,FGxROI2,FGxROI2,FGxROI1,FGxROI1],[FGyROI1,FGyROI1,FGyROI2,FGyROI2,FGyROI1],'r-')
    hold off
end

% Normalize averaged image such that values are [0,1]

imavg = (imavg - BGvalue) ./ (FGvalue - BGvalue);

if showfig > 2
    figure
    imagesc([imaxisy(1) imaxisy(end)],[imaxisx(1) imaxisx(end)],imavg)
    xlabel('mm')
    ylabel('mm')
    title('averaged and normalized image')
    colormap gray
    hold on
    axis image;
    impixelinfo;
end

% Determine which pixels correspond to the phantom cylinder

imlog = zeros(size(imavg));

level = graythresh(imavg);
imlog = im2bw(imavg,level);

% Calculate the center of the cylinder

fprintf('Calculating the center of the phantom and determining phantom-pixel locations.\n\n');

if exist('bwconncomp')==2
    CC = bwconncomp(imlog,26);
    for i = 1:CC.NumObjects;
        Lobj(i) =  length(CC.PixelIdxList{1,i}) ;
    end
else
    [CC CCn] = bwlabel(imlog,8);
    for i = 1:CCn
        Lobj(i) = length(find(CC == i));
    end   
end

L = find(Lobj == max(Lobj));

S = regionprops(CC,'Centroid');

c.y = S(L).Centroid(2);
c.x = S(L).Centroid(1);

if showfig>2
    figure
    imagesc([imaxisy(1) imaxisy(end)],[imaxisx(1) imaxisx(end)],imlog)
    xlabel('mm')
    ylabel('mm')
    title('Cylinder with center marked')
    colormap gray
    hold on
    axis image;
    impixelinfo;
    if exist('bwconncomp')==2
        [I J] = ind2sub(size(imavg),CC.PixelIdxList{1,L});
    else
        [I,J] = find(CC == L);
    end
    plot(J*pixely,I.*pixelx,'.r')
    plot(c.x*pixelx,c.y*pixely,'*y')
    hold off
end

xaxis = ([1:size(imavg,2)] - c.x) .* pixelx;
yaxis = ([1:size(imavg,1)] - c.y) .* pixely;

% Convert all image coords to polar coords with origin at center of the
% cylinder

r = zeros(size(imavg));
th = zeros(size(imavg));

for i = 1 :size(imavg,2)
    for j = 1 : size(imavg,1)
        %         r(j,i) = sqrt(xaxis(i).^2 + yaxis(j).^2);
        %         th(j,i) = atan2(yaxis(j),xaxis(i));
        [th(j,i) r(j,i)] = cart2pol(xaxis(i),yaxis(j));
    end
end

% Create oversampled ESF excluding data specified in mask

rmax = max(max(r));

esf = zeros(ceil(rmax/rstep)+1,1);
nsamp = zeros(length(esf),1);

rbin = 0:rstep:rmax+rstep;

if showfig > 3
    figure
    imagesc((imavg+1).*mask)
    colormap gray
    hold all
    axis image;
    impixelinfo;
end

% data with radius falling within a given bin are averaged together for a
% low noise approximation of the ESF at the given radius

fprintf('Calculating the MTF.\n');
fprintf('The may take several minutes. \n');
fprintf('Please be patient.\n\n');

thlim1 = min(thlim1,thlim2);
thlim2 = max(thlim1,thlim2);

for i = 1:length(rbin)
    R1 = find(r >= rbin(i));
    R2 = find(r < rbin(i) + rstep);
    R3 = intersect(R1,R2);
    R4 = find(th >= thlim1);
    R5 = find(th < thlim2);
    R6 = intersect(R5,R4);
    R7 = intersect(R3,R6);
    R8 = R7.*mask(R7);
    R=R8(R8~=0);
    if showfig > 3
        [X Y] = ind2sub(size(imavg),R);
        plot(Y,X,'.')
        hold all
    end
    esf(i) = sum(imavg(R));
    nsamp(i) = length(R);
end

i1 = find(nsamp,1,'first');
i2 = find(nsamp,1,'last');
nsamp = nsamp(i1:i2);
esf = esf(i1:i2);
rbin = rbin(i1:i2);

I = find(nsamp > 0);
esf(I) = esf(I)./nsamp(I);


% Plot oversampled ESF
if showfig > 2
    figure
    plot(rbin,esf)
    xlabel('radius (mm)')
    ylabel('normalized + oversampled ESF')
    grid on
    axis([rbin(1) rbin(end) -1.2*min(esf) 1.1*max(esf)])
end

% Calculated the LSF from the ESF
lsf = diff(esf);

% artifacts caused by empty bins likely have a value of -/+ 1, so try to 
% remove them.
I = find(abs(lsf)> 0.9);
lsf(I) = 0;

if max(lsf) < max(abs(lsf))
    lsf = -lsf;
end

maxlsf = max(lsf);

rcent = find(lsf == maxlsf);
lsfaxis = rbin(1:end-1) - rbin(rcent);

% Center edge location in LSF and keep surrounding data range specified by
% pad.  N.B. data from regions greater than the FOV is removed in
% this manner.
pad = round(length(lsfaxis)/5);
lsfaxis = lsfaxis(rcent-pad:rcent+pad);
lsf = lsf(rcent-pad:rcent+pad);

nlsf = length(lsf);

%calculate Hann window and apply to data if specified.
if window == 1
    w = 0.5 .* (1 - cos(2*pi*[1:length(lsfaxis)]./length(lsfaxis)));
    w = w';
else
    w = ones(length(lsfaxis),1);
end
lsfw = lsf .* w;

% Plot windowed LSF and scaled window together
if showfig > 1
    figure
    plot(lsfaxis,lsfw)
    hold on
    plot(lsfaxis,w.*max(lsfw),'r--')
    hold off
    legend('oversampled + normalized LSF','scaled Hann window')
    xlabel('radius (mm)')
    ylabel('signal')
    axis([lsfaxis(1) lsfaxis(end) 1.1*min(lsfw) 1.1*max(lsfw)])
    grid on
end

% Calculate the MTF from the LSF

T = fftshift(fft(lsfw));
faxis = ([1:nlsf]./nlsf - 0.5) ./ rstep;

MTF = abs(T);

%Plot the MTF
if showfig > 1
    figure
    plot(faxis,MTF,'.-')   
    xlabel('spatial frequency (mm^{-1})');
    ylabel('MTF_r')
    axis([0 max(faxis) 0 1.1*max(MTF)])
    grid on
end

fprintf('MTF calculated.\n\n');

% Save MTF results if indicated
if saveresults == 1
    save(fullfile(resultsdir,'axisvalues.txt'),'faxis','-ASCII')
    save(fullfile(resultsdir,'MTFvalues.txt'),'MTF','-ASCII')
    fprintf('Results saved.\n\n');
end

return;
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%