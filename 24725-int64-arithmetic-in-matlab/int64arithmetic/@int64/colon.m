%Works reasonably well since double represents integers <= about 2^50 exactly
function I = colon(a,b,c)
	if nargin == 2
		I  = double(a):double(b);
	else
		I = double(a):double(b):double(c);
	end
	I = int64(I);
end