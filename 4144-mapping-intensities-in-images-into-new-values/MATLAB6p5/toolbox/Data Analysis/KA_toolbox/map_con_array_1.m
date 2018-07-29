function im_map=map_con_array_1(im_orig, N, Cmin, Cmax);

% function im_map=map_con_array_1(im_orig, N, Cmin, Cmax);
%
% mapping array of images to concentrations using information from one slice N
% use map_con_array_2 for mapping using Min and Max for two - top and bottom images
%
% im_orig - original array (nxmxp)
% N - number of image within the array at which concentration within the brightest and darjest areas are known
% Cmin and Cmax - concentration within the brightest and darjest areas are known
%
% written by K.Artyushkova
% 09.2002

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

b1=mx(N); 
b2=mn(N);


for i=1:p
    Kmax(i)=mx(i)/b1;
    Kmin(i)=mn(i)/b2;
    Max(i)=Cmax*Kmax(i);
    Min(i)=Cmin*Kmin(i);
    im_map(:,:,i)=map_con(im_orig(:,:,i), MinPixVal(i), MaxPixVal(i), Min(i), Max(i));
end

[NMinPixVal, NMaxPixVal]=max_min_pix_value(im_map);

subplot(2,1,1)
plot(MinPixVal);
hold on
plot(MaxPixVal, 'g')
title('Max and Min in original images')
subplot(2,1,2)
plot(NMinPixVal);
hold on
plot(NMaxPixVal, 'g')
title('Max and Min in Mapped images')