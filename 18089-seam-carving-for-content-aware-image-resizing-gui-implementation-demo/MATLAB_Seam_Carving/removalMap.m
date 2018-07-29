function SeamVector=removalMap(X,lines);
% REMOVALMAP takes a given image and finds the ordered set of (vertical)
% seams that are removed from an image and returns them in an array, where
% the Nth column in the array corresponds to the Nth seam to be removed.
%
% Author: Danny Luong
%         http://danluong.com
%
% Last updated: 12/20/07


[rows cols dim]=size(X);

E=findEnergy(X);    %Finds the gradient image

for i=1:min(lines,cols-1)

    %find "energy map" image used for seam calculation given the gradient image
    S=findSeamImg(E);

    %find seam vector given input "energy map" seam calculation image
    SeamVector(:,i)=findSeam(S);

    %remove seam from image
    X=SeamCut(X,SeamVector(:,i));
    E=SeamCut(E,SeamVector(:,i));

    %updates size of image
    [rows cols dim]=size(X);
end
