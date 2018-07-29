function checkinputs(a,b)
	if numel(a)>1 && numel(b)>1
		if length(size(a)) ~= length(size(b))
			error('Arrays have different number of dimensions');
		end
		
		if ~all(size(a) == size(b))
			error('Arrays are not the same size');
		end
	end
end