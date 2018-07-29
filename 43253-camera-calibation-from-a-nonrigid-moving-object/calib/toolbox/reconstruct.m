function Xnew = reconstruct(L,poses)
% function Xnew = reconstruct(L,poses)
%
% © Copyright Phil Tresadern, University of Oxford, 2006

switch size(L,2)
	case 11, % full body
		Xnew = reconstruct_full(L,poses);
		
	case 4, % juggling figure
		Xnew = reconstruct_juggling(L,poses);
		
	otherwise, % dunno
		error('Unknown body configuration');
end
