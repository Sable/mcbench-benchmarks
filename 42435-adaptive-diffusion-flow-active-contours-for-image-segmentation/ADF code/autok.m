function K=autoK(I)
% 自动估计梯度阈值K函数
% 用robust_statistic自动估计梯度阈值
%Rerf. 
%M. J. Black, G. Sapiro, D. H. Marimont and D. Hegger,“Robust Anisotropic Diffusion,” IEEE Trans. Image
%Processing, vol. 7, no. 3, pp. 421–432, Mar. 1998.

% I:input gray or color image

[row,col,nchannel]=size(I);

K=0;
if nchannel==1%gray image
      [gradx,grady]=gradient(I);
%[gradx,grady]=grad2BySobel(I);
    
    gradI=(gradx.^2+grady.^2).^0.5;
    K=1.4826*mean(mean(abs(gradI-mean(mean(gradI)))));
else%color image
    for i=1:3
        [gradx,grady]=gradient(I(:,:,i));
        gradI=(gradx.^2+grady.^2).^0.5;
        K=K+1.4826*mean(mean(abs(gradI-mean(mean(gradI)))));
    end
    K=K/3;
end