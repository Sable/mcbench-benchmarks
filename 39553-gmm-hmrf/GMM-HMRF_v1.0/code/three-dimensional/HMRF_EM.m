%%  The EM algorithm
%---input---------------------------------------------------------
%   X: initial 2D labels
%   Y: image
%   GMM: Gaussian mixture model parameters
%   k: number of labels
%   g: number of components of each GMM
%   EM_iter: maximum number of iterations of the EM algorithm
%   MAP_iter: maximum number of iterations of the MAP algorithm
%---output--------------------------------------------------------
%   X: final 3D labels
%   GMM: Gaussian mixture model parameters

%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.

function [X GMM]=HMRF_EM(X,Y,GMM,k,g,EM_iter,MAP_iter,beta)

sum_U=zeros(1,EM_iter);

for it=1:EM_iter
    fprintf('Iteration: %d\n',it);
    %% update X
    [X sum_U(it)]=MRF_MAP(X,Y,GMM,k,g,MAP_iter,beta,0);

    %% update GMM
    GMM=get_GMM(X,Y,g);
    
    if it>=3 && std(sum_U(it-2:it))<0.01
        break;
    end
end

figure;
plot(1:it,sum_U(1:it),'LineWidth',2);
hold on;
plot(1:it,sum_U(1:it),'.','MarkerSize',20);
title('sum of U in each EM iteration');
xlabel('EM iteration');
ylabel('sum of U');
