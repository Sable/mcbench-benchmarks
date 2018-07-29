function [u, uu, erriter, num, timet] = test_CMF3D_ML
%%
%   Function test_CMF3D_ML
%
%   The matlab function to show how to use the functions:
%               CMF3D_ML_mex and CMF3D_ML_GPU
%
%   Before using the function CMF3D_ML_mex, you should compile its source file as follows:
%
%       >> mex CMF3D_ML_mex.c
%
%   Before using the function CMF3D_ML_GPU, you should compile its 
%   GPU source file (for Windows):
%
%       >> nvmex -f nvmexopts.bat CMF3D_ML_GPU.cu -IC:\cuda\v4.0\include ...
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
%             para[0,1,2]: rows, cols, heights of the given 3D volume
%             para[3]: the number of labels or regions
%             para[4]: the maximum iteration number
%             para[5]: the error bound for convergence
%             para[6]: cc for the step-size of augmented Lagrangian method
%             para[7]: the step-size for the graident-projection step to the
%                    total-variation function. Its optimal range is [0.06, 0.12].
% 
%   Outputs: 
%
%       - u: the computed continuous labeling result u(x,i = 1...nlab) in [0,1], 
%           where nlab is the number of labels/volumes. 
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
%             >> [u, erriter, i, timet] = CMF3D_ML_GPU(single(penalty), single(Cs), single(Ct), single(para));
%           
%             >> You can choose a 2D slice to demonstrate the final result.
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

nii = load_nii('T1w_fa18_restore_brain.nii');
ur = double(nii.img);
umax = max(max(max(ur)));
umin = min(min(min(ur)));
ur = (ur - umin)/(umax-umin);
ur = ur(21:120, 70:170, 69:170);

% define the label information

nlab = 4;
ulab(1) = 0;
ulab(2) = 0.16;
ulab(3) = 0.4;
ulab(4) = 0.53;

[rows, cols, heights] = size(ur);

% build up the data terms

Ct = zeros(rows,cols,heights,nlab);

for i=1:nlab
    Ct(:,:,:,i) = abs(ur - ulab(i))*10;
end

% set up the input parameter vector
cc = 0.25;
varParas = [rows; cols; heights; nlab; 200; 1e-4; cc; 0.11];
%                para 0,1,2 - rows, cols, heights
%                para 3 - the total number of labels
%                para 4 - the maximum number of iterations
%                para 5 - the error bound for convergence
%                para 6 - cc for the step-size of augmented Lagrangian method
%                para 7 - the step-size for the graident-projection of the spatial flow fields p(x,i)

penalty = ones(rows,cols,heights);

% ----------------------------------------------------------------------
%  Use the function CMF3D_ML_mex to run the algorithm on CPU
% ----------------------------------------------------------------------

% [u, erriter,num,timet] = CMF3D_ML_mex(single(penalty), single(Ct), single(varParas));

% ----------------------------------------------------------------------
%  Use the function CMF3D_ML_GPU to run the algorithm on GPU
% ----------------------------------------------------------------------

[u, erriter,num,timet] = CMF3D_ML_GPU(single(penalty), single(Ct), single(varParas));

% The output u must be multiplied by cc to scale it in [0,1], 
% due to the implementation
u = cc*u;

[um,I] = max(u, [], 4);

uu = zeros(rows,cols,heights);

for k=1:rows
    for j=1:cols
        for i=1:heights
            uu(k,j,i) = ulab(I(k,j,i));
        end
    end
end