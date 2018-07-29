function x=SeamCut(x,SeamVector)
% SEAMCUT takes as input a RGB or grayscale image and SeamVector array to
% find the pixels contained in the seam, and to remove them from the image.
% Each col of SeamVector must be a single seam.
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

for k=1:SVcols              %goes through set of seams
    for i=1:dim             %if rgb, goes through each channel
        for j=1:rows        %goes through each row in image
            if SeamVector(j,k)==1
                CutImg(j,:,i)=[x(j,2:cols,i)];
            elseif SeamVector(j,k)==cols
                CutImg(j,:,i)=[x(j,1:cols-1,i)];
            else
                CutImg(j,:,i)=[x(j,1:SeamVector(j,k)-1,i) x(j,SeamVector(j,k)+1:cols,i)];
            end
        end
    end
    x=CutImg;
    clear CutImg
    [rows cols dim]=size(x);
end

% for i=1:dim
%     for j=1:rows
%         if SeamVector(j)==1
%             CutImg(j,:,i)=[x(j,SeamVector(j)+1:end,i)];
%         elseif SeamVector(j)==cols
%             CutImg(j,:,i)=[x(j,1:SeamVector(j)-1,i)];
%         else
%             CutImg(j,:,i)=[x(j,1:SeamVector(j)-1,i) x(j,SeamVector(j)+1:end,i)];
%         end
%     end
% end
