function [pc, eiv] = var_pca(data, var)
% [pc] = var_pca(data, [var])
% [pc eiv] = var_pca(data, [var])
%
% Principal Component Analysis.
% 
%                         PARAMETERS
%
% data A matrix containing the data to analyze, with observations on columns
%
% var (Optional) A percentage value (0 to 1) indicating the amount of eigenvalue 
%     variation that should be covered by the returned principal components.
%     If not provided, all principal components are returned.
%
%                        RETURN VALUES
%
% pc	The principal components
%
% eiv (Optional) Column vector of eigenvalues (one for each principal 
%      component), in decreasing order
%
% Author: Luca Vezzaro (elvezzaro@gmail.com)

	if nargin == 1
		var = 1;
	end
	
	if var < 0 || var > 1
		error('var_pca: variation must be between 0 and 1');
	end
	
	[pc, score, eiv_] = princomp(data', 'econ');
	
	% Normalize eigenvalues to sum at 1
	neiv = eiv_ ./ sum(eiv_);
		
	% Count number of eigenvalue needed to cover desired variation
	covered = 0;
	i = 1;
	while covered < var
		covered = covered + neiv(i);
		i = i + 1;
	end
	
	pc = pc(:,1:i-1);
	
	if nargout > 1
		eiv = eiv_(1:i-1);
	end