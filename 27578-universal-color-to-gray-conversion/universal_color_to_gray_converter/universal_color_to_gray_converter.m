function ugray0 = universal_color_to_gray_converter(u, method_flag, method_name)

% This function provides different methods to convert a color images to a gray-value image.
%
% April 15th, 2010, By Reza Farrahi Moghaddam, Synchromedia Lab, ETS, Montreal, Canada
%
% The implemented methods are:
% 'normal', 'standard': rgb2gray of Matlab; ITU-R Recommendation BT.601.
% 'avg', 'average': the output is the average of all three channels.
% 'minavg', 'min_avg', 'min_average', 'minimum_average': The minimum-average method introduced in [1] for document image processing. it has less color dependency.
%
% [1] R. Farrahi Moghaddam and M. Cheriet, A multi-scale
% framework for adaptive binarization of degraded document images, Pattern
% Recognition, 43, pp. 2186--2198, 2010, DOI: 10.1016/j.patcog.2009.12.024
%
%
% USAGE:
% ugray0 = universal_color_to_gray_converter(u, method_flag, method_name);
% where
%       u is the input color image.
%       method_flag is 'method'
%       method_name is one of above mentioned methods.
%       ugray0 is the output gray-level image.
% OR
% ugray0 = universal_color_to_gray_converter(u);
% where
%       u is the input color image.
%       ugray0 is the output gray-level image; in this case, the method is
%       'min_avg';



%
if (nargin == 1)
    method_name = 'minimum_average';
end

%
switch method_name
    case ''
        method_name = 'normal';    
    case 'standard'
        method_name = 'normal';         
    case 'avg'
        method_name = 'average';
    case 'minavg'
        method_name = 'minimum_average';
    case 'min_avg'
        method_name = 'minimum_average';
    case 'min_average'
        method_name = 'minimum_average';
    otherwise 
        fprintf('error\n');
end

%
[xm, ym, zm] = size(u);

%
switch method_name
    case 'normal'
        ugray0 = rgb2gray(u);    
    case 'average'
        if (max(max(max(u))) > 1.5)
            u = double(u) / 255;
        end
        if (zm > 1)
            ugray0 = ((double(u(:,:,1))+double(u(:,:,2))+double(u(:,:,3)))/3);
        else%z
            ugray0 = im2double(i);
        end%z
    case 'minimum_average'
        if (max(max(max(u))) > 1.5)
            u = double(u) / 255;
        end
        if (zm > 1)
            ugray0 = ( double(min(u,[],3)) + ...
                (double(u(:,:,1))+double(u(:,:,2))+double(u(:,:,3)))/3)/2;
        else%z
            ugray0 = im2double(i);
        end%z
    otherwise
        fprintf('error\n');
end

end







