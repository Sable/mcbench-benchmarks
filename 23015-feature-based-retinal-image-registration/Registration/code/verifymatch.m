function [P1, P2, mytform]= verifymatch(linktable1, linktable2, P1, P2, P2idx, bw1, bw2, NumPair);

% This funciton verify the correspondence and find the best matched pair

if (nargin == 7)
   NumPair = 1; 
end

[M1, N1]= size(bw1);
[M2, N2]= size(bw2);
npix = size(P1,1);
for k=1:npix;
    base_points  = points_transform(linktable1(P1(k),:), [M1, N1]); 
    input_points = points_transform(linktable2(P2(k),:), [M2, N2], P2idx(k));
    tmptform = cp2tform(input_points, base_points, 'affine');  
    tformmat(k,:) = tmptform.tdata.T(:)';
end

errmat = realmax*ones(npix, npix);
Weight = [1, 1, 1, 1, 1, 1, 1, 1, 1];
for i=1: npix
    vec1= tformmat(i,:);
    for j = i+1 :npix
      vec2 = tformmat(j,:);
      err = (vec2-vec1).*Weight;
      errmat(i, j)= mean(err.^2);
    end
end

[errmat, idx]= sort(errmat(:));
seeds = idx(1:NumPair);
posi = mod(seeds, npix);
posi(find(posi==0))= npix; 
posj = 1+(seeds-posi)/npix;
oldpos = [posi;posj];

% -------------------------------------------------------------------------
%delete the duplicate element
idx = 0;
pos = [];
for k=1:size(oldpos,1)
    if ( prod(size(find(oldpos == oldpos(k)))) > 1) & (find(pos == oldpos(k)))
     ;
    else
        idx = idx + 1;
        pos(idx)= oldpos(k);
    end
end

% -------------------------------------------------------------------------
P1 = P1(pos);
P2 = P2(pos);
P2idx = P2idx(pos);
base_points = [];
input_points = [];
for k=1:size(P1,1)
    points1 = points_transform(linktable1(P1(k),:), [M1, N1]);
    points2 = points_transform(linktable2(P2(k),:), [M2, N2], P2idx(k));
    base_points = [base_points; points1];
    input_points = [input_points; points2];
end
%C = verifygraph(base_points, input_points)

mytform = cp2tform(input_points,base_points,'affine');