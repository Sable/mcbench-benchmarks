function xout = nonduplicate(xin)
% function xout = nonduplicate(xin)
% 
% written so that interp1 doesn't return error:
%		'The values of X should be distinct.'
% 
% checks for duplicate values in xin 
% returns xout where all values are distinct
% 
% if duplicates found, separates values by small value (eps)
% 
% input xin must be 1D
% 
% useage:
%	x = nonduplicate(x);
% 
%	yi = interp1(nonduplicate(x),y,xi)
% 
% Example:
% interp1([1,1,2],[1,1,2],1.5)
% returns an error.
% 
% interp1(nonduplicate([1,1,2]),[1,1,2],1.5)
% works just fine.
% 
% written by Nathan Tomlin, nathan.a.tomlin@gmail.com


xin = xin(:);

% sort 1st, but keep track of indices to "unsort" at end
[xout,isort] = sort(xin);

dx = diff(xout);	% dx=0 means 2 values are the same
idupl = find(dx==0);	% indices of duplicates
if ~isempty(idupl)	% duplicates in xin - need to fix
	% look at duplicates to find how many duplicates there are
	% for each duplicate value
		% example: if	xin =	[0,	0,	0,		0,		0]
		% then want		xout =	[0,	eps,2*eps,	3*eps,	4*eps]
		
	didupl = diff(idupl);	% 1s mean 3 or more of the same value
	k = 1; 	
	multeps(1) = 1;
	for m = 1:numel(didupl)
		if didupl(m) == 1	% 3 or more of the same value
			k = k+1;
		else				% only 2 of same value OR new duplicate value
			k = 1;
		end
		multeps(m+1) = k;	% multiplication factor to increase duplicate value
	end
	
	multeps = multeps(:);

	% increment duplicate values so they are distinct
	xout(idupl+1) = xout(idupl+1) + eps(xout(idupl+1)) .* multeps;
else	% no duplicates in xin - done
end


% "unsort"
xout = xout(isort);
