function Xnew = reconstruct(L,poses)
% function Xnew = reconstruct(L,poses)
% 
% Compute joint positions Xnew given segment lengths L and intermediate
% joint positions and joint angles
% 
% This version (for the juggling figure) uses for loops and is therefore
% easier to understand
%
% © Copyright Phil Tresadern, University of Oxford, 2006

npoints	= 11;
nframes	= size(poses,2);
Xnew		= zeros(3,npoints,nframes);

for f = 1:nframes
	% copy positions of root, shoulders, head and juggling balls to Xnew
	Xtmp	= zeros(3,npoints);
	Xtmp(:,[1,2,5,8,9,10,11])	= reshape(poses(1:21,f),3,7);

	% 
	rows	= 22:25;
	for armindex = 1:2
		arm = (armindex*3);
		ang	= poses(rows,f); % angles for this limb
		
		Rsw	= xyz2rot(ang(1:3)); % shoulder
		Res	= xyz2rot([ang(4); 0; 0]); % elbow
		Rew	= Rsw * Res; % orientation of forearm
		
		Xtmp(:,arm) 	= Xtmp(:,arm-1) + (L((armindex*2)-1) * Rsw(:,2));
		Xtmp(:,arm+1) = Xtmp(:,arm) + (L((armindex*2)) * Rew(:,2));

		rows = rows + 4;
	end

	Xnew(:,:,f) = Xtmp;
end


function R = xyz2rot(xyz)
% this happens to be the conversion back to rotation matrix form

R = getRz(xyz(3))*getRy(xyz(2))*getRx(xyz(1));

