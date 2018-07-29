% GCD    Greatest common divisor.
% G = GCD(A,B) is the greatest common divisor of A and B
function g = gcd(a,b)
	if isscalar(a)
		a = a*ones(size(b),'int64');
	elseif isscalar(b)
		b = a*ones(size(b),'int64');
	end
	if ~isequal(size(a),size(b))
		error('Size mismatch');
	end
	
	g = zeros(size(a),'int64');
	for k = 1:length(a)
		g(k) = a(k);
		while b(k) ~= 0
		   t    = b(k);
		   b(k) = mod(g(k),b(k));
		   g(k) = t;
		end
	end
end