function Iout = bwNoiseReduction(IBW,n,NUM)
%--------------------------------------------------------------------------
%   bwNoiseReduction - Reduce noise in Binary Image
%--------------------------------------------------------------------------
%Comments:
%
%   This function gets the binary image and according to connectivity
%   labeld the objects in Image and through the numbers of pixels in each  
%   connected component determined wether oject is noise or not.
%                                                                          
%--------------------------------------------------------------------------
%Usage:
%       Iout = bwNoiseReduction(IBW,n,NUM)
%--------------------------------------------------------------------------
%
%Arguments:
%       IBW  - a binary image. backgroung pixels have zerro value and
%       forground and noisy objects have one value.
%       n    -  n can have a value of either 4 or 8, where 4 specifies
%       4-connected objects and 8 specifies 8-connected objects; if the
%       argument is omitted, it defaults to 8.
%       NUM  - Threshould number of object's pixels in binary image 
%       consider as noise
%
%Return:
%       Iout - a biary image.
%--------------------------------------------------------------------------
%Written by:
%       Javad Razjouyan
%       Biomedical Engieering Department, Faculty of Engineering
%       University of Shahed,Iran
%       Javad_Razjouyan@yahoo.com
%
%July 3,2006    - Original Version
%--------------------------------------------------------------------------
%
%
%Set default values
if nargin == 1
    n = 8; 
    NUM = 10;
elseif nargin == 2
    NUM = 10;
end
%--------------------------------------------------------------------------
%   Labeling the Input BW Image
%--------------------------------------------------------------------------
[L,obj] = bwlabel(IBW,n);  
%--------------------------------------------------------------------------
%   main process start here
%--------------------------------------------------------------------------
Iout = IBW;
for i=1:obj
    fbw = find(L==i);
    if length(fbw) < NUM 
        Iout(fbw) = 0;
    end
end


