function s = sum(A)
	%Get first non-singleton dimension
	sz = size(A);
	d = find(size(A)~=1);
	if isempty(d)
		s = A;
		return
	end
	d=d(1);
	
	idx = cell(1,ndims(A));
	for k = 1:ndims(A)
		idx{k} = ':';
	end
	
	ssz = sz;
	ssz(d) = 1;
	s = zeros(ssz);
	for k = 1:size(A,d)
		idx{d} = k;
		s = s + A(idx{:});
	end
end