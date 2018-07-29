function f = FK(DH,w,symbolic,from,to)
% FK Forward Kinematics of Robot Manipulator
% 
% f = FK(DH,w,symbolic,from,to)
% Input:
% 
% DH       -> n by 4 matrix containing all DH parameters in form of numbers
%             The column are respectively [alpha, a, d, t].
% 
% w        -> n by 1 matrix containing strings indicating whether link is
%             revolute of prismatic ('r' or 'p').
% 
% symbolic -> 1: produce result symbolically
%             0: produce numerical result
% 
% from     -> frame required
% 
% to       -> frame the required frame is taken with respect to
% 
% Example:
%
%  DH = [0,0,2,0; 0,2,2,pi/2; pi,0,0,0];
%  w = ['p';'r';'p'];
%  FK(DH,w,1,3,1)           % gives T_3_1 symbolically
% 
%  FK(DH,w,0,3,0)           % gives T_3_0 numerically
% 
%  FK(DH,w,0,2,3)           % gives T_2_3 numerically
% 

	% get parameters
	alpha = DH(:,1);
	a = DH(:,2);
	d = DH(:,3);
	t = DH(:,4);
	n = length(a);

	% if we want a symbolic output
	if symbolic == 1

		d = sym(d);
		t = sym(t);

		% put t's and d's in the vectors
		for k = 1:n
			if strcmp(w(k),'r')
				t(k) = sym(['t',num2str(k)]);
			else
				d(k) = sym(['d',num2str(k)]);
			end
		end

	end

	% obtain all T matrices
	TT = cell(n,1);
	for k = 1:n
		TT{k} = trans(alpha(k),a(k),d(k),t(k));
	end

	% multiply T matrices in succession.
	% For example for T_3_0 we take multiply from T(1) to T(3), and for T_5_2 we
	% multiply from T(3) to T(5)
	f = eye(4);
	if from > to

		for k = to+1:from
			f = f*TT{k};
		end
		
	elseif to > from
		
		for k = from+1:to
			f = f*TT{k};
		end
		f = inv(f);

	end

% 	% remove round-off error
	for k = 1:numel(f)
% 		f(k) = dre(vpa(f(k),5));
	end
	
	function T=trans(al,a,d,t)

		T=[cos(t) -sin(t) 0 a;
			sin(t)*cos(al) cos(t)*cos(al) -sin(al) -sin(al)*d;
			sin(t)*sin(al) cos(t)*sin(al) cos(al) cos(al)*d;
			0 0 0 1];

	end

end