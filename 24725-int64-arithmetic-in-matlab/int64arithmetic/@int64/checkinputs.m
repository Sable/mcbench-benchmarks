function checkinputs(a,b)
	if numel(a)>1 && numel(b)>1
		if ~isequal(size(a),size(b))
			error('Arrays are not the same size');
		end
	end
end