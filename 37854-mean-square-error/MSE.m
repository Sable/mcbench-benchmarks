function Mean_Square_Error= MSE(Reference_Image, Target_Image)

% Takes two images (2D) and returns Mean Square Error 
% Be aware Matrix dimensions must agree

% written by Amir Pasha Mahmoudzadeh
% Wright State University
% Biomedical Imaging Lab

Reference_Image = double(Reference_Image);
Target_Image = double(Target_Image);

[M N] = size(Reference_Image);
error = Reference_Image - Target_Image;
Mean_Square_Error = sum(sum(error .* error)) / (M * N);

end

