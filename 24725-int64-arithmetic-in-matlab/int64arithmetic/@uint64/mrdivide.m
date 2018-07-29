function c = mrdivide(a,b)
	checkinputs(a,b);
	if numel(a)>1 && numel(b)>1
		error('Only elementwise division supported.');
	end
	c = uint64rdivide(uint64(a),uint64(b));
end