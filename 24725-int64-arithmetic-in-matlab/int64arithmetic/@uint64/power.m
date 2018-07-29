function p = power(a,b)
	if isscalar(a)
		a = a*ones(size(b),'uint64');
	elseif isscalar(b)
		b = a*ones(size(b),'uint64');
	end
	if ~isequal(size(a),size(b))
		error('Size mismatch');
	end
	
	p = ones(size(a),'uint64');
	for k = 1:length(a)
		if b(k)>63
			error('Power>63');
		end
		if a(k)==0 && b(k)==0
			error('0^0');
		end
		for pow = 1:double(b(k))
			p(k) = p(k)*a(k);
		end
	end
end