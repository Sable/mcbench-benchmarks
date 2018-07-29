function [ pyr ] = genPyr( img, type, level )
%[ pyr ] = genPyr( img, type, level )
%	generate Gaussian or Laplacian pyramid
%   PYR = GENPYR(A,TYPE,LEVEL) A is the input image, 
%	can be gray or rgb, will be forced to double. 
%	TYPE can be 'gauss' or 'laplace'.
%	PYR is a 1*LEVEL cell array.

pyr = cell(1,level);
pyr{1} = im2double(img);
for p = 2:level
	pyr{p} = pyr_reduce(pyr{p-1});
end
if strcmp(type,'gauss'), return; end

for p = level-1:-1:1 % adjust the image size
	osz = size(pyr{p+1})*2-1;
	pyr{p} = pyr{p}(1:osz(1),1:osz(2),:);
end

for p = 1:level-1
	pyr{p} = pyr{p}-pyr_expand(pyr{p+1});
end

end