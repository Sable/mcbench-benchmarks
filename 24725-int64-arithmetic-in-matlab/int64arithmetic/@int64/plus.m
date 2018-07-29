function c = plus(a,b)
	checkinputs(a,b);
	c = int64plus(int64(a),int64(b));
end