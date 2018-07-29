function [beta,r,J,Sigma,mse,errorparam,robustw] = nlinmultifit(x_cell, y_cell, mdl_cell, beta0, options)
%NLINMULTIFIT Nonlinear least-squares regression of multiple data sets
%
%	A wrapper function for NLINFIT which allows simulatenous fitting of
%	multiple data sets with shared fitting parameters. See example below.
%
%	Unlike different solutions (using fminsearch or similar functions)
%	this approach enables simple estimation of model predictions and
%	their confidence intervals, as well as confidence intervals on the
%	fitted parameters (using the built-in NLPREDCI and NLPARCI functions).
%
%	KNOWN ISSUE:
%		In this implementation, different data sets are weighted according
%		to their relative lengths. Special care should be taken when those
%		lengths are considerably different from one another to avoid
%		biased results towards one data set in particular.
%
%	INPUT:
% 		x_cell,y_cell: Cell arrays containing the x,y vectors of the fitted
%					   data sets.
% 		mdl_cell: Cell array containing model functions for each data set.
% 		beta0: Vector containing initial guess of the fitted parameters.
% 		options: Structure containing control parameters for NLINFIT (see
%				 help file on NLINFIT for more details).
%
%	OUTPUT:
%		beta,r,J,Sigma,mse,errorparam,robustw: Direct output from NLINFIT.
%
%	EXAMPLE:
% 		% Generate X vectors for both data sets
% 		x1 = 0:0.1:10;
% 		x2 = 0:0.2:10;
% 
% 		% Generate Y data with some noise
% 		y1 = cos(2*pi*0.5*x1).*exp(-x1/5) + 0.1*randn(size(x1));
% 		y2 = 0.5 + 2*exp(-(x2/5)) + 0.1*randn(size(x2));
% 
% 		% Define fitting functions and parameters, with identical
%		% exponential decay for both data sets
% 		mdl1 = @(beta,x) cos(2*pi*beta(1)*x).*exp(-x/beta(2));
% 		mdl2 = @(beta,x) beta(4) + beta(3)*exp(-(x/beta(2)));
% 
% 		% Prepare input for NLINMULTIFIT and perform fitting
% 		x_cell = {x1, x2};
% 		y_cell = {y1, y2};
% 		mdl_cell = {mdl1, mdl2};
% 		beta0 = [1, 1, 1, 1];
% 		[beta,r,J,Sigma,mse,errorparam,robustw] = ...
%					nlinmultifit(x_cell, y_cell, mdl_cell, beta0);
% 
% 		% Calculate model predictions and confidence intervals
% 		[ypred1,delta1] = nlpredci(mdl1,x1,beta,r,'covar',Sigma);
% 		[ypred2,delta2] = nlpredci(mdl2,x2,beta,r,'covar',Sigma);
% 
% 		% Calculate parameter confidence intervals
% 		ci = nlparci(beta,r,'Jacobian',J);
% 
% 		% Plot results
% 		figure;
% 		hold all;
% 		box on;
% 		scatter(x1,y1);
% 		scatter(x2,y2);
% 		plot(x1,ypred1,'Color','blue');
% 		plot(x1,ypred1+delta1','Color','blue','LineStyle',':');
% 		plot(x1,ypred1-delta1','Color','blue','LineStyle',':');
% 		plot(x2,ypred2,'Color',[0 0.5 0]);
% 		plot(x2,ypred2+delta2','Color',[0 0.5 0],'LineStyle',':');
% 		plot(x2,ypred2-delta2','Color',[0 0.5 0],'LineStyle',':');
%
%	AUTHOR:
%		Chen Avinadav
%		mygiga (at) gmail
%

	num_curves = length(x_cell);
	if length(y_cell) ~= num_curves || length(mdl_cell) ~= num_curves
		error('Invalid input to NLINMULTIFIT');
	end
	
	x_vec = [];
	y_vec = [];
	mdl_vec = '@(beta,x) [';
	mdl_ind1 = 1;
	mdl_ind2 = 0;
	for ii = 1:num_curves
		if length(x_cell{ii}) ~= length(y_cell{ii})
			error('Invalid input to NLINMULTIFIT');
		end
		if size(x_cell{ii},2) == 1
			x_cell{ii} = x_cell{ii}';
		end
		if size(y_cell{ii},2) == 1
			y_cell{ii} = y_cell{ii}';
		end
		x_vec = [x_vec, x_cell{ii}];
		y_vec = [y_vec, y_cell{ii}];
		mdl_ind2 = mdl_ind2 + length(x_cell{ii});
		mdl_vec = [mdl_vec, sprintf('mdl_cell{%d}(beta,x(%d:%d)), ', ii, mdl_ind1, mdl_ind2)];
		mdl_ind1 = mdl_ind1 + length(x_cell{ii});
	end
	mdl_vec = [mdl_vec(1:end-2), '];'];
	mdl_vec = eval(mdl_vec);
		
	if nargin == 4
		[beta,r,J,Sigma,mse,errorparam,robustw] = nlinfit(x_vec, y_vec, mdl_vec, beta0);
	else
		[beta,r,J,Sigma,mse,errorparam,robustw] = nlinfit(x_vec, y_vec, mdl_vec, beta0, options);
	end
end
