function [pc, eiv] = app_pca(data, var)
% [pc] = app_pca(data, [var])
% [pc eiv] = app_pca(data, [var])
%
% Principal Component Analysis for appearance data (ie. highly rank-deficient
% covariance matrix).
% 
%                         PARAMETERS
%
% data A matrix containing the data to analyze, with observations on columns. It is assumed that
%      the size of the observations is much greater than the number of samples.
%
% var (Optional) A percentage value (0 to 1) indicating the amount of eigenvalue 
%     variation that should be covered by the returned principal components.
%     If not provided, all principal components are returned.
%
%                        RETURN VALUES
%
% pc The principal components
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

	N = size(data, 2);
	m = mean(data, 2);

	% Subtract mean from columns
	if matlab_version_at_least(7, 4)
		data = bsxfun(@minus, data, m);
  else
	  for i=1:N
	  	data(:,i) = data(:,i) - m;
	 	end 
 	end
    
    % Covariance matrix
	C = (data' * data) / N;

	[pc_, eiv_] = pcacov(C);

  % Normalize eigenvalues to sum at 1
	neiv = eiv_ ./ sum(eiv_);

	% Count number of eigenvalue needed to cover desired variation
	covered = 0;
	i = 1;
	
  while covered < var
      covered = covered + neiv(i);
      i = i + 1;
  end

  % Obtain principal components of data * data' from
  % principal components of data' * data
  % (only select i-1 columns, as there are i-1 relevant eigenvalues)
  pc = data * pc_(:,1:i-1);
  
  % Normalize columns
  if matlab_version_at_least(7, 4)
  	pc = bsxfun(@rdivide, pc, sqrt(sum(pc.^2, 1)));
  else
  	for j=1:size(pc,2)
		 	pc(:,j) = pc(:,j) / norm(pc(:,j));
		end
	end
    
	if nargout > 1
		eiv = eiv_(1:i-1);
	end
