function [Mean, Covar] = ecmnmle(Data, InitMethod, MaxIter, Tolerance, Mean0, Covar0)
%ECMNMLE Estimate mean and covariance of incomplete multivariate normal data.
%	Use the expectation conditional maximization (ECM) algorithm to estimate
%	NUMSERIES x 1 mean column vector Mean and NUMSERIES x NUMSERIES covariance
%	matrix Covar from Data, where Data has NUMSAMPLES independent
%	identically-distributed samples of NUMSERIES random variables assumed to be
%	multivariate normal with missing data indicated with NaNs. If no output
%	arguments, display a plot of convergence (or non-convergence) of algorithm
%	to a maximum likelihood estimate.
%
%	[Mean, Covar] = ecmnmle(Data);
%	[Mean, Covar] = ecmnmle(Data, InitMethod);
%	[Mean, Covar] = ecmnmle(Data, InitMethod, MaxIter);
%	[Mean, Covar] = ecmnmle(Data, InitMethod, MaxIter);
%	[Mean, Covar] = ecmnmle(Data, InitMethod, MaxIter, Tolerance);
%	[Mean, Covar] = ecmnmle(Data, InitMethod, MaxIter, Tolerance, Mean0, Covar0);
%
%	ecmnmle(Data);
%	ecmnmle(Data, InitMethod);
%	ecmnmle(Data, InitMethod, MaxIter);
%	ecmnmle(Data, InitMethod, MaxIter, Tolerance);
%	ecmnmle(Data, InitMethod, MaxIter, Tolerance, Mean0, Covar0);
%
% Inputs:
%	Data - NUMSAMPLES x NUMSERIES matrix with NUMSAMPLES samples of a
%		NUMSERIES-dimensional random vector. Missing values are indicated
%		by NaNs and are assumed to be "missing-at-random." Data is the only
%		required argument.
%
% Optional Inputs:
%	InitMethod - String to identify one of three initialization methods to
%		obtain initial estimates for the mean and covariance of the data. The
%		default method is 'nanskip'. If Mean0 and Covar0 have been supplied, then
%		the initialization method, even if explicitly specified, is not executed.
%		The initialization methods are:
%		'nanskip' - (default) Skip all records with NaNs.
%		'twostage' - Estimate mean, fill NaNs with mean, then estimate covar.
%		'diagonal' - Form a diagonal covar.
%	MaxIter - Maximum number of iterations for ECM algorithm (default value is 50).
%	Tolerance - Convergence tolerance for ECM algorithm (default value is
%		sqrt(eps) which is about 1.0e-8 for double precision). If Tolerance <= 0,
%		then do maximum number of iterations specified by MaxIter and do not
%		evaluate the objective function at each step (unless no output
%		arguments, which triggers plot of objective function).
%	Mean0 - Initial user-supplied NUMSERIES x 1 column vector estimate for
%		mean (overrides InitMethod). If Mean0 is specified, then Covar0 must also
%		be specified.
%	Covar0 - Initial user-supplied NUMSERIES x NUMSERIES matrix estimate for
%		covariance (overrides InitMethod), where the input matrix must be
%		positive-definite. If Covar0 is specified, then Mean0 must also be
%		specified.
%
% Outputs:
%	Mean - NUMSERIES x 1 column vector of maximum likelihood parameter estimates
%		for the mean of the data using the ECM algorithm.
%	Covar - NUMSERIES x NUMSERIES matrix of maximum likelihood covariance
%		estimates for the covariance of the data using the ECM algorithm.
%
% Note: The ECM algorithm does not work for every possible pattern of missing
%	values. The ECM algorithm will work in most cases but can fail to converge
%	if the covariance becomes singular. If this occurs, plots of the
%	log-likelihood function tend to have a constant upward slope over many
%	iterations as the log of the negative determinant of the covariance goes to
%	zero. In some cases, the objective will actually wander around due to machine
%	precision errors. No general theory of missingness patterns exists to
%	determine these cases (an example of a known failure mode occurs if two time
%	series are proportional).
%
% References:
%	[1] Roderick J. A. Little and Donald B. Rubin, Statistical Analysis with
%		Missing Data, 2nd ed., John Wiley & Sons, Inc., 2002.
%	[2] Xiao-Li Meng and Donald B. Rubin, "Maximum Likelihood Estimation via
%		the ECM Algorithm," Biometrika, Vol. 80, No. 2, 1993, pp. 267-278.
%	[3] Joe Sexton and Anders Rygh Swensen, "ECM Algorithms that Converge at
%		the Rate of EM," Biometrika, Vol. 87, No. 3, 2000, pp. 651-662.
%	[4] A. P. Dempster, N.M. Laird, and D. B. Rubin, "Maximum Likelihood from
%		Incomplete Data via the EM Algorithm," Journal of the Royal Statistical
%		Society, Series B, Vol. 39, No. 1, 1977, pp. 1-37.
%
%	See also: ecmninit, ecmnobj, ecmnstd, ecmnfish, ecmnhess

%	Author(s): R.Taylor, 4-18-2005
%	Copyright 2005 The MathWorks, Inc.
%	$Revision: $ $Date: $

% Step 1 - check arguments

if nargin < 6
	Covar0 = [];
end
if nargin < 5
	Mean0 = [];
end
if nargin < 4 || isempty(Tolerance)
	Tolerance = sqrt(eps);
end
if nargin < 3 || isempty(MaxIter)
	MaxIter = 50;
elseif MaxIter < 1
	MaxIter = 1;
end
if nargin < 2 || isempty(InitMethod)
	InitMethod = 'NANSKIP';
else
	InitMethod = upper(InitMethod);
	if ~any(strcmp(InitMethod,{'NANSKIP','TWOSTAGE','DIAGONAL'}))
		warning('Finance:ecmnmle:UnknownInitMethodString', ...
			'Unknown InitMethod string. Will use default NANSKIP.');
		InitMethod = 'NANSKIP';
	end
end
if nargin < 1 || isempty(Data)
	error('Finance:ecmnmle:MissingInputArg', ...
		'The required input argument Data is missing or empty.');
end

% Step 2 - initialization

[NumSamples, NumSeries] = size(Data);

DOF = NumSamples - NumSeries - sum(all(isnan(Data),2));
if DOF <= 0
	error('Finance:ecmnmle:InsufficientData', ...
		'Insufficient number of samples to estimate parameters.');
end

NaNCols = sum(isnan(Data),1);

if sum(NaNCols) == 0		% no NaNs in data so just do usual estimation
	Mean = mean(Data)';
	Covar = cov(Data,1);
	return
end

if any(NaNCols > (NumSamples - 2))
	error('Finance:ecmnmle:TooManyNaNs', ...
		'One or more data series has either all NaNs or insufficient non-NaN values.');
end

if sum(sum(isinf(Data)))
	error('Finance:ecmnmle:InfiniteValue', ...
		'One or more infinite values found in data.');
end

if isempty(Mean0) || isempty(Covar0)
	[Mean0, Covar0] = ecmninit(Data,InitMethod);
else
	Mean0 = Mean0(:);
	if ~all(size(Mean0) == [NumSeries, 1])
		error('Finance:ecmnmle:IncompatibleInitMean', ...
			'The initial mean vector Mean0 has wrong dimensions.');
	end
	if ~all(size(Covar0) == [NumSeries, NumSeries])
		error('Finance:ecmnmle:IncompatibleInitCovar', ...
			'The initial covariance matrix Covar0 has wrong dimensions.');
	end
end

Mean = Mean0;
Covar = Covar0;

if (Tolerance > 0) || ((Tolerance <= 0) && (nargout < 1))
	Objective = ecmnobj(Data,Mean,Covar);
end
Obj = [];

% Step 3 - main loop

for Iteration = 1:MaxIter

	Mean0 = Mean;
	Covar0 = Covar;

	% Step 4 - mean expectation and conditional maximization

	Z = zeros(NumSeries,1);
	Mean = zeros(NumSeries,1);

	WarnState = warning('off','MATLAB:nearlySingularMatrix');
	Count = 0;						% counts non-empty records
	for i = 1:NumSamples
		
		% expectation step
		
		[mX, mY, CXX, CXY, CYY] = ecmnpart(Data(i,:),Mean0,Covar0);

		if ~isempty(mY)
			if isempty(mX)
				Z = Data(i,:)';
			else
				P = isnan(Data(i,:));
				Q = ~P;
				Y = Data(i,Q)';
			
				Z(P) = mX + CXY * (CYY \ (Y - mY));
				Z(Q) = Y;
			end
		
			% conditional maximization step
		
			Count = Count + 1;
			Mean = Mean + Z;
		end
	end
	warning(WarnState);
	
	Mean = (1.0/Count) .* Mean;
	
	% Step 5 - covariance expectation and conditional maximization

	Z = zeros(NumSeries,1);

	Covar = zeros(NumSeries,NumSeries);
	
	WarnState = warning('off','MATLAB:nearlySingularMatrix');
	Count = 0;
	for i = 1:NumSamples

		CovAdj = zeros(NumSeries,NumSeries);

		% expectation step

		[mX, mY, CXX, CXY, CYY] = ecmnpart(Data(i,:),Mean,Covar0);

		if ~isempty(mY)
			if isempty(mX)
				Z = Data(i,:)';
			else
				P = isnan(Data(i,:));
				Q = ~P;
				Y = Data(i,Q)';

				Z(P) = mX + CXY * (CYY \ (Y - mY));
				Z(Q) = Y;
				
				CovAdj(P,P) = CXX - CXY * inv(CYY) * CXY';
			end

			% conditional maximization step

			Count = Count + 1;
			Covar = Covar + (Z - Mean) * (Z - Mean)' + CovAdj;
		end
	end
	warning(WarnState);
	
	Covar = (0.5/Count) .* (Covar + Covar');

	% Step 6 - evaluate objective and test for convergence

	if (Tolerance > 0) || ((Tolerance <= 0) && (nargout < 1))
		[CholCovar, CholState] = chol(Covar);
		
		if CholState > 0
			error('Finance:ecmnmle:NonPosDefCovar', ...
				'Full covariance not positive-definite in iteration %d.',Iteration);
		end

		Objective = ecmnobj(Data,Mean,Covar,CholCovar);
		Obj = [Obj; Objective];
		
		if Iteration > 1
			TestObj = Objective - Objective0;
			TestMean = norm(Mean - Mean0)/sqrt(NumSeries);
			
			if ((TestObj >= 0.0) && (TestObj < Tolerance)) || (TestMean < Tolerance)
				break
			end
		end
		
		Objective0 = Objective;
		Mean0 = Mean;
		
		if Iteration == MaxIter
			warning('Finance:ecmnmle:EarlyConvergence', ...
				'Maximum iterations completed, convergence criterion not satisfied ...');
		end
	end
end

% Step 7 - plot objectives if in display mode (no output args)

if ~nargout
	figure(gcf);
	plot(Obj,'-bo','MarkerFaceColor','b','MarkerSize',3);
	title('\bfProgress of ECM Algorithm in ecmnmle');
	xlabel('\bfIteration');
	ylabel('\bfLog-Likelihood');
end

function [mX, mY, CXX, CXY, CYY] = ecmnpart(z, m, C)
%ECMNPART Partition moments according to missingness pattern
%
% Inputs:
%	z - observation with possible NaN values in it
%	m - current mean estimate of data
%	C - current covariance estimate of data
%
% Outputs:
%	mX - components of m associated with missing values in z
%	mY - components of m associated with observed values in z
%	CXX - components of C associated with paired missing values in z
%	CXY - components of C associated with missing and observed values in z
%	CYY - components of C associated with paired observed values in z

P = isnan(z);
Q = ~P;

mX = m(P);
mY = m(Q);

CXX = C(P,P);
CXY = C(P,Q);
CYY = C(Q,Q);
