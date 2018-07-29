function alpha_star=getAlpha_star(mask)
% alpha_star=getAlpha_star(mask) get the pri-known alpha values according
% to the mask. See equation (6) in our iccv2009 paper.
% 
% Input arguments:
% mask:   MxN matrix specifying scribbles, with 1 foreground, -1 background
%         and 0 otherwise
% 
% Output arguments:
% alpha_star:     (MxN) matrix showing the prio-known value of alpha.
%                 The value is 1 for foreground scribble pixels, and 0
%                 otherwise
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

disp('Computing preknown alpha values ... ...')

alpha_star=zeros(size(mask,1),size(mask,2));
alpha_star(mask>0)=1;
alpha_star(mask<0)=-1;