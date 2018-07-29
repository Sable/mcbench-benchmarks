function poses = compute_poses(X,inter)
% convert joint locations to joint angles of an articulated skeleton
%
% © Copyright Phil Tresadern, University of Oxford, 2006

switch size(X,2)
	case 14, % full body
		poses = compute_poses_full(X,inter);
		
	case 11, % juggling figure
		poses = compute_poses_juggling(X,inter);
		
	otherwise, % dunno
		error('Unknown body configuration');
end
