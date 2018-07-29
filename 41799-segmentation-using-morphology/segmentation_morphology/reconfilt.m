function [I_segmented, recon]=reconfilt(I, thresh_val, min_rad, max_rad) 

% A function to segment circular locally darker regions in a grayscale image. 
% The size of the kernels used guides the range of sizes that are most
% enhanced. The sensitivity of the segmentation method is guided by the
% threshold. 

% Required Inputs:
%       I          : Grayscale image
%       thresh_val : Threshold sensitivity, between 0 and 1, where 0 is
%                    most sensitive
%       min_rad    : Radius of minimum object to enhance (pixels)
%       min_rad    : Radius of maximum object to enhance (pixels)

%Example:
% [I_segmented, recon]=reconfilt(I, 0.2, 22, 15);
% where I_segmented is the output segmented image, I is the input
% grayscale. 

% Benjamin I 2013/05/17

if min_rad >max_rad
    error('min_rad must be smaller than max_rad')
end

I=double(I);

I_segmented=false(size(I));  % matrix used for the final reconstructed image


for x=min_rad:2:max_rad 
    % processing using every second kernel

    % generating circular kernel (could also use matlab built in: strel)
	B4b=circkern(x);
	    
	% Greyscale closing of the image and Image reconstruction
	JJ=imclose(I,B4b); 
	%reconstructed image %using a 4 connected kernal in the dilation
	KK=imreconstruct(JJ.*-1,I.*-1,4).*-1; 
	LL=KK-I; % difference image

	min_im=min(min(LL)); %minimum value in the image
	max_im=max(max(LL)); %maximum value in the image

	% 20% of the difference between the minimum and maximum value
	Thresh_recon=thresh_val*(max_im-min_im)+min_im; 
	LL_thresh=LL>=Thresh_recon; %Thresholded image

	% adding in the thresholds
	I_segmented=I_segmented | LL_thresh; 
end


%Storing last kernel processing for plotting
recon.original=I; recon.close=JJ; recon.reconstruct=KK; recon.difference=LL;

end

%function to generate a circular kernel
function [B4b]=circkern(kkern)
B4b=zeros(2*kkern+1, 2*kkern+1);

for ii=1:2*kkern+1
    for jj=1:2*kkern+1
        B4b(ii,jj)=sqrt((ii-(kkern+1)).^2+(jj-(kkern+1)).^2)<=kkern;
    end
end

end
