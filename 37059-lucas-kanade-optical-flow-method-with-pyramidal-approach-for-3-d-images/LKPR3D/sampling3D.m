function output = sampling3D( input, option )
%This function will downsample or upsample a 3-D image by a factor of 2.
%   Description :
%
%   -input : input 3-D matrix
%   =option : options; 1 for downsample and 2 for upsample 
%   -output : downsampled 3-D image
%
%   Author: Mohammad Mustafa
%   By courtesy of The University of Nottingham and Mirada Medical Limited,
%   Oxford, UK
%
%   Published under a Creative Commons Attribution-Non-Commercial-Share Alike
%   3.0 Unported Licence http://creativecommons.org/licenses/by-nc-sa/3.0/
%   
%   June 2012

if option==1
    % Downsampling by a factor of 2
    input=imfilter(input,gaussianKernel3D(2,1.5)); 
    output = input(1:2:size(input,1),1:2:size(input,2),1:2:size(input,3));
elseif option==2
    % Upsampling by a factor of 2
    output=zeros(2*size(input));
    for i=1:size(input,1) 
    for j=1:size(input,2)
    for k=1:size(input,3)
            output(2*i-1:2*i,2*j-1:2*j,2*k-1:2*k)=input(i,j,k); 
    end
    end
    end
    
    output=imfilter(output,gaussianKernel3D(2,1.5));
    
else
    error('Option needs to be either 1 or 2.');
end

end

