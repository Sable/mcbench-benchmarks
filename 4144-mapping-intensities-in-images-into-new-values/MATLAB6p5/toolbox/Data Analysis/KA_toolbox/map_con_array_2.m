function im_map=map_con_array_2(im_orig, Cmin1, Cmax1, Cmin2, Cmax2);

% function im_map=map_con_array_2(im_orig, Cmin1, Cmax1, Cmin2, Cmax2);
%
% mapping array of images to concentrations using Min and Max for top and bottom images 
% use map_con_array_1 for mapping using Min and Max for a single image
%
% im_orig - original array (nxmxp)
% Cmin1 and Cmax1 - concentration within the darkest and brightest for image 1
% Cmin2 and Cmax2 - concentration within the darkest and brightest for image 2 (last image)
%
% written by K.Artyushkova
% 08.2003

% Kateryna Artyushkova
% Postdoctoral Scientist
% Department of Chemical and Nuclear Engineering
% The University of New Mexico
% (505) 277-0750
% kartyush@unm.edu 

[n,m,p]=size(im_orig);

[MinPixVal, MaxPixVal]=max_min_pix_value(im_orig); % determine maximum and minimum values of intensity in original images

mx=MaxPixVal;% vector of maximum concnetrations
mn=MinPixVal; % vector of minimum concnetrations
K1=Cmax1/mx(1); % Max mapping coefficient for the 1st image
K2=Cmax2/mx(p); % Max mapping coefficient for the last image
k1=Cmin1/mn(1);% Min mapping coefficient for the last image
k2=Cmin2/mn(p);% Minmapping coefficient for the last image

for i=0:p-1
    alpha=i/(p-1); % weighting factor for i-th image
    Max=mx(i+1)*((1-alpha)*K1+ alpha*K2); % Max concnetration for i-th image
    Min=mn(i+1)*((1-alpha)*k1+ alpha*k2); % Min concentration for i-th image
    im_map(:,:,i+1)=map_con(im_orig(:,:,i+1), mn(i+1), mx(i+1), Min, Max); % calling the function map_con to map each image to new values
end

[NMinPixVal, NMaxPixVal]=max_min_pix_value(im_map);

subplot(2,1,1)
plot(MinPixVal); 
Title ('Min and Max in Original images')
hold on
plot(MaxPixVal, 'g')
subplot(2,1,2)
plot(NMinPixVal); 
title('Min and Max in Mapped images')
hold on
plot(NMaxPixVal, 'g')