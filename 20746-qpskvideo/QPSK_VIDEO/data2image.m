%--------------------------------------------------------------------------
%this function is to transfer data type back to image for display
%
%Chen Zhifeng
%2007-05-19
%zhifeng@ecel.ufl.edu
%I left this function as is since I'm clueless and a neophyte in image
%processing. JC 7/16/08
%--------------------------------------------------------------------------

function im = data2image(Data, row_im, col_im, third_im, M);%changed data to Data
% M =4;
data = Data';%changed data' to Data'
l = length(data);
col =ceil( 8/log2(M) ); %in case M = 8, 32, 64, 128, we need ceil
row= l/col;
Tm = zeros(row,col);
for i = 1:col,
    Tm(:,i) = num2str(data((i-1)*row+1 : i*row));
end
%temp = char(Tm);
%Tmn = num2str(temp);

V_im = base2dec(Tm,M);
im = zeros(row_im, col_im, third_im);
for i=1:third_im,
    for j=1:col_im,
        im(:,j,i) = V_im((i-1)*row_im*col_im+(j-1)*row_im +1 : (i-1)*row_im*col_im+j*row_im);
    end
end
