function lengths = get_lengths(X,inter)
% Compute lengths of all links specified as being rigid over time. These
% links are specified by the rows of 'inter' and the 3D point positions in
% X
%
% © Copyright Phil Tresadern, University of Oxford, 2006

nframes = size(X,3);
npoints	= size(X,2);

lengths	= zeros(nframes,size(inter,1));
for f = 1:nframes
	for con = 1:size(inter,1)
		diff = X(:,inter(con,1),f)-X(:,inter(con,2),f);
		lengths(f,con) = norm(diff);
	end
end
