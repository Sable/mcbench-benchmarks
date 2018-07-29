function [mask,V_mean,V_std,Vfad] = NeckBackground(V,flagdisplay,gain);
% NeckBackground:       background from neck image by region growing from
%   [mask,V_mean,V_std,Vfad] = NeckBackground(V,flagdisplay,gain);
%   gain: multiplicative gain of STD for threshold (default=3)
% 
% OS CWRU, 05-jun-03

if ~exist('flagdisplay'),
    flagdisplay=0;
end
if ~exist('gain'),
    gain = 3;
end



if flagdisplay,
%     colormap(gray)
%     subplot(121)
%     imagesc(V),axis image, axis off
%     subplot(122)
    disp('--- Starting region growing from corner')
end

% clear all
SE3 = strel('disk',3,0);
SE1 = strel('disk',1,0);

threshold = 0.001;


[nr,nc,nf] = size(V);

% --- filter image using anisotropic diffusion
Vfad = anisoOS(V,'tukeyPsi',0.5*mean2(V),30);    

% --- get a seed area
Vgrow = im2bw(0*V);
Vgrow(1,1) = 1;
Vgrow(1,end) = 1;
new_voxel = 1000;

% --- main loop until no more voxel added
goahead = 1;
flipflop = 1;
idx = 1;
% if flagdisplay,
%     disp('  Start the region growing')
% end
Vinit = 1e6*ones(size(V));
while goahead,
    idx = idx+1;
    
    % --- compute the statistics of the area
    %     V_mean = sum(sum(Vfad.*Vgrow)) / sum(sum(Vgrow));
    %     V_std = sqrt(sum(sum((Vfad-V_mean).^2.*Vgrow)))/...
    %         (sum(sum(Vgrow))-1);
    V_mean = mean(Vfad(Vgrow));
    V_std = std(Vfad(Vgrow));
    
    threshold = V_mean + gain* V_std;
    %     threshold = 2* V_mean;
    
    % --- ... and from within a slice
    if new_voxel>30,
        SE = SE3;
    else
        SE = SE1;
    end
    Vnewslice = imdilate(Vgrow,SE);
    
    % --- The new label voxel to be tested
    Vnew = im2bw(Vnewslice.*(1-Vgrow) );
    
    % --- criteria for each new voxel
    Vcrit = Vinit;
    Vtemp = (Vnew.*Vfad - V_mean).^2;
    Vcrit(Vnew) = Vtemp(Vnew);
    
    % --- get the new good voxels
    Vgood = 0*V;
    Vgood = Vcrit < threshold;
    
    % --- grow the region
    Vgrow = or(Vgrow , Vgood);
    
    % --- total number of voxel in the regions
    NbVox = sum(sum(Vgrow));
    
    % --- if enough voxel, includes all the image
%     if NbVox>100 & flipflop,
%         flipflop = 0;
%         Vgrow  = (Vfad - V_mean).^2 < threshold;
%     end
    
    % --- fill the holes
    Vgrow = bwmorph(Vgrow,'fill');  % remove holes
    
    
    % --- continue of the region has grown
    new_voxel = sum(sum(Vgood));
    goahead = new_voxel > 0;
    
    if flagdisplay>1,
        disp([' Mean:' num2str(V_mean) '  Number of new vox:' num2str(new_voxel)...
                '  STD:' num2str(V_std) '  Threshold:' num2str(threshold) ])
        imagesc(Vgrow),axis image, axis off
        drawnow
    end
    
end
% --- close the small holes
mask = imclose(Vgrow,strel('disk',4,0));
V_mean = mean(V(mask));
V_std = std(V(mask));




