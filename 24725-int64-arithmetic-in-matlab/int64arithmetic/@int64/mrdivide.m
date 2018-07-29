function c = mrdivide(a,b)
	checkinputs(a,b);
	if numel(a)>1 && numel(b)>1
		error('Only elementwise division supported.');
	end
	c = int64rdivide(int64(a),int64(b));
end