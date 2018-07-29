function L=getLap(imdata,winsz,mask,lambda)
% L=getLap(imdata,winsz) get the laplacian matrix based on imdata
% (image data) and winsz (local window size)
% 
% Input arguments:
% imdata: MxNxd matrix. Image size is MxN, and feature number is d. Value
%         range is within [0 255]
% winsz:  vec with 2-components showing size of local window for training
%         local linear models. Values will be obliged to be odd.
% mask:   MxN matrix specifying scribbles, with 1 foreground, -1 background
%         and 0 otherwise
% lambda: para of the regularization in training local linear model
% 
% Output arguments:
% L:     (MxN)X(MxN) sparse matrix
% 
% Note:
% 1. boundary pixel won't be used in training local models
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

disp('Computing Laplacian matrix ... ...')
L=getLap_iccv09_overlapping(imdata,winsz,mask,lambda);
