function A_inter = my_interp(A, filter_coef)
% Interpolation function
% This function performs the interpolation of the input image, 
% using the specified filter
% 
% Input:    A: input image
%           filter_coef: filter coefficients
%           example:    filter_coef = [1 1]/2 (Bilinear Filter)
%                       filter_coef = [1 -5 20 20 -5 1]/32 (6-tap filter)
% Output:   A_inter:  interpolated image
% 
% Athanasopoulos Dionysios 
% Postgraduate Student
% Computer Engineering and Informatics Dept.
% University of Patras, Greece


if (length(size(A)) == 3)
% if the input image is an RGB image or an YUV image
% or any 3D matrix just interpolate the three components separetely
    for i=1:3
        A_inter(:,:,i) = my_interp(A(:,:,i),filter_coef);
    end
    
else
    
    [m,n] = size(A);
    A_ = []; A_inter = [];
    % columns interpolation
    A_col= filter2(filter_coef,A);
    for i=1:n
        A_ = [A_ A(:,i) A_col(:,i)];
    end
    A_(:,end) = [];
    % rows interpolation
    A_rows = filter2(filter_coef,A_')';
    for i=1:m
        A_inter = [A_inter; A_(i,:); A_rows(i,:)];
    end
    A_inter(end,:) = [];
    
end