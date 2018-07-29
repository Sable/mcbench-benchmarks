function Iout = imtranslate(I, translation, F, method, same_size)
%SCd 12/21/2009
%Affine translates a 2D or 3D image
%
%Input Arguments:
%   -I = 2D or 3D image
%   -translation = 
%        -[row_shift col_shift] for 2D images
%        -[row_shift col_shift pag_shift] for 3D images 
%   -F = values to pad the image with (optional, defaults to 0)
%   -method = interpolation method (optional, defaults to 'linear')
%   -same_size = 1 or 0, 1 if the output image is to be the same size as
%       the input image (optional, defaults to 1)
%
%Output Arguments:
%   -Iout = translated image
%
    
    if nargin < 2
        error('Missing input arguments: imtranslate(I, translation)');
    elseif nargin == 2
        F = 0;
        method = 'linear';
        same_size = 1;
    elseif nargin == 3
        method = 'linear';
        same_size = 1;
    elseif nargin == 4
        same_size = 1;
    end
   
    dims = max(size(translation));
    if dims ~= max(size(size(I)))
        error('a:b', 'The number of translations is not equal to the dimensions of the image. \n Use 0 for dimensions which are not to be shifted.');
    elseif dims == 2
        T_dims = [1 2];  %Dimensions in order
        A = zeros(3);
        A([1 5 9]) = 1;
        A(3,1:2) = translation;        
    elseif dims == 3    
        T_dims = [1 2 3]; 
        A = zeros(4);
        A([1 6 11 16]) = 1;
        A(4,1:3) = translation;
    else 
        error('I must be a 2D or 3D image');
    end
    
    if same_size
        T_size_b = size(I); %In order to recieve an image of the same size with data outside of dimensions cropped.
    else
        T_size_b = size(I) + ceil(abs(translation));  %In order to create a new image big enough for the translation
    end
    
    R = makeresampler(method, 'fill');  %Interpolation method and filling the blank spots as opposed to shifting back.
    Tmap = []; %Unused with the Tform.       
    Tform = maketform('affine', A);  %Generate the affine transformation
   
    Iout = tformarray(I, Tform, R, T_dims, T_dims, T_size_b, Tmap, F);

end