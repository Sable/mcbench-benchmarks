function Cs = get_cons_inter(X,inter)
% define a matrix that encapsulates all of the rigidity constraints over
% the whole sequence. When multiplied by the vectorized Omegas, this gives
% a residual to be minimized
%
% © Copyright Phil Tresadern, University of Oxford, 2006

nframes	= size(X,3);
ncons		= size(inter,1);

% there are six degrees of freedom in the symmetric 3x3 matrix Omega
Cs 	= sparse(zeros(ncons*(nframes-1),6*nframes));

row	=	1;
for con = 1:size(inter,1);
	curr	= inter(con,:);

	% This method uses a single frame as a reference to which all
	% others are compared. In the method suggested by Liebowitz and Carlsson,
	% adjacent frames were compared but this allows the scale to drift over
	% the sequence.
	refcols	= 1:6;
	fref		= 0;
	
	for f = 1:nframes
		% if one of the joint locations involved is flagged as an outlier then
		% ignore it and go to next frame
		if ( isnan(X(1,curr(1),f)) || isnan(X(1,curr(2),f)) )
			refcols = refcols + 6;
			continue;
		end

		% compute bilinear product and store reference frame number
		Xa		= X(:,curr(1),f)-X(:,curr(2),f);
		p1		= kron(Xa,Xa);
		fref	= f;
		break;
	end

	% if every frame has at least one outlier then go to next constraint
	if (fref == 0)
		continue;
	end

	cols = 1:6;
	for f = 1:nframes
		% if there are outliers in this frame then ignore
		% also, do not compare reference frame with itself
		if ( isnan(X(1,curr(1),f)) || isnan(X(1,curr(2),f)) || (f == fref))
			cols = cols + 6;
			continue;
		end

		% compute bilinear product at this frame
		Xb	= X(:,curr(1),f)-X(:,curr(2),f);
		p2	= kron(Xb,Xb);

		% fill in appropriate rows and columns of constraint matrix
		Cs(row,refcols)	=  [p1(1) p1(2)+p1(4) p1(5) p1(3)+p1(7) p1(6)+p1(8) p1(9)];
		Cs(row,cols)		= -[p2(1) p2(2)+p2(4) p2(5) p2(3)+p2(7) p2(6)+p2(8) p2(9)];

		row			= row + 1;
		cols		= cols + 6;
	end
end

% remove any empty rows at bottom of constraint matrix
Cs = Cs(1:(row-1),:);
