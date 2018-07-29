function poses = getposes(X,inter)
% compute joint centres and joint angles for the full body model
%
% © Copyright Phil Tresadern, University of Oxford, 2006

nframes		= size(X,3);

locations	= zeros(12,nframes);
% 1..3 :		root
% 4..9 :		left/right shoulders
% 10..12 : 	head

poses	= zeros(19,nframes);
% 1..3 :		orientation of root
% 4..7 :		left shoulder, left elbow
% 8..11 :		right shoulder, right elbow
% 12..15 :	left hip, left knee
% 16..19 :	right hip, right knee

for f = 1:nframes
	% locations of root, shoulders and head
	% shoulders are defined in this way since they are not attached to the
	% root via a piecewise rigid kinematic chain (unless you want to try to
	% model the spine)
	temp	= X(:,[1 2 5 14],f);
	locations(:,f) = temp(:);

	% hips
	rows	= 1:3;

	hip1 = X(:,8,f) - X(:,1,f); % root-LHip
	hip2 = X(:,11,f) - X(:,1,f); % root-RHip
	
	% define rotation matrix from hip links
	y = hip1 / norm(hip1);
	x	= cross(hip1,hip2);
	x = x / norm(x);
	z = cross(x,y);
	Rrw	= [x y z];
	poses(rows,f) = rot2xyz(Rrw)';

	limb	= 2; % index of first segment origin (i.e. left shoulder)
	rows	= 4:7; % corresponding rows of pose matrix
	
	for limbindex = 1:4
		% get vectors for upper and lower limbs
		upper = X(:,inter(limb,2),f) - X(:,inter(limb,1),f);
		limb		= limb + 1;
		lower	= X(:,inter(limb,2),f) - X(:,inter(limb,1),f);
		limb		= limb + 1;

		% orientation of ball and socket joint with respect to world is 
		%	defined by the plane formed by the upper and lower limbs
		y	= upper / norm(upper);
		x	= cross(upper,lower);
		x	= x / norm(x);
		z	= cross(x,y);
		Ruw	= [x y z];

		% orientation of lower limb with respect to world is defined by the
		% direction of the lower limb and the plane containing both upper and
		% lower limbs
		y	= lower / norm(lower);
		z = cross(x,y);
		Rlw	= [x y z];

		% compute relative rotation between upper and lower limbs at hinge
		Rlu	= Ruw' * Rlw;

		xyz1	= rot2xyz(Ruw);
		xyz2	= rot2xyz(Rlu);

		% since hinge rotation is defined about x-axis, we only need 
		% this value
		poses(rows,f) = [xyz1'; xyz2(1)];

		% next limb
		rows = rows + 4;
	end
end

poses	= [locations; poses];
