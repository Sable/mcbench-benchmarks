function [u, erriter, i, timet] = CMF_Cut
%
%   Performing the continuous max-flow algorithm to solve the 
%   continuous min-cut problem in 2D
%    
%   Usage: [u, erriter, i, timet] = CMF_Cut;
%
%   Inputs: there is no input since all data and parameters can be
%           adjusted within the program
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
%       >> [u, erriter, i, timet] = CMF_Cut;
%
%       >> us = max(u, beta);  % where beta in (0,1)
%
%       >> imagesc(us), colormap gray, axis image, axis off;figure(gcf)
%
%       >> figure, loglog(erriter,'DisplayName','erriterN');figure(gcf)
%
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

ur = double(imread('cameraman.jpg'))/255;

[rows, cols] = size(ur);
imgSize = rows*cols;

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
%       The optimal range of cc is [0.3, 3].
%
%   - errbound: the error bound for convergence.
%
%   - numIter: the maximum iteration number.
%
%   - steps: the step-size for the graident-projection step to the
%       total-variation function. The optimal range of steps is [0.1,
%       0.17].
%

alpha = 0.5*ones(rows,cols); 
cc = 0.3;
errbound = 1e-4;
numIter = 300;
steps = 0.16;

% build up the data terms
ulab(1) = 0.15;
ulab(2) = 0.6;
Cs = abs(ur - ulab(1));
Ct = abs(ur - ulab(2));

% set the initial values
%   - the initial value of u is set to be an initial cut, see below.
%   - the initial values of two terminal flows ps and pt are set to be the
%     specified legal flows.
%   - the initial value of the spatial flow fiels p = (pp1, pp2) is set to
%   be zero.

u = double((Cs-Ct) >= 0);
ps = min(Cs, Ct);
pt = ps;

pp1 = zeros(rows, cols+1);
pp2 = zeros(rows+1, cols);
divp = pp1(:,2:cols+1)-pp1(:,1:cols)+pp2(2:rows+1,:)-pp2(1:rows,:);

erriter = zeros(numIter,1);

tic
for i = 1:numIter

	% update the spatial flow field p = (pp1, pp2):
    %   the following steps are the gradient descent step with steps as the
    %   step-size.
    
    pts = divp - (ps - pt  + u/cc);
    pp1(:,2:cols) = pp1(:,2:cols) + steps*(pts(:,2:cols) - pts(:,1:cols-1)); 
    pp2(2:rows,:) = pp2(2:rows,:) + steps*(pts(2:rows,:) - pts(1:rows-1,:));
    
    % the following steps give the projection to make |p(x)| <= alpha(x)
    
    gk = sqrt((pp1(:,1:cols).^2 + pp1(:,2:cols+1).^2 + pp2(1:rows,:).^2 + pp2(2:rows+1,:).^2)*0.5);
    gk = double(gk <= alpha) + double(~(gk <= alpha)).*(gk ./ alpha);
    gk = 1 ./ gk;
    
    pp1(:,2:cols) = (0.5*(gk(:,2:cols) + gk(:,1:cols-1))).*pp1(:,2:cols); 
    pp2(2:rows,:) = (0.5*(gk(2:rows,:) + gk(1:rows-1,:))).*pp2(2:rows,:);
    
    divp = pp1(:,2:cols+1)-pp1(:,1:cols)+pp2(2:rows+1,:)-pp2(1:rows,:);
    
    % updata the source flow ps
    
    pts = divp + pt - u/cc + 1/cc;
    ps = min(pts, Cs);
    
    % update the sink flow pt
    
    pts = - divp + ps + u/cc;
    pt = min(pts, Ct);

	% update the multiplier u
    
	erru = cc*(divp + pt  - ps);
	u = u - erru;
    
    % evaluate the avarage error
    
    erriter(i) = sum(sum(abs(erru)))/imgSize; 
   
    if (erriter(i) < errbound)
        break;
    end
end
toc
timet = toc

msg = sprintf('number of iterations = %u. \n', i);
disp(msg);


