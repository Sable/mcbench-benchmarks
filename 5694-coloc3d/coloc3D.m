% ML script for 3D Particles colocalization.
% The images are thresholded, label matrices are
% generated, and then the computations are performed.
% Images must be TIFFs of equal dimensions, although
% the TIFF constraint may be changed by editing the
% <getstacks> function.
%
% See also GRAYTHRESH, IM2BW, BWAREAOPEN, BWLABELN, REGIONPROPS
% W. Bryan Smith, August 12, 2004
% bryan@ugcs.caltech.edu


% the <getstacks> function uses <uigetfile> for loading images
[img1,img2,r,c,z] = getstacks;

% Generate thresholds.  By default, the threshold
% is automatically computed using <graythresh>.
% You can choose instead to enter threshold values
% manually by commenting out lines 21-22, and 
% uncommenting lines 23-24.
level1 = graythresh(img1);
level2 = graythresh(img1);
% level1 = input ('Set first image threshold ');
% level2 = input ('Set second image threshold ');

% Threshold images and make the label matrices.
% <bwareaopen> removes particles less than some size.
% The size is arbitrary (4 here), and will depend on  
% image resolution and noise.
img1th = zeros(size(img1));
img2th = zeros(size(img2));

img1th = img1>level1*255;
img2th = img2>level2*255;

img1th = bwareaopen(img1th,4,26);
img1thlabel = bwlabeln(img1th,26);
img2th = bwareaopen(img2th,4,26);
img2thlabel = bwlabeln (img2th,26);

% Find Overlap between images using 26-connected neighborhoods
OL = (img1th&img2th);
% OL = bwareaopen(OL,2);
OLlabel = bwlabeln(OL,26);

% Find particle volumes in each image.
% The props* structures contain the individual particle data,
% which in this case is the volume and the pixel indices.
% 'help regionprops' for more options.
props1 = regionprops (img1thlabel,'Area','PixelList');  % for image1
vols1 = [props1.Area];
props2 = regionprops (img2thlabel,'Area','PixelList');  % for image2
vols2 = [props2.Area];
propsOL = regionprops (OLlabel,'Area','PixelList');     % for the overlap image
volsOL = [propsOL.Area];

% Find sum, mean, max, and min pixel intensity values of all particles.
% img1 = im2uint8(img1);
pixlist1 = {props1.PixelList};
for i = 1:length(vols1)
    for j = 1:length(pixlist1{i}(:,1))
        [mpval(j)] = img1(pixlist1{i}(j,2),pixlist1{i}(j,1),pixlist1{i}(j,3));
    end
    [sumpixvals1(i)] = sum(mpval); 
    [meanpixvals1(i)] = mean(mpval); 
    [maxpixvals1(i)] = max(mpval); 
    [minpixvals1(i)] = min(mpval);
    clear mpval;
end
clear i j mpval;

% img2 = im2uint8(img2);
pixlist2 = {props2.PixelList};
for i = 1:length(vols2)
    for j = 1:length(pixlist2{i}(:,1))
        [mpval(j)] = img2(pixlist2{i}(j,2),pixlist2{i}(j,1),pixlist2{i}(j,3));
    end
    [sumpixvals2(i)] = sum(mpval);
    [meanpixvals2(i)] = mean(mpval); 
    [maxpixvals2(i)] = max(mpval); 
    [minpixvals2(i)] = min(mpval);
    clear mpval;
end

p1pixmean = mean(meanpixvals1);
p1pixtot = mean(sumpixvals1);
p2pixmean = mean(meanpixvals2);
p2pixtot = mean(sumpixvals2);

% Compute total volume of particles in each image (and the overlaps)
vp1tot = length(find(img1th));          % for image1
vp2tot = length(find(img2th));          % for image2
vOLtot = length(find(OL));              % for overlap image

% Compute number and mean volume of particles in each image 
nump1 = length(vols1);                  % Number of particles in img1
meanp1 = mean(vols1);                   % Mean volume of particles in img1
nump2 = length(vols2);                  % Number of particles in img2
meanp2 = mean(vols2);                   % Mean volume of particles in img2
numOL = length(volsOL);                 % Number of particles in overlap image
meanOLs = mean(volsOL);                 % Mean volume of particles in overlap image

% Compute fraction of overlaping volumes (for the whole image)
volsOLp1 = sum(volsOL)/sum(vols1);      % Overlaps as fraction of total img1 particle volumes
volsOLp2 = sum(volsOL)/sum(vols2);      % Overlaps as fraction of total img2 particle volumes

% Compute fraction of particles (number) that overlap (for the whole image)
numOLp1 = numOL/nump1;                  % Number of overlap particles/number of particles in img1
numOLp2 = numOL/nump2;                  % Number of overlap particles/number of particles in img2

% Compute fraction of EACH particle that contributes to overlap
olp = zeros (length(volsOL),3);
volsp1sub = zeros(size(volsOL));
volsp2sub = zeros(size(volsOL));

% The full particle volume for each particle iff it has some overlap.
for i = 1:length(volsOL)
    olp(i,:) = [propsOL(i).PixelList(1,:)];
    volsp1sub(i) = vols1(img1thlabel((olp(i,2)),(olp(i,1)),(olp(i,3))));
    volsp1subidx(i) = img1thlabel((olp(i,2)),(olp(i,1)),(olp(i,3)));
    volsp2sub(i) = vols2(img2thlabel((olp(i,2)),(olp(i,1)),(olp(i,3))));
    volsp2subidx(i) = img2thlabel((olp(i,2)),(olp(i,1)),(olp(i,3)));
end
clear i

% The fraction of each particle that
% contributes to the overlapping region.
p1fract = volsOL./volsp1sub;
p2fract = volsOL./volsp2sub;

% The matrices of ONLY particles that overlap.
for i = 1:z
    [img1thlabelsub(:,:,i)] = ismember(img1thlabel(:,:,i), volsp1subidx);
    [img2thlabelsub(:,:,i)] = ismember(img2thlabel(:,:,i), volsp2subidx);
end


%% For saving the data as tab-delimited ASCII
varids = {'TH1','TH2','MeanV1','TotalV1','MeanPix1','TotalPix1','NumP1','MeanP1frac'...
        'MeanV2','TotalV2','MeanPix2','TotalPix2','NumP2','MeanP2frac'...
        'MeanVOL','TotalVOL','NumPOL','TotalPixOL1', 'MeanPixOL1','NumOLdivTot1','VOLdivTotV1',...
        'TotalPixOL2','MeanPixOL2','NumOLdivTot2','VOLdivTotV2'};
% Make data row vector
[data(1,:)] = [level1, level2,...
        meanp1, vp1tot, p1pixmean, p1pixtot, nump1, mean(p1fract),...
        meanp2, vp2tot, p2pixmean, p2pixtot, nump2, mean(p2fract),...
        meanOLs, vOLtot, numOL,...
        p1pixtot, p1pixmean, numOLp1, volsOLp1,...
        p2pixtot, p2pixmean, numOLp2, volsOLp2];
if isempty(dir('rowdat.txt')) == 1;
    fid = fopen('rowdat.txt','at+');
    fprintf(fid,'%s\t',varids{:});
    fprintf(fid,'\r');
    fprintf (fid,'%g\t',data);
    fclose(fid);
else isempty(dir('rowdat.txt')) == 0;
    fid = fopen('rowdat.txt','at+');
    fseek(fid,0,'eof');
    fprintf(fid,'\r');
    fprintf (fid,'%g\t',data);
    fclose (fid);
end

%% this plots the isosurfaces of the label matrices
%% with image1 (patch object p1) in green, solid, 
%% and image2 (patch object p2) in red, transparent.
%% You may plot only the overlapping particles for
%% either image by replacing <img*thlabel> with <img*thlabelsub>
%% Also, because of the difference in screen size, the <Position>
%% argument may need to be modified

% set(0,'Units','Normalized');
% p1 = patch(isosurface(img1thlabel,0)); 
% set(p1,'FaceColor','green','EdgeColor','none','FaceAlpha',1), lighting gouraud;
% hold on, p2 = patch(isosurface(img2thlabel,0)); 
% set(p2,'FaceColor','red','EdgeColor','none','Facealpha',0.3), 
% light; light; light('Position', [-1 -1 -3]); lighting gouraud;, 
% view(3), axis([0 c 0 r 0 z]), daspect([1,1,0.45]); grid off, box off;
% set (gcf, 'Color','Black','Units','Normalized','Position',[.1 .05 .8 .85]), axis vis3d;
% set (gca,'color','k','Xcolor','w','Ycolor','w','Zcolor','w','linewidth',1,'Ztick',[],'Yticklabel',[],'Xticklabel',[]);