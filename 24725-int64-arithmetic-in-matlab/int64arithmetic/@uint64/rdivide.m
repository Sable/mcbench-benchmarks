function c = rdivide(a,b)
	checkinputs(a,b);
	c = uint64rdivide(uint64(a),uint64(b));
end