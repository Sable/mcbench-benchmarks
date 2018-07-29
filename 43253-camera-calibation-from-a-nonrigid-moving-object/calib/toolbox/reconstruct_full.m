function Xnew = reconstruct_full(L,poses)
% function Xnew = reconstruct_full(L,poses)
% 
% Compute joint positions Xnew given segment lengths L and intermediate
% joint positions and joint angles
% 
% I must confess I wrote this a long time ago and no longer understand a
% word of it. I assume I wrote it in such an obscure way because it was
% faster than using 'for' loops. Sadly, that means it's almost impossible to
% understand :( At some point, I'll patch it up but for now we're stuck
% with it the way it is.
%
% © Copyright Phil Tresadern, University of Oxford, 2006

npoints	= 14;
nframes	= size(poses,2);

% get locations of root, shoulders and head
locs		= reshape(poses(1:12,:),3,4,nframes);

% copy them to 3D structure matrix
Xnew		= zeros(3,npoints,nframes);
Xnew(:,[1,2,5,14],:) = locs;

% cosine of angle made by root-LHip and root-RHip segments assuming pelvis
% is rigid
cr 	= (L(10)^2 + L(11)^2 - L(1)^2) / (2*L(10)*L(11));
% corresponding sine of angle
sr	= sqrt(1-cr^2);

% cosines of joint angles
cposes	= [	cos(poses(13:15,:));	% pelvis orientation
						cr*ones(1,nframes);		% pelvis 'shape'
						cos(poses(16:31,:))]; % remaining joints

% corresponding sines
sposes	= [	sin(poses(13:15,:));
						sr*ones(1,nframes);
						sin(poses(16:31,:))];

% reshape to reflect the 4 parameters for each of 5 limbs					
c	= reshape(cposes,[4,5,nframes]); 
s	= reshape(sposes,[4,5,nframes]);

% precompute pairwise sine-sine products
s2s1	= s(2,:,:).*s(1,:,:);

% compute a set of orientation vectors for upper limbs
Vu	= [	c(3,:,:).*s2s1-s(3,:,:).*c(1,:,:);
				s(3,:,:).*s2s1+c(3,:,:).*c(1,:,:); 	
				c(2,:,:).*s(1,:,:)];

% precompute pairwise sine-cosine products
s2c1	= s(2,:,:).*c(1,:,:);

tmp	= [	c(3,:,:).*s2c1+s(3,:,:).*s(1,:,:);
				s(3,:,:).*s2c1-c(3,:,:).*s(1,:,:);
				c(2,:,:).*c(1,:,:)];

Vl	= c(4*ones(3,1),:,:).*Vu + ...
			s(4*ones(3,1),:,:).*tmp;	

% define positions of hip joints
Xnew(:,8,:) 	= Xnew(:,1,:) + (L(10)*Vu(:,1,:));
Xnew(:,11,:)	= Xnew(:,1,:) + (L(11)*Vl(:,1,:));

% compute positions of 8 distal joints, 2 for each of the four limbs
li		= 1:4;
joint	= (li*3)-1;

Lu		= L(li*2);
Ll		= L((li*2)+1);

Vu(:,2,:)	= Lu(1)*Vu(:,2,:);
Vu(:,3,:)	= Lu(2)*Vu(:,3,:);
Vu(:,4,:)	= Lu(3)*Vu(:,4,:);
Vu(:,5,:)	= Lu(4)*Vu(:,5,:);

Vl(:,2,:)	= Ll(1)*Vl(:,2,:);
Vl(:,3,:)	= Ll(2)*Vl(:,3,:);
Vl(:,4,:)	= Ll(3)*Vl(:,4,:);
Vl(:,5,:)	= Ll(4)*Vl(:,5,:);

Xnew(:,joint+1,:) = Xnew(:,joint,:) 	+ Vu(:,li+1,:);
Xnew(:,joint+2,:) = Xnew(:,joint+1,:) + Vl(:,li+1,:);
