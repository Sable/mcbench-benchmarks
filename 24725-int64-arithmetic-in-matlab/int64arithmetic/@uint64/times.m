function c = times(a,b)
	checkinputs(a,b);
	c = uint64times(uint64(a),uint64(b));
end
