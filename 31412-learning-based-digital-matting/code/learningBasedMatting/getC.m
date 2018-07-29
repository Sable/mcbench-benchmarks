function C=getC(mask,c)
% C=getC(mask,c) get the regularization matrix as shown in equation (6) in
% our iccv09 paper
% 
% Input arguments:
% mask:   MxN matrix specifying scribbles, with 1 foreground, -1 background
%         and 0 otherwise
% c:      parameter adjusting the regularization term's importance
% 
% Output argument:
% C:     (MxN)X(MxN) sparse matrix
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

disp('Computing regularization matrix ... ...')
scribble_mask=abs(mask)~=0;
numPix=size(mask,1)*size(mask,2);
C=c*spdiags(double(scribble_mask(:)),0,numPix,numPix);

