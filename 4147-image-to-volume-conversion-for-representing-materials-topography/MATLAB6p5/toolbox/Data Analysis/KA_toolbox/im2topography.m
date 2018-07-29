function topog=im2topography(afm_im,N,A);
% function topog=im2topography(afm_im,N,A);
%
% function for creating a volume (array of images) representing toporgraphy from an AFM
% height image afm_im
%
% N - number of depth levels to include - the larger the N - the larger the
% aspect ratio of the volume representing the topography
%
% A-the value of intensity to color-code the material
% where no material is present the value of 256 is assinged
% 
% written by K.Artyushkova
% 102003

% Kateryna Artyushkova
% Postdoctoral Scientist
% Department of Chemical and Nuclear Engineering
% The University of New Mexico
% (505) 277-0750
% kartyush@unm.edu 

a=[1:N];
[Min2, Max2]=max_min_pix_value(afm_im); % calculate max and mean value for afm top image;
im_new=map_con(afm_im, Min2, Max2, 1, N); % map afm image to min and max depth level
im=round(im_new); %mapped rounded AFM image

[p,q]=size(im);
m=min(min(im)); 
M=max(max(im));

r=size(a);
r=r(2);
for i=1:r
    im_array(:,:,i)=zeros(p,q); % crease empty array of images - the number corresponds to the number of depth levels 
end

% splitting a single afm image to different depth slices. 
% all pixels corresponding to the same depth levels put into separate images and the values
% of intensity for this pixels in these new images is assigned a value of A 
for i=1:p
    for j=1:q
    val=im(i,j);
    I=find(a==val);
    im_array(i,j,I)=A;
end
end

% summing up created image slices to get a sum representations of depth
% level
topog(:,:,1)=im_array(:,:,r);
for i=2:r
    topog(:,:,i)=topog(:,:,i-1);
    topog(:,:,i)=topog(:,:,i)+im_array(:,:,r-i+1);    
end

% sunstituting all the zeros with white color - 256
for i=1:p
    for j=1:q
        for k=1:r
            B=topog(i,j,k);
            if B==0
                topog(i,j,k)=256;
            end         
        end
    end
end

% creating the first image -bottom- with all the pixels equal to A 
topog(:,:,r+1)=A*ones(p,q);