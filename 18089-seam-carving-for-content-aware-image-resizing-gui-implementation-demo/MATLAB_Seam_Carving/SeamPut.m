function x=SeamPut(x,SeamVector)
% SEAMPUT takes as input a RGB or grayscale image and SeamVector array to
% find the pixels contained in the seam, and to adds a seam of interpolated
% pixels to the image. Each column of SeamVector must be a single seam.
%
% Author: Danny Luong
%         http://danluong.com
%
% Last updated: 12/20/07


[rows cols dim]=size(x);
[SVrows SVcols SVdim]=size(SeamVector);

if rows~=SVrows
    error('SeamVector and image dimension mismatch');
end

for k=1:SVcols
    for i=1:dim
        for j=1:rows
            if SeamVector(j,k)==1
                PutImg(j,:,i)=[x(j,1,i) x(j,1:cols,i)];
            elseif SeamVector(j,k)==cols
                PutImg(j,:,i)=[x(j,1:cols,i) x(j,cols,i)];
            else
                PutImg(j,:,i)=[x(j,1:SeamVector(j,k),i) 1/2*(x(j,SeamVector(j,k),i)+x(j,SeamVector(j,k)+1,i)) x(j,SeamVector(j,k)+1:cols,i)];
            end
        end
    end
    x=PutImg;
    clear PutImg
    [rows cols dim]=size(x);
end