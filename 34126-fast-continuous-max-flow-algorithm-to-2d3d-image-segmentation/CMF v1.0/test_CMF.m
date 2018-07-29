function [uu, erriter, num, tt] = test_CMF
%
%   Function test_CMF
%
%   The matlab function to show how to use the functions CMF_Mex and CMF_GPU
%
%   Before using the functions CMF_mex, you should compile it as follows:
%       >> mex CMF_mex.c
%
%   Before using the functions CMF_GPU, you should compile the GPU program:
%       >> nvmex -f nvmexopts.bat CMF_GPU.cu -IC:\cuda\v4.0\include -LC:\cuda\v4.0\lib\x64 -lcufft -lcudart
%
%   After compilation, you can define all the parameters (penalty, C_s, C_t, para) as follows: 
%   
%        - penalty: point to the edge-weight penalty parameters to
%                   total-variation function.
% 
%          For the case without incorporating image-edge weights, 
%          penalty is given by the constant everywhere. For the case 
%          with image-edge weights, penalty is given by the pixelwise 
%          weight function:
% 
%          for example, penalty(x) = b/(1 + a*| grad f(x)|) where b,a > 0 .
% 
%        - C_s: point to the capacities of source flows ps
% 
%        - C_t: point to the capacities of sink flows pt
% 
%        - para: a sequence of parameters for the algorithm
%             para[0,1]: rows, cols of the given image
%             para[2]: the maximum iteration number
%             para[3]: the error bound for convergence
%             para[4]: cc for the step-size of augmented Lagrangian method
%             para[5]: the step-size for the graident-projection step to the
%                    total-variation function. Its optimal range is [0.1, 0.17].
% 
%
%        Example:
%            >> [u, erriter, i, timet] = CMF_GPU(single(penalty), single(Cs), single(Ct), single(para));
%
%            >> us = max(u, beta);  % where beta in (0,1)
%
%            >> imagesc(us), colormap gray, axis image, axis off;figure(gcf)
%
%            >> figure, loglog(erriter,'DisplayName','erriterN');figure(gcf)
%
%
%
%   Please email Jing Yuan (cn.yuanjing@gmail.com) for any questions, 
%   suggestions and bug reports
%
%   The Software is provided "as is", without warranty of any kind.
%
%               Version 1.0
%   https://sites.google.com/site/wwwjingyuan/       
%
%   Copyright 2011 Jing Yuan (cn.yuanjing@gmail.com)   
%

ur = double(imread('cameraman.jpg'))/255;
[rows, cols] = size(ur);

varParas = [rows; cols; 300; 1e-4; 0.3; 0.16];
%                para 0,1 - rows, cols of the given image
%                para 2 - the maximum number of iterations
%                para 3 - the error bound for convergence
%                para 4 - cc for the step-size of augmented Lagrangian method
%                para 5 - the step-size for the graident-projection of p

penalty = 0.5*ones(rows,cols);

ulab(1) = 0.15;
ulab(2) = 0.6;

% build up the priori data terms
fCs = abs(ur - ulab(1));
fCt = abs(ur - ulab(2));

% ----------------------------------------------------------------------
%  Use the function CMF_Mex to run the algorithm on CPU
% ----------------------------------------------------------------------
%[uu, erriter,num,tt] = CMF_mex(single(penalty), single(fCs), single(fCt), single(varParas));

% ----------------------------------------------------------------------
%  Use the function CMF_GPU to run the algorithm on GPU
% ----------------------------------------------------------------------
[uu, erriter,num,tt] = CMF_GPU(single(penalty), single(fCs), single(fCt), single(varParas));