%Vector time series analysis
%===========================
%
%   Package for time series analysis of vector signals
%   using autoregressive models. The autoregressive model
%   is given by:
%   a0*x(n)+a1*x(n-1)+ ... +ap*x(n-p) = e(n),
%   where e(n) is a white noise signal.
%   
%Notation
%   Suppose the given signal is an 3-d signal x(n), n = 1,...,100.
%   These signals are then combined in a 3x1x100 matrix, with:
%   x(:,:,1) = x(1);
%   ...
%   x(:,:,100) = x(100),
%   For a 3-D signal, x(1),...,x(100) are 3x1 matrices.
%
%   Similarly, the parameter matrices in the autoregressive difference equation are 
%   given by an array of 3x3 matrices a0 up to ap:
%   a(:,:,1) = a0;
%   ...
%   a(:,:,p) = ap;
%
%Estimation
%   arselv             -  Parameter estimation and order selection for vector AR models
%   burgv              -  The Burg estimator for vectors (Nuttall-Strand)
%   moderrarv          -  Vector Model Error for AR models
%   kullbleibv         -  Kullback-Leibler discrepancy
%
%Parameter conversion
%   pc2covv, cov2pcv   -  partial correlations <--> covariance function
%   par2covv, cov2parv -  parameters <--> covariance function
%   pc2arset           -  partial correlations --> parameter set
%   pc2rcv, rc2pcv     -  partial correlations <--> reflection coefficients
%
%Spectra
%   pc2specv           -  Auto-and cross-spectra
%   pc2xspecv          -  Cross-spectrum
%   pc2cohv            -  Coherence function
%   
%Data processing
%   armafilterv        -  Digital ARMA filter for matrix-valued signals.
%
%   Reference:
%   S. de Waele,
%   "Automatic model inference from finite time observations
%    of stationary stochastic signals",
%   Ph.D. Thesis, Delft university of Technology, 2003.