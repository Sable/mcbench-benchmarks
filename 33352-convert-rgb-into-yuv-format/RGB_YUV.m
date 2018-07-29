function Im=RGB_YUV(Y,U,V)
% This program transform YUV layers to RGB Layers in ome matrix 'Im'....
%  By   Mohammed Mustafa Siddeq
%  Date 25/7/2010

G=round((Y-(U+V)/4));
R=U+G;
B=V+G;
Im(:,:,1)=R; Im(:,:,2)=G; Im(:,:,3)=B; 
%imshow(uint8(Im));
end