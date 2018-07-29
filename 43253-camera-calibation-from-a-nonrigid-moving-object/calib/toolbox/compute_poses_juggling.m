function poses = compute_poses_juggling(X,inter)
% compute joint centres and joint angles for the upper body model with
% juggling balls
%
% © Copyright Phil Tresadern, University of Oxford, 2006

nframes		= size(X,3);

locations	= zeros(21,nframes);
% 1..3 :		root
% 4..9 :		left/right shoulders
% 10..12 : 	head
% 13..21 :  juggling balls

poses	= zeros(8,nframes);
% 1..4 :		left shoulder, left elbow
% 5..8 :		right shoulder, right elbow


for f = 1:nframes
	temp	= X(:,[1,2,5,8,9,10,11],f);
	locations(:,f) = temp(:);

	% arms
	rows = 1:4;
	for arm = [1,3]
		% get vectors for two proximal and distal segments
		humerus = X(:,inter(arm,2),f) - X(:,inter(arm,1),f);
		radius	= X(:,inter(arm+1,2),f) - X(:,inter(arm+1,1),f);

		y	= humerus / norm(humerus); % parallel to humerus
		x	= cross(humerus,radius); % normal to plane formed by two segments
		x	= x / norm(x);
		z	= cross(x,y); % mutually orthogonal vector forms rotation matrix
		Rsw	= [x y z]; % orientation of shoulder with respect to world

		y	= radius / norm(radius); % parallel to radius
		z = cross(x,y); % mutually orthogonal vector forms rotation matrix
		Rew	= [x y z];
		
		% rotation matrix of elbow with respect to shoulder
		Res	= Rsw' * Rew;

		% get angles from rotation matrices
		xyz1	= rot2xyz(Rsw);
		xyz2	= rot2xyz(Res);
		
		% since x is common to both Rsw and Rew, we know the rotation is about
		% X only for Res
		poses(rows,f) = [xyz1'; xyz2(1)];
		
		% next limb
		rows = rows + 4;
	end
end

poses	= [locations; poses];
