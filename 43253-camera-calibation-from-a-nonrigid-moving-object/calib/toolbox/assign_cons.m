function [intra,inter] = assigncons(W)
% define constraints between segments within a single frame (i.e. symmetry)
% and over time (i.e. rigidity)
% 
% intra encodes N constraints in N rows of the form [a b c d]
% that specifies |a-b|^2 = |c-d|^2
% 
% inter encodes N2 constraints in N2 rows of the form [a b]
% that specifies |a(t)-b(t)|^2 = |a(t-1)-b(t-1)|^2
%
% © Copyright Phil Tresadern, University of Oxford, 2006

switch size(W,2)
	case 14, % full body
		% points are:
		% 1: root							 8: left hip
		% 2: left shoulder		 9: left knee
		% 3: left elbow				10: left ankle
		% 4: left wrist				11: right hip
		% 5: right shoulder		12: right knee
		% 6: right elbow			13: right ankle
		% 7: right wrist			14: head
				
		intra =	[	2		3		5		6; % upper arms
							3		4		6		7; % lower arms
							8		9		11	12; % upper legs
							9		10	12	13]; % lower legs
		inter =	[	8		11; % LHip-RHip
							2		3; % upper left arm
							3		4; % lower left arm
							5		6; % upper right arm
							6		7; % lower right arm
							8		9; % upper left leg
							9		10; % lower left leg
							11	12; % upper right leg
							12	13]; % lower right leg
						
	case 11, % juggling
		% points are:
		% 1: root							 8: head
		% 2: left shoulder		 9: juggling ball 1
		% 3: left elbow				10: juggling ball 2
		% 4: left wrist				11: juggling ball 3
		% 5: right shoulder
		% 6: right elbow
		% 7: right wrist
		
		intra =	[	2		3		5		6; % upper arms
							3		4		6		7 ]; % lower arms
		inter =	[	2		3; % upper left arm
							3		4; % lower left arm
							5		6; % upper right arm
							6		7 ]; % lower right arm
		
	otherwise, % dunno
		error('Unknown body model');
end					
						