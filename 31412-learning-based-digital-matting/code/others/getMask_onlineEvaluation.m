function mask=getMask_onlineEvaluation(fn_sb)
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
I=imread(fn_sb);
mask=zeros(size(I,1),size(I,2));
fore=(I==255);
back=(I==0);

mask(fore)=1;
mask(back)=-1;