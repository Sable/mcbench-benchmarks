function c = bitshift(a,b)
	checkinputs(a,b);
	
	if numel(b)==1
		if b<0
			c = uint64rightshift(uint64(a),uint64(-b));
		else
			c = uint64leftshift(uint64(a),uint64(b));
		end
	else
		c = zeros(size(b),'uint64');
		neg = b < 0;
		if numel(a)==1
			c(neg)  = uint64rightshift(uint64(a),uint64(-b(neg)));
			c(~neg) = uint64leftshift(uint64(a),uint64(b(~neg)));
		else
			c(neg)  = uint64rightshift(uint64(a(neg)),uint64(-b(neg)));
			c(~neg) = uint64leftshift(uint64(a(~neg)),uint64(b(~neg)));
		end
	end
end