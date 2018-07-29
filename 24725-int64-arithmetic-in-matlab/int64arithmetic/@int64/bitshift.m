function c = bitshift(a,b)
	checkinputs(a,b);
	
	if numel(b)==1
		if b<0
			c = int64rightshift(int64(a),int64(-b));
		else
			c = int64leftshift(int64(a),int64(b));
		end
	else
		c = zeros(size(b),'int64');
		neg = b < 0;
		if numel(a)==1
			c(neg)  = int64rightshift(int64(a),int64(-b(neg)));
			c(~neg) = int64leftshift(int64(a),int64(b(~neg)));
		else
			c(neg)  = int64rightshift(int64(a(neg)),int64(-b(neg)));
			c(~neg) = int64leftshift(int64(a(~neg)),int64(b(~neg)));
		end
	end
end