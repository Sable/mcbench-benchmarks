function [u, erriter, i, timet] = CMF3D_Cut
%
%   Performing the continuous max-flow algorithm to solve the 
%   continuous min-cut problem in 3D
%    
%   Usage: [u, erriter, i, timet] = CMF3D_Cut;
%
%   Inputs: there is no input. All data and parameters can be
%           changed within the program
%
%   Outputs: 
%       - u: the final results u(x) in [0,1]. As the following paper,
%           the global binary result can be available by threshholding u
%           by any constant alpha in (0,1):
%
%           Nikolova, M.; Esedoglu, S.; Chan, T. F. 
%           Algorithms for Finding Global Minimizers of Image Segmentation and Denoising Models 
%           SIAM J. App. Math., 2006, 66, 1632-1648
%
%       - erriter: it returns the error evaluation of each iteration,
%           i.e. it shows the convergence rate. One can check the algorithm
%           performance.
%
%       - i: gives the total number of iterations, when the algorithm converges.
%
%       - timet: gives the total computation time.
%       
%   Example:
%       >> [u, erriter, i, timet] = CMF3D_Cut;
%
%       >> us = max(u, beta);  % where beta in (0,1)
%
%       >> figure, loglog(erriter,'DisplayName','erriterN');figure(gcf)
%
%       >> isosurface(u,0.5), axis([1 rows 1 cols 1 heights]), daspect([1 1 1]);
%
%           
%   The original algorithm was proposed in the following papers:
%
%   [1] Yuan, J.; Bae, E.;  Tai, X.-C. 
%       A Study on Continuous Max-Flow and Min-Cut Approaches 
%       CVPR, 2010
%
%   [2] Yuan, J.; Bae, E.; Tai, X.-C.; Boycov, Y.
%       A study on continuous max-flow and min-cut approaches. Part I: Binary labeling
%       UCLA CAM, Technical Report 10-61, 2010
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
%   Please email cn.yuanjing@gmail.com for any questions, suggestions and bug reports
%
%   The Software is provided "as is", without warranty of any kind.
%
%
%                       Version 1.0
%           https://sites.google.com/site/wwwjingyuan/       
%
%           Copyright 2011 Jing Yuan (cn.yuanjing@gmail.com)      
%

nfi_data = load_nii('IM_0190_frame_01.nii');
ur = double(nfi_data.img)/255;

[rows, cols, heights]=size(ur);
szVol = rows*cols*heights;

% define the required parameters:
%
%   - alpha: the penalty parameter to the total-variation term.
%       For the case without incorporating image-edge weights, alpha is given
%       by the constant everywhere. For the case with image-edge weights,
%       alpha is given by the pixelwise weight function:
%
%       For example, alpha(x) = b/(1 + a*| nabla f(x)|) where b and a are positive
%       constants and |nabla f(x)| gives the strength of the local gradient.
%
%   - cc: gives the step-size of the augmented Lagrangian method.
%       The optimal range of cc is [0.2, 3].
%
%   - errbound: the error bound for convergence.
%
%   - numIter: the maximum iteration number.
%
%   - steps: the step-size for the graident-projection step to the
%       total-variation function. The optimal range of steps is [0.07,
%       0.12].
%

alpha = 0.2*ones(rows,cols,heights); 
cc = 0.35;
errbound = 5e-4;
numIter = 300;
steps = 0.11;

ulab(1) = 0.2;
ulab(2) = 0.7;

% build up the priori L_2 data terms
Cs = abs(ur - ulab(1));
Ct = abs(ur - ulab(2));

% set the starting values
u = double((Cs-Ct) >= 0);
ps = min(Cs, Ct);
pt = ps;

pp1 = zeros(rows, cols+1, heights);
pp2 = zeros(rows+1, cols, heights);
pp3 = zeros(rows, cols, heights+1);
divp = - pp2(1:rows,:,:) + pp2(2:rows+1,:,:) + pp1(:,2:cols+1,:) ...
       - pp1(:,1:cols,:) + pp3(:,:,2:heights+1) - pp3(:,:,1:heights);
    
erriter = zeros(numIter,1);

tic
for i = 1:numIter

    % update the spatial flow field p = (pp1, pp2, pp3):
    %   the following steps are the gradient descent step with steps as the
    %   step-size.
    
    pts = divp - (ps - pt + u/cc);
    pp1(:,2:cols,:) = pp1(:,2:cols,:) + steps*(pts(:,2:cols,:) - pts(:,1:cols-1,:)); 
    pp2(2:rows,:,:) = pp2(2:rows,:,:) + steps*(pts(2:rows,:,:) - pts(1:rows-1,:,:));
    pp3(:,:,2:heights) = pp3(:,:,2:heights) + steps*(pts(:,:,2:heights) - pts(:,:,1:heights-1));

    % the following steps give the projection to make |p(x)| <= alpha(x)
    
    gk = sqrt((pp1(:,1:cols,:).^2 + pp1(:,2:cols+1,:).^2 + ...
               pp2(1:rows,:,:).^2 + pp2(2:rows+1,:,:).^2 + ...
               pp3(:,:,1:heights).^2 + pp3(:,:,2:heights+1).^2)*0.5);

    gk = double(gk <= alpha) + double(~(gk <= alpha)).*(gk ./ alpha);
    gk = 1 ./ gk;
    
    pp1(:,2:cols,:) = (0.5*(gk(:,2:cols,:) + gk(:,1:cols-1,:))).*pp1(:,2:cols,:); 
    pp2(2:rows,:,:) = (0.5*(gk(2:rows,:,:) + gk(1:rows-1,:,:))).*pp2(2:rows,:,:);
    pp3(:,:,2:heights) = (0.5*(gk(:,:,2:heights) + gk(:,:,1:heights-1))).*pp3(:,:,2:heights); 

    divp = - pp2(1:rows,:,:) + pp2(2:rows+1,:,:) + pp1(:,2:cols+1,:) ...
           - pp1(:,1:cols,:) + pp3(:,:,2:heights+1) - pp3(:,:,1:heights);

    % updata the source flow ps
    
    pts = divp - u/cc + pt + 1/cc;
    ps = min(pts, Cs);

    % update the sink flow pt
    
    pts = - divp + ps + u/cc;
    pt = min(pts, Ct);
    
    % update the multiplier u
    
    erru = cc*(divp + pt - ps);
    u = u - erru;
    
    % evaluate the avarage error
    
    erriter(i) = sum(sum(sum(abs(erru))))/szVol; 

    if (erriter(i) < errbound)
        break;
    end
end

toc
timet = toc

msg = sprintf('number of iterations = %u. \n', i);
disp(msg);

%isosurface(lambda,0.5), axis([1 100 1 100 1 100]), daspect([1 1 1]);