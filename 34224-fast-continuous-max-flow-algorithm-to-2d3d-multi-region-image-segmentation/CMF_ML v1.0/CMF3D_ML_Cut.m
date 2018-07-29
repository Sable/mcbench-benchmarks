function [u, uu, erriter, i, timet] = CMF3D_ML_Cut
%%
%   Performing the continuous max-flow algorithm to solve the 
%   3D continuous-cut problem with multiple labels (Potts Model)
%    
%   Usage: [u, uu, erriter, i, timet] = CMF3D_ML_Cut;
%
%   Inputs: there is no input since all data and parameters can be
%           adjusted within the program
%
%   Outputs: 
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
%   Example:
%       >> [u, uu, erriter, i, timet] = CMF3D_ML_Cut;
%
%       Show one slice of the 3D volume as follows:
%
%       >> imagesc(uu(:,:,20)), colormap jet, axis image, axis off; figure(gcf)
%
%       >> figure, loglog(erriter,'DisplayName','erriter'); figure(gcf)
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
%   Please email Jing Yuan (cn.yuanjing@gmail.com) for any questions, 
%   suggestions and bug reports
%
%   The Software is provided "as is", without warranty of any kind.
%
%
%                       Version 1.0
%
%           https://sites.google.com/site/wwwjingyuan/       
%
%           Copyright 2011 Jing Yuan (cn.yuanjing@gmail.com)      
%

nii = load_nii('T1w_fa18_restore_brain.nii');
ur = double(nii.img);
umax = max(max(max(ur)));
umin = min(min(min(ur)));
ur = (ur - umin)/(umax-umin);
ur = ur(21:120, 70:170, 69:170);

% define the required parameters:
%
%   - nlab: the number of labels or regions. 
%
%   - ulab: ulab(i=1...nlab) gives the nlab labels or image models.
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
%       The optimal range of cc is [0.1, 3].
%
%   - errbound: the error bound for convergence.
%
%   - numIter: the maximum iteration number.
%
%   - steps: the step-size for the graident-projection step to the
%       total-variation function. The optimal range of steps is [0,
%       0.13].
%

nlab=4; 

ulab(1) = 0;
ulab(2) = 0.16;
ulab(3) = 0.4;
ulab(4) = 0.53;

[rows, cols, heights]=size(ur);
vol = rows*cols*heights*nlab;

alpha = ones(rows,cols,heights);
cc = 0.25; 
beta = 1e-4;
steps = 0.11;
iterNum= 200; 

% build up the data terms
for i=1:nlab
    Ct(:,:,:,i) = abs(ur - ulab(i))*10;
end

% set the initial values:
%   - u(x,i=1...nlab) is set to be an initial cut, see below.
%
%   - the source flow field ps(x), see below.
%
%   - the nlab sink flow fields pt(x,i=1...nlab), set to be the specified 
%     legal flows.
%
%   - the spatial flow fiels p(x,i=1...nlab) = (pp1(x,i), pp2(x,i), pp3(x,i)), 
%     set to be zero.

u = zeros(rows,cols,heights,nlab);
pt = zeros(rows,cols,heights,nlab);

[ps,I] = min(Ct, [], 4);

for k=1:rows
    for j=1:cols
        for l=1:heights
            pt(k,j,l,:) = ps(k,j,l);
            u(k,j,l,I(k,j,l)) = 1;
        end
    end
end

divp = zeros(rows,cols,heights,nlab);

pp1 = zeros(rows, cols+1, heights, nlab);
pp2 = zeros(rows+1, cols, heights, nlab);
pp3 = zeros(rows, cols, heights+1, nlab);

erriter = zeros(iterNum,1);

tic
for i = 1:iterNum
    
    pd = zeros(rows,cols,heights);
    
    % update the flow fields within each layer i=1...nlab
    
    for k= 1:nlab
        
        % update the spatial flow field p(x,i) = (pp1(x,i), pp2(x,i), pp3(x,i)):
        % the following steps are the gradient descent step with steps as the
        % step-size.
        
        ud = divp(:,:,:,k) - (ps - pt(:,:,:,k) + u(:,:,:,k)/cc);
        
        % update the component pp1(x,i)
        
        pp1(:,2:cols,:,k) = steps*(ud(:,2:cols,:) - ud(:,1:cols-1,:)) + pp1(:,2:cols,:,k); 
        
        % update the component pp2(x,i)
        
        pp2(2:rows,:,:,k) = steps*(ud(2:rows,:,:) - ud(1:rows-1,:,:)) + pp2(2:rows,:,:,k);
        
        % update the component pp3(x,i)
        
        pp3(:,:,2:heights,k) = steps*(ud(:,:,2:heights) - ud(:,:,1:heights-1)) + pp3(:,:,2:heights,k);
        
        % the following steps give the projection to make |p(x,i)| <= alpha(x)
        
        gk = sqrt((pp1(:,1:cols,:,k).^2 + pp1(:,2:cols+1,:,k).^2 + pp2(1:rows,:,:,k).^2 ...
            + pp2(2:rows+1,:,:,k).^2 + pp3(:,:,1:heights,k).^2 + pp3(:,:,2:heights+1,k).^2)*0.5);

        gk = double(gk <= alpha) + double(~(gk <= alpha)).*(gk ./ alpha);
        gk = 1 ./ gk;
        
        % update the component pp1(x,i)
        
        pp1(:,2:cols,:,k) = (0.5*(gk(:,2:cols,:) + gk(:,1:cols-1,:))).*pp1(:,2:cols,:,k); 
        
        % update the component pp2(x,i)
        
        pp2(2:rows,:,:,k) = (0.5*(gk(2:rows,:,:) + gk(1:rows-1,:,:))).*pp2(2:rows,:,:,k);
        
        % update the component pp3(x,i)
        
        pp3(:,:,2:heights,k) = (0.5*(gk(:,:,2:heights) + gk(:,:,1:heights-1))).*pp3(:,:,2:heights,k);
        
        % recompute the divergence field divp(x,i)
        
        divp(:,:,:,k) = pp1(:,2:cols+1,:,k)-pp1(:,1:cols,:,k)+pp2(2:rows+1,:,:,k)-...
            pp2(1:rows,:,:,k) + pp3(:,:,2:heights+1,k) - pp3(:,:,1:heights,k);
        
        % update the sink flow field pt(x,i)
        
        ud = - divp(:,:,:,k) + ps + u(:,:,:,k)/cc;
        pt(:,:,:,k) = min(ud, Ct(:,:,:,k));
        
        % pd: the sum-up field for the computation of the source flow field
        %      ps(x)
        
        pd = pd + (divp(:,:,:,k) + pt(:,:,:,k) - u(:,:,:,k)/cc);
        
    end
    
    % updata the source flow ps

    ps = pd / nlab + 1 / (cc*nlab);
    
	% update the multiplier u
    
    erru_sum = 0;
    for k = 1:nlab
	    erru = cc*(divp(:,:,:,k) + pt(:,:,:,k) - ps);
	    u(:,:,:,k) = u(:,:,:,k) - erru;
        erru_sum = erru_sum + sum(sum(sum(abs(erru))));
    end
    
    % evaluate the avarage error
    
    erriter(i) = erru_sum/vol;
    
    if erriter(i) < beta
        break;
    end
    
end

toc
timet = toc

msg = sprintf('number of iterations = %u. \n', i);
disp(msg);

[um,I] = max(u, [], 4);

% reconstructing the image with the computed label-indicator function I(x)

uu = zeros(rows,cols,heights);

for k=1:rows
    for j=1:cols
        for l=1:heights
            uu(k,j,l) = ulab(I(k,j,l));
        end
    end
end