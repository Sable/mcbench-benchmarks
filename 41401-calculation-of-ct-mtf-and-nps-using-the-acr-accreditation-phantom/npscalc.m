%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To run:  Edit user options in npscalc.m and execute the code.
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
% This program requires the following 4 files:
%   npscalc.m
%   SliceBrowser.m
%   SliceBrowser.fig
%   license.txt
%
% Purpose:  To calculate the 3D NPS using CT data of the American College
%           of Radiology (ACR) accreditation phantom.
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
% CCopyright 2012 Saul N. Friedman
%   Distributed under the terms of the "New BSD License."  Please see
%   license.txt.
%
% N.B.:  SliceBrowser.m is an altered version of code by Marian Uhercik.
%        Please see license.txt.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc;

fprintf('****************************************************************************\n');
fprintf('CT NPS Calculation\n\n')
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

selectdir = 1;  % 1 = prompted for directly locations via dialogue box, 0 = hardcode locations below
    datadir = fullfile('data');
    resultsdir = fullfile('results',datadir);

saveresults = 1;  % Choose whether to save the calculated 3D NPS to disk as a series of DICOM files.

calczero = 1;  % when set to 0, the NPS(0,0,0) value is estimated based on the surrounding 26 voxel values to try remove any zero-frequency artifacts

rstep = 0.025;  % This will be the effective bin size after forming the radially averaged NPS.

showfig = 3;  % decide how important a figure should be in order to be plotted, 1 = no figures, 4 = all figures

% specify size of ROI (pixels/slices)
deltax = 128;
deltay = deltax;

calcdeltaz = 0; % 1 = calculate size of ROI in z (slices) to be same physical size as x dimension, 0 = use value below
    deltaz = 128;% % specify number of slices to use in ROI

% specify overlap fraction for ROIs in z direction
%  N.B. value is typically [0,0.5] and represents overlap with EACH
%  neighboring ROI (i.e., at 0.5 all pixels overlap with at least one
%  neighbor)

overlapz = 0.5;  

% Parameters pertaining to placement of ROI in the axial plane.
%  N.B. overlap of ROIs will depend on a combination of the radius chosen
%  in rcenter and the distance between the centers of ROIs chosen.

rcenter = 25; % radius in mm along which to center ROIS, a value of 25 mm corresponds to half the radius of the phantom
deltar = 20;  % distance along the radial arc in pixels between centers of ROIs in the axial plane
deltaangle = 2*pi/180;  % the range of angles in radians over which to look for a suitable pixel on which to center an ROI

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

% get list of scan directories

scandir = dir;

cd(homedr)

while or(strcmp(scandir(1).name,'.'),strcmp(scandir(1).name,'..'))
    scandir = scandir(2:end);
end

Nscan = size(scandir,1);

if Nscan < 2
    fprintf('At least 2 scans are needed to perform analysis.\n')
    return
end

if Nscan > 2 == 1
    Nscan = 2;
    fprintf('Only using the first 2 directories of data.\n')
end

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

imavg = imavg ./ Nz;

if deltaz  > Nz
    deltaz = Nz;
    val = sprintf('Selected ROI size in z is larger than the number of slices.  Using value of %d instead.\n\n',Nz);
    fprintf(val)
end


% Detrend the data and plot if desired

fprintf('Detrending data.\n\n');

im3Dzm(:,:,:) = im3D(:,:,:,1) - im3D(:,:,:,2);


if showfig > 2 && size(im3Dzm,3) > 1
    yaxis = [1:size(im3Dzm,1)] .* pixely;
    xaxis = [1:size(im3Dzm)].* pixelx;
    zaxis = [1:size(im3Dzm,3)] .* pixelz;
    axlabel = ' (mm)';
    
    setappdata(0,'vaxis',yaxis)
    setappdata(0,'uaxis',xaxis)
    setappdata(0,'waxis',zaxis)
    setappdata(0,'axlabel',axlabel)
    
    SliceBrowser(im3Dzm(:,:,:))
end


% Determine which pixels correspond to phantom cylinder

imlog = zeros(size(imavg));

level = graythresh(abs(imavg));
imlog = im2bw(abs(imavg),level);

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

if showfig>3
    figure
    imagesc([imaxisx(1) imaxisx(end)], [imaxisy(1) imaxisy(end) ], imlog)
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

% calculate polar coordinates for to place ROIs at a specified radial
% direction

for i = 1 :size(imavg,2)
    for j = 1 : size(imavg,1)
        [th(j,i) r(j,i)] = cart2pol(xaxis(i),yaxis(j));
    end
end

rcalc = round(rcenter/pixelx);  
anglestep = deltar * pixelx / rcalc;

% Calculate ROI size in z direction such that it is the same physical
% dimension as the x ROI, if desired.

if calcdeltaz == 1
    deltaz = round(deltax * pixelx ./ pixelz);
end

% Determine the number of ROIs in each direction.

Ndeltaxy = floor(2*pi/anglestep);
Ndeltaz = floor(Nz ./ (deltaz .* (1- overlapz)) - 1 / (1 - overlapz) + 1);

% Determine the offset needed to center the ROIs in z direction.
offsetz = round((Nz - deltaz - round((deltaz - overlapz * deltaz)*(Ndeltaz - 1)))/2);

if showfig > 2
    figure
    imagesc(im)
    colormap gray
    hold on
end

ROIavg = zeros(deltay,deltax,deltaz);

nROI = 0;

for i = 1:Ndeltaxy;
    
    R1 = find( abs(r - rcalc) < pixelx);
    R2 = find( th < -pi + i*anglestep + deltaangle);
    R3 = find( th > -pi + i*anglestep - deltaangle);
    R4 = intersect(R1,R2);
    R5 = intersect(R3,R4);
    R = min(R5);
    
    [I J] = ind2sub(size(im),R);
    
    y1 = J-round(deltay/2)+1;
    y2 = J+round(deltay/2);
    x1 = I-round(deltax/2)+1;
    x2 = I+round(deltax/2);
    
    for z = 1:Ndeltaz
        nROI=nROI+1;
        ROIzm(:,:,:,nROI) =  im3Dzm(y1:y2,x1:x2,(offsetz + 1 + (deltaz * (z-1))):(offsetz + deltaz + deltaz * (z-1))) ;
    end
    
    if showfig > 2
        plot(I,J,'r.')
        plot([x1,x2,x2,x1,x1],[y1,y1,y2,y2,y1],'r-')
    end
end

% Calculated power spectrum realizations from each ROI.  The ensemble
% average of these is the calculated estimate of the NPS.

fprintf('Calculating the NPS.\n');
fprintf('The may take several minutes. \n');
fprintf('Please be patient.\n\n');

Wavg = zeros(size(ROIzm,1),size(ROIzm,2),size(ROIzm,3));

for i = 1:nROI
    
    W = abs( fftn((ROIzm(:,:,:,i))) ) .^2;
    W = fftshift(W);
    
    Wavg = W + Wavg;
end


Wavg = Wavg ./( Ndeltaxy * Ndeltaz .* deltax .* deltay .* deltaz .* 2 ) .* pixelx .* pixely .* pixelz;

% Calculate the axes values in the frequency domain.

yaxis = ( [0:size(ROIzm,1)-1]/size(ROIzm,1) - 0.5 ) ./ pixely;
xaxis = ( [0:size(ROIzm,2)-1]/size(ROIzm,2) - 0.5 ) ./ pixelx;
zaxis = ( [0:size(ROIzm,3)-1]/size(ROIzm,3) - 0.5 ) ./ pixelz;
axlabel = ' (mm^{-1})';

setappdata(0,'vaxis',yaxis)
setappdata(0,'uaxis',xaxis)
setappdata(0,'waxis',zaxis)
setappdata(0,'axlabel',axlabel)

% The calculated zero-frequency value often contains an artifact.  The value
% can be approximated based on an average of the surrounding values.

if calczero == 0;
    J = find(abs(yaxis)==min(abs(yaxis)));
    I = find(abs(xaxis)==min(abs(xaxis)));
    if size(Wavg,3) > 1
        K = find(abs(zaxis)==min(abs(zaxis)));
        Wavg(J,I,K) = (Wavg(J,I,K+1) + Wavg(J,I,K-1) + Wavg(J,I+1,K) + Wavg(J,I+1,K+1) + Wavg(J,I+1,K-1) + Wavg(J,I-1,K) + Wavg(J,I-1,K+1) + Wavg(J,I-1,K-1) + Wavg(J+1,I,K)  + Wavg(J+1,I,K+1) + Wavg(J+1,I,K-1) + Wavg(J+1,I+1,K) + Wavg(J+1,I+1,K+1) + Wavg(J+1,I+1,K-1) + Wavg(J+1,I-1,K)+ Wavg(J+1,I-1,K+1)+ Wavg(J+1,I-1,K-1)+ Wavg(J-1,I,K) + Wavg(J-1,I,K+1)+ Wavg(J-1,I,K-1)+ Wavg(J-1,I+1,K) + Wavg(J-1,I+1,K+1) + Wavg(J-1,I+1,K-1) + Wavg(J-1,I-1,K) + Wavg(J-1,I-1,K+1) + Wavg(J-1,I-1,K-1)) / 26;
    else
        Wavg(J,I) = (Wavg(J,I+1) + Wavg(J,I-1) + Wavg(J+1,I) + Wavg(J+1,I+1) + Wavg(J+1,I-1) + Wavg(J-1,I) + Wavg(J-1,I+1) + Wavg(J-1,I-1)) ./ 8;
    end
end

% Plot a 1D slightly off-centered NPS profile in each direction.

eps = 0;

if showfig > 2
    figure
    subplot(3,1,1)
    plot(xaxis,Wavg(:,round(deltay/2)+eps,round(deltaz/2)+eps));
    xlabel('x-dir (mm^{-1})')
    ylabel('NPS_x (HU^2 mm^3)')
    subplot(3,1,2)
    plot(yaxis,Wavg(round(deltax/2)+eps,:,round(deltaz/2)+eps));
    xlabel('y-dir (mm^{-1})')
    ylabel('NPS_y (HU^2 mm^3)')
    subplot(3,1,3)
    zvalue = squeeze(Wavg(round(deltay/2)+eps,round(deltax/2)+eps,:));
    plot(zaxis,zvalue,'.-');
    xlabel('z-dir (mm^{-1})')
    ylabel('NPS_z (HU^2 mm^3)')
end

% Plot the 3D NPS.

if showfig > 1 && size(Wavg,3) > 3
    SliceBrowser(Wavg)
end

% Calculate radially averaged NPS profile for xy plane

% Switch to polar coords
imslice = Wavg(:,:,round(deltaz/2)+eps);
r = zeros(size(imslice));
th = zeros(size(imslice));

for i = 1 :size(imslice,2)
    for j = 1 : size(imslice,1)
        %         r(j,i) = sqrt(xaxis(i).^2 + yaxis(j).^2);
        %         th(j,i) = atan2(yaxis(j),xaxis(i));
        [th(j,i) r(j,i)] = cart2pol(xaxis(i),yaxis(j));
    end
end

% Create oversampled radial NPS profile

rmax = max(max(r));

npsr = zeros(ceil(rmax/rstep)+1,1);
nsamp = zeros(length(npsr),1);

rbin = 0:rstep:rmax+rstep;

if showfig > 3
    figure
    imagesc([xaxis(1) xaxis(end)], [yaxis(1) yaxis(end)], imslice)
    colormap gray
    hold on
    plot(0,0,'r*')
    hold off
    axis image;
    impixelinfo;
    
    figure
    imagesc(imslice)
    colormap gray
    hold on
    axis image;
    impixelinfo;
end

% data with radius falling within a given bin are averaged together for a
% low noise approximation of the ESF at the given radius

for i = 1:length(rbin)
    R1 = find(r >= rbin(i));
    R2 = find(r < rbin(i) + rstep);
    R = intersect(R1,R2);
    if showfig > 3
        [X Y] = ind2sub(size(imslice),R);
        plot(Y,X,'.')
        hold all
    end
    npsr(i) = sum(imslice(R));
    nsamp(i) = length(R);
end

i1 = find(nsamp,1,'first');
i2 = find(nsamp,1,'last');
nsamp = nsamp(i1:i2);
npsr = npsr(i1:i2);
rbin = rbin(i1:i2);

I = find(nsamp > 0);
npsr(I) = npsr(I)./nsamp(I);


% Plot radially averaged NPS
if showfig > 2
    figure
    plot(rbin,npsr,'.-')
    xlabel('spatial frequency (mm^{-1})')
    ylabel('NPS_r (HU^2 mm^3)')
    grid on
    axis([rbin(1) rbin(end) -1.2*min(npsr) 1.1*max(npsr)])
end

fprintf('NPS calculated.\n\n');

% Save 3D NPS data as DICOM slices and the 1D profile along w = 0 as text 
% files if indicated.

if saveresults == 1
    
    NPSheader = imheader;
    
    NPSheader.RescaleIntercept = 0;
    NPSheader.RescaleSlope = 1;
    NPSheader.PixelSpacing(1) = xaxis(2) - xaxis(1);
    NPSheader.PixelSpacing(2) = yaxis(2) - yaxis(1);
    NPSheader.SliceThickness = zaxis(2) - zaxis(1);
    
    mkdir(fullfile(resultsdir,'3D'));
    
    for k = 1:size(Wavg,3)
        filename = sprintf('NPS%04d.dcm',k);
        dicomwrite(uint16(Wavg(:,:,k)),fullfile(resultsdir,'3D',filename),NPSheader)
    end
    mkdir(fullfile(resultsdir,'1D'));
    
    save(fullfile(resultsdir,'1D','axisvalues.txt'),'rbin','-ASCII')
    save(fullfile(resultsdir,'1D','NPSrvalues.txt'),'npsr','-ASCII')
    
    fprintf('Results saved.\n\n');
    
end

return;
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%