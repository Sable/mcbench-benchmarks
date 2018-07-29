function [P_fit, nps_fit] = ...
    fit_nps(nps_in, f_in, n, nps_fun, P_start, f_fit, log_fit)

% [P_fit, nps_fit] = ...
%           fit_nps(nps_in, f_in, n, nps_fun, P_start, f_fit, log_fit)
%
% Least-square fits a noise-power spectrum (NPS) to a specified function
% and returns the parameters of the fit as well as the fitted function.
%
% nps_fun is a handle to a function that accepts a parameter vector P and n
% equally sized n-dimensional arrays with Cartesian coordinates: 
% nps_fun(P, f1, f2, ..., fn).
% Start values for the fit are supplied in P_start Frequency vector for
% returning a fitted NPS are supplied in f_fit. Setting log_fit returns a
% fit in the log domain, which is useful for large ranges of data, such as
% for a power-law NPS.
%
% Erik Fredenberg, Royal Institute of Technology (KTH) (2010).
% Please reference this package if you find it useful.
% Feedback is welcome: fberg@kth.se.

% input checking
if nargin<4, f_fit = f_in; end
if nargin<5 || isempty(log_fit), log_fit=0; end

size_nps=size(nps_in);
if any(diff(size_nps(1:n)))
    error('ROI must be symmetric.');
end

if length(size_nps)==2 && size_nps(1)==1, nps_in=nps_in'; end
if size(f_in,1)==1, f_in=f_in'; end

roi_size = size(nps_in,1);
stack_size = size(nps_in,n+1); stack_size = max(stack_size, 1);

% frequency vectors
f_in_a = repmat(f_in, [1 ones(1, n-1)*roi_size]);
f_in_c = cell(1,n); for p = 1:n, f_in_c{p} = shiftdim(f_in_a, p-1); end % create arrays similar to meshgrid

f_fit_a = repmat(f_fit', [1 ones(1, n-1)*roi_size]);
f_fit_c = cell(1,n); for p = 1:n, f_fit_c{p} = shiftdim(f_fit_a, p-1); end  % create arrays similar to meshgrid

fitting_options = optimset('Display','off','FunValCheck','on');

P_fit=zeros(stack_size, length(P_start));
nps_fit=zeros(stack_size, length(f_fit));
for k=1:stack_size;
    
    nps_k = permute(nps_in, [n+1 1:n]);
    nps_k = ipermute(nps_k(k,:), [n+1 1:n]);

    if ~log_fit % lin fitting
        fit_fun = @(P) sum((nps_fun(P,f_in_c{:}) - nps_k).^2);
    elseif log_fit % log fitting
        fit_fun = @(P) sum((real(log(nps_fun(P,f_in_c{:}))) - log(nps_k)).^2);
    end
    
    P_fit(k,:) = fminsearch(fit_fun, P_start, fitting_options);
    
    nps_fit(k,:) = nps_fun(P_fit(k,:),f_fit_c{:});
    
end
end