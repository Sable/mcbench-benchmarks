function [pos,value]=immaxpos(img) 
  % IMMAXPOS finds the position with max. value in the 2-D image
  % Define position of the max. "value" in the image
  %
  % author: B. Schauerte
  % date:   2009-2011
  
  assert(~isempty(img));
  assert(ndims(img) == 2);
  %assert(size(img,3) == 1);

  [val, idx] = max(img(:));
  value = val(end);
  [a b]=ind2sub(size(img),idx(end)); pos=[b a]; % secure
  %pos=[ceil(idx(end) / size(img,1)) mod(idx(end), size(img,1))]; % fast
end