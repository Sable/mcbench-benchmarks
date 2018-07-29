function c = mtimes(a,b)
	checkinputs(a,b);
	if numel(a)>1 && numel(b)>1
		error('Only elementwise multiplication supported.');
	end
	c = uint64times(uint64(a),uint64(b));
end