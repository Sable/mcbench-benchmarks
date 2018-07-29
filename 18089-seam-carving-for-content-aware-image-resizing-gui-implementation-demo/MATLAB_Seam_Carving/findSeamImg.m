function SeamImg=findSeamImg(x)
% FINDSEAMIMG finds the seam map from which the optimal (vertical running) 
% seam can be calculated. Input is gradient image found from findEnergy.m.
%
% The indexing can be interpreted as in this example image:
%   [(i-1,j-1)  (i-1,j)  (i-1,j+1)]
%   [(i,j-1)    (i,j)    (i,j+1)  ]
%   [(i+1,j-1)  (i+1,j)  (i+1,j+1)]
%
% Author: Danny Luong
%         http://danluong.com
%
% Last updated: 12/20/07


[rows cols]=size(x);

SeamImg=zeros(rows,cols);
SeamImg(1,:)=x(1,:);

for i=2:rows
    for j=1:cols
        if j-1<1
            SeamImg(i,j)= x(i,j)+min([SeamImg(i-1,j),SeamImg(i-1,j+1)]);
        elseif j+1>cols
            SeamImg(i,j)= x(i,j)+min([SeamImg(i-1,j-1),SeamImg(i-1,j)]);
        else
            SeamImg(i,j)= x(i,j)+min([SeamImg(i-1,j-1),SeamImg(i-1,j),SeamImg(i-1,j+1)]);
        end
    end
end
