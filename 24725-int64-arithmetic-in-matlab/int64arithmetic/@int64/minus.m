function c = minus(a,b)
	checkinputs(a,b);
	c = int64minus(int64(a),int64(b));
end