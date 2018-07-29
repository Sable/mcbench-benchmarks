function c = rdivide(a,b)
	checkinputs(a,b);
	c = int64rdivide(int64(a),int64(b));
end