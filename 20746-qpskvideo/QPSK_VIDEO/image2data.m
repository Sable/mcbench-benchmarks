%--------------------------------------------------------------------------
%this function is to transfer image to data suitable for transmission
%
%Chen Zhifeng
%2007-05-19
%zhifeng@ecel.ufl.edu
%%I left this function as is since I'm clueless and a neophyte in image
%processing. JC 7/16/08
%--------------------------------------------------------------------------

function [data, row_im, col_im, third_im] = image2data(im, M)
% im = imread('photo.bmp');
% M =4;
[row_im, col_im, third_im] =size(im);
V_im = zeros(1, row_im*col_im*third_im);
for i=1:third_im,
    for j=1:col_im,
        V_im((i-1)*row_im*col_im+(j-1)*row_im +1 : (i-1)*row_im*col_im+j*row_im) = im(:,j,i);
    end
end

%I use dec2base here, then if M>8, for example M=16, the result string may
%include characters, this is not appropriate to use str2num below. However,
%due to the time limit, I will not add function here to deal with this.
%Actually, this may be done by dec2bin function.
Tm = dec2base(V_im,M);
[row, col] = size(Tm);
% data = [];
% for i = 1:col,
%     data = [data; Tm(:,i)];
% end
% 
%data=[];
for i =1:col,
    data(row*(i-1)+1:row*i)=str2num(Tm(:,i));   %very important to add str2num here
end
%Tm = str2num(Tm_char);

%data = str2num(data);



