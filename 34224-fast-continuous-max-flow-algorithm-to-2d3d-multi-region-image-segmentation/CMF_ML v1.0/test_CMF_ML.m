function [u, uu, erriter, num, timet] = test_CMF_ML
%%
%   Function test_CMF_ML
%
%   The matlab function to show how to use the functions: 
%               CMF_ML_mex and CMF_ML_GPU
%
%   Before using the function CMF_ML_mex, you should compile its source file as follows:
%
%       >> mex CMF_ML_mex.c
%
%   Before using the function CMF_ML_GPU, you should compile its 
%   GPU source file (for Windows):
%
%       >> nvmex -f nvmexopts.bat CMF_ML_GPU.cu -IC:\cuda\v4.0\include ...
%       >> -LC:\cuda\v4.0\lib\x64 -lcufft -lcudart
%   
%   GPU compilation depends on your system and its configurations!
%
%   After compilation, you can define all the parameters (penalty, C_t, para) as follows: 
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
%        - C_t(x,i=1...nlab): point to the capacities of 
%                 sink flow fields pt(x,i=1...nlab);
% 
%        - para: a sequence of parameters for the algorithm
%             para[0,1]: rows, cols of the given image
%             para[2]: the number of labels or regions
%             para[3]: the maximum iteration number
%             para[4]: the error bound for convergence
%             para[5]: cc for the step-size of augmented Lagrangian method
%             para[6]: the step-size for the graident-projection step to the
%                    total-variation function. Its optimal range is [0.1, 0.17].
% 
%   Outputs: 
%
%       - u: the computed continuous labeling result u(x,i = 1...nlab) in [0,1], 
%           where nlab is the number of labels/regions. 
%
%       - uu: the final labeled result uu(x), computed by the u(x,i).
%
%       - erriter: it returns the error evaluation of each iteration,
%           i.e. it shows the convergence rate. One can check the algorithm
%           performance.
%
%       - i: gives the total number of iterations, when the algorithm converges.
%
%       - timet: gives the total computation time.
%
%       Example:
% 
%             >> [u, erriter, i, timet] = CMF_ML_GPU(single(penalty), single(Cs), single(Ct), single(para));
%           
%             >> To demonstrate the final result, see the related matlab file: CMF_ML_Cut.m
%
%             >> figure, loglog(erriter,'DisplayName','erriterN');figure(gcf)
%
%
%   The original algorithm was proposed in the following papers:
%
%   [1] Yuan, J.; Bae, E.;  Tai, X.-C.
%       A Study on Continuous Max-Flow and Min-Cut Approaches 
%       CVPR, 2010
%
%   [2] Yuan, J.; Bae, E.; Tai, X.-C.; Boycov, Y.
%       A Continuous Max-Flow Approach to Potts Model
%       ECCV, 2010
%
%   The mimetic finite-difference discretization method was proposed for 
%   the total-variation function in the paper:
%
%   [1] Yuan, J.; Schn{\"o}rr, C.; Steidl, G.
%       Simultaneous Optical Flow Estimation and Decomposition
%       SIAM J.~Scientific Computing, 2007, vol. 29, page 2283-2304, number 6
%
%   This software can be used only for research purposes, you should cite ALL of
%   the aforementioned papers in any resulting publication.
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

ur = double(imread('ColorInput.png'))/255;

% define the label information

nlab=4; 

ulab(1,:) = [100,225,0]/255;
ulab(2,:) = [225,0,100]/255;
ulab(3,:) = [0,100,225]/255;
ulab(4,:) = [255,255,255]/255;

[rows,cols,color] = size(ur);

% build up the data terms

Ct = zeros(rows,cols,nlab);

for i=1:nlab
    Ct(:,:,i) = (abs(ur(:,:,1) - ulab(i,1)) + abs(ur(:,:,2) - ulab(i,2)) + abs(ur(:,:,3) - ulab(i,3)));
end

% set up the input parameter vector
cc = 0.2;
varParas = [rows; cols; nlab; 300; 1e-4; cc; 0.16];
%                para 0,1 - rows, cols
%                para 2 - the total number of labels
%                para 3 - the maximum number of iterations
%                para 4 - the error bound for convergence
%                para 5 - cc for the step-size of augmented Lagrangian method
%                para 6 - the step-size for the graident-projection of the spatial flow fields p(x,i)

penalty = ones(rows,cols);

% ----------------------------------------------------------------------
%  Use the function CMF_ML_mex to run the algorithm on CPU
% ----------------------------------------------------------------------

% [u, erriter, num, timet] = CMF_ML_mex(single(penalty), single(Ct), single(varParas));

% ----------------------------------------------------------------------
%  Use the function CMF_ML_GPU to run the algorithm on GPU
% ----------------------------------------------------------------------

[u, erriter, num, timet] = CMF_ML_GPU(single(penalty), single(Ct), single(varParas));

% The output u must be multiplied by cc to scale it in [0,1], 
% due to the implementation
u = cc*u;

[um,I] = max(u, [], 3);

% reconstructing the image with the computed label-indicator function I(x)

uu = zeros(rows,cols,color);

for k=1:rows
    for j=1:cols
        uu(k,j,:) = ulab(I(k,j),:);
    end
end