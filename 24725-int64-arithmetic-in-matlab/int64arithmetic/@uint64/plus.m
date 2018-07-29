function c = plus(a,b)
	checkinputs(a,b);
	c = uint64plus(uint64(a),uint64(b));
end