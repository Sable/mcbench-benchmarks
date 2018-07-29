function c = mod(a,b)
	checkinputs(a,b);
	if numel(b)>1
		ind = b~=0;
		c = int64mod(int64(a(ind)),int64(b(ind)));
		c(~ind) = a(~ind);
	else
		if b == 0
			c = a;
		else
			c = int64mod(a,b);
		end
	end
end