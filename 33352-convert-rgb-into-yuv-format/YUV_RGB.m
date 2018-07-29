function [Y,U,V]=YUV_RGB(Im)
% This program transform RGB layers to YUV layers....
%  By  Mohammed Mustafa Siddeq
%  Date 25/7/2010
Im=double(Im);
R=Im(:,:,1); G=Im(:,:,2); B=Im(:,:,3);



% transfom layers to YUV
Y=round((R+2*G+B)/4);
U=R-G;
V=B-G;
end