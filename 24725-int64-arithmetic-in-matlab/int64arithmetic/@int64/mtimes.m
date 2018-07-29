function c = mtimes(a,b)

	if numel(a)>1 && numel(b)>1
		%error('Only elementwise multiplication supported.');
		c = int64matmul(int64(a),int64(b));
	else
		checkinputs(a,b);
		c = int64times(int64(a),int64(b));
	end
	
end