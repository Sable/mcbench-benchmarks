function [copy] = shape (array, rows, cols)
% ARRAY push image into shape

if (rows*cols ~= length(array))
   error ('#AVI Error: the rows * cols must be equal to elements');
end

elements = 1;
for r=rows:-1:1
	for c=1:cols
   	copy(r,c) = array(elements);
      elements = elements + 1;
	end
end

         