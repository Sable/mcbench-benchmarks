function c = minus(a,b)
	checkinputs(a,b);
	c = uint64minus(uint64(a),uint64(b));
end