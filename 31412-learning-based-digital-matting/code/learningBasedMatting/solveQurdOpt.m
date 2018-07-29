function alpha=solveQurdOpt(L,C,alpha_star)
% alpha=solveQurdOpt(L,C,alpha_star) solves the quadratic optimization
% problem. See equation (7) in our iccv09 paper.
% 
% Input arguments:
% L:     (MxN)X(MxN) sparse laplacian matrix
% C:     (MxN)X(MxN) sparse regularization matrix
% alpha_star:     (MxN) matrix showing the prio-known value of alpha.
%                 The value is 1 for foreground scribble pixels, and 0
%                 otherwise
% 
% Output arguments:
% alpha:     (MxN) matrix of alpha solution
% 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% @InProceedings{ZhengICCV09,
%   author = {Yuanjie Zheng and Chandra Kambhamettu},
%   title = {Learning Based Digital Matting},
%   booktitle = {The 20th IEEE International Conference on Computer Vision},
%   year = {2009},
%   month = {September--October}
% }
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% Copyright Yuanjie Zheng @ PICSL @ UPenn on May 9th, 2011
% zheng.vision@gmail.com
% http://sites.google.com/site/zhengvision/
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

disp('Solving quadratic optimization problem ... ...')
lambda=1e-6;
D=speye(size(L,1),size(L,2));
alpha=(L+C+D*lambda)\(C*alpha_star(:));
alpha=reshape(alpha,size(alpha_star,1),size(alpha_star,2));

% if alpha value of labelled pixels are -1 and 1, the resulting alpha are
% within [-1 1], then the alpha results need to be mapped to [0 1]
if min(alpha_star(:))==-1
    alpha=alpha*0.5+0.5;
end
% 
alpha=max(min(alpha,1),0);