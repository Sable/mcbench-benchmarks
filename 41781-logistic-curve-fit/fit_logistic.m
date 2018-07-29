function [ Qpre, thalf, Qinf, a] = fit_logistic(t,Q)
%fit a logistic function to time series Q(t).
%   Inputs: t (time),Q (time series variable)
%   Outputs: Qpre (logistic model fit to data) and three independent
%   parameters: thalf, Qinf, and a, describing the logistic
%   Q(t) = Qinf/(1 + exp(-a*(t-thalf)))
%   Qinf is value as t --> infinity
%   thalf is symmetric inflection point
%   a is time decay constant
%
%   Example:
%       Qinf = 10.2; a = 0.33; thalf = 108.5;
%       t = 100:120;
%       Q = Qinf./(1 + exp(-a*(t-thalf)));
%       noise = randn(1,length(t));
%       Qpre = fit_logistic(t,Q+2*noise);
%       figure(1)
%       clf
%       hold on
%       plot(t,Q+2*noise,'o')   % data
%       plot(t,Qpre)            % best fitting logistic
%       
% Written by James Conder, Southern Illinois University, Oct. 2010
% Cleaned up for publishing May 16, 2013
%   May 17, 2013: Allow for decreasing logistic
%   May 23, 2013: Fix instability when using short 
%      or long absolute times (relative to a = 1)
%   May 28, 2013: added example in comments, fixed an introduced bug
%      from May 23 edit 


% equations are set up to solve for an increasing logistic.
% Check if decreasing and if so, reverse time
[~,I] = sort(t);
reverse_t = false;
if sum(diff(Q(I))) < 0      % decreasing in time
    reverse_t = true;
    t = -t;
end

% stretch short or long sequences in time to stabilize a
tstretch = [];
if max(t)-min(t) < 1 || max(t)-min(t) > 100;
    tstretch = 1./(max(t) - min(t));
    t = t*tstretch;
end

% initial guesses for parameters
thalf = 0.5*(min(t) + max(t));
Qinf = max(Q);
a = 1;

flipQ = false;
if isrow(Q)
    flipQ = true;   % expecting a column vector. flip if row.
    t = t';
    Q = Q';
end

itermax = 1000 ;	% number of maximum iterations
epsilon = 1;

ii = 0 ;            % initialize counter
thresh = 1.e-6 ;    % threshold to stop iterating
G = zeros(length(t),3) ;    % dimensionalize partial derivative matrix

while epsilon > thresh
  ii = ii + 1 ;
  Qpre = Qinf./(1 + exp(-a*(t-thalf))) ;  % 'predicted' data
  d = Q - Qpre ;      % data vector (predicted - observed)

  % linearized partial derivatives
  ee = min(exp(-a*(t-thalf)),1.e12) ;
  eee = 1./((1 + ee).^2) ;
  G(:,1) = -Qinf*a*(ee.*eee) ;          % dd/dthalf
  G(:,2) = 1./(1 + ee) ;                % dd/dQinf
  G(:,3) = Qinf*(t-thalf).*(ee.*eee) ;  % dd/da
    
  [U,S,V] = svd(G,0);				% Singular Value Decomposition
  Sinvdiag = 1./diag(S) ;
  ising = Sinvdiag(1)./Sinvdiag < 1.e-12 ;
  Sinvdiag(ising) = 0;
  Sinv = diag(Sinvdiag);
  dm = 0.1*V*Sinv*U'*d;
							  
  % get new parameters: m = m0 + dm
  thalf = thalf + dm(1);
  Qinf = Qinf + dm(2);
  a = a + dm(3);				 
							   				  
  epsilon = norm(dm);
  if ii > itermax
	    disp('max number of iterations reached...exiting')
        disp(['normalized epsilon: ' num2str(epsilon/thresh)]) 
        epsilon = thresh ;
  end
end
Qpre = Qinf./(1 + exp(-a*(t-thalf))) ;  % 'predicted' data

if ~isempty(tstretch)
    thalf = thalf/tstretch;
    a = a*tstretch;
end  
if reverse_t        % decreasing logistic
    thalf = -thalf;
    a = -a;
end

if flipQ
    Qpre = Qpre';
end

end

