function p = mpower(a,b)
	if isscalar(a) && isscalar(b)
		p = a.^b;
	else 
		error('Int64 matrix powers not supported');
	end
end